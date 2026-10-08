# Family Sharing / Sync Research (Optional Sprint 20)

**Status:** Discovery complete — **no product sync implementation in this sprint.**  
**Date:** 2026-10-08  
**Product stance:** Offline-first child journal with strong privacy. Sharing/sync materially changes the privacy model and must not be rushed.

Primary references:

- `docs/release/PRIVACY_POLICY.md` — MVP: no account, no developer-server upload
- `docs/design/Shishur_Dinlipi_Technical_Design.md` §103 (Future Family Sharing), §121 Phase 4
- `docs/feature/Shishur_Dinlipi_Detailed_Feature_Spec.md` §55 (Shared family vault / Secure family sharing)
- Existing ciphertext backups: `lib/core/backup/backup_crypto.dart` (AES-256-GCM + PBKDF2)
- Cloud backup abstraction: `lib/core/backup/cloud/` (opaque `.sdjbackup` only)

---

## 1. Executive recommendation

| Decision | Recommendation |
| --- | --- |
| Ship multi-device sync now? | **No.** Keep MVP offline-first + encrypted backup (local / cloud file). |
| If we ever sync | **True end-to-end encryption (E2EE).** Server (or third-party cloud) stores ciphertext only. |
| First family feature (later) | Prefer **encrypted family vault invite** (multi-device restore of a shared child archive) before **live multi-writer sync**. |
| Hardest problems | Key revocation, offline merge of health records, legal/custody edge cases, privacy-policy rewrite. |
| Schema prep (when building) | Add optional `owner_id`, `created_by`, `updated_by`, `sync_version` / `lamport` — already foreshadowed in design §103. Do **not** add until a concrete sync sprint starts. |

**Do not** treat Sprint 16 cloud backup as “sync.” Cloud backup is user-initiated upload/download of an encrypted package. Family sync implies continuous or near-continuous multi-device / multi-parent mutation.

---

## 2. Current baseline (what we already have)

| Capability | Today | Sync implication |
| --- | --- | --- |
| Local DB encryption | Device key in secure storage | Per-device; not shareable as-is |
| App lock (PIN / biometrics) | Device-local | Does not authenticate a family member remotely |
| Soft deletes (`deletedAt`) | Most domain tables | Good foundation for tombstones |
| Timestamps (`updatedAt`) | Present | Needed for last-write-wins; not enough alone for concurrent edits |
| Media checksums (SHA-256) | Indexed | Dedup / identity for photos across devices |
| UUID primary keys | Everywhere | Safe for offline create without central ID allocation |
| Encrypted `.sdjbackup` | AES-256-GCM + password | Cross-device restore exists; single-writer mental model |
| Cloud backup providers | Drive / OneDrive / Dropbox (ciphertext) | Transport only; no merge |
| Child / album ownership | Implicit: “this phone’s DB” | No `owner_id` / roles yet |
| Caregiver (feature spec) | Same-device trusted user | Not a network identity |

**Privacy invariant to preserve:** Child and medical data leave the device only as parent-chosen ciphertext, or never. Any sync service that can read plaintext is a product/privacy regression.

---

## 3. Research topics

### 3.1 End-to-end encryption

**Goal:** The sync relay (our server or a cloud folder) never obtains plaintext journals, health records, or media.

#### Options

| Model | How keys work | Pros | Cons |
| --- | --- | --- | --- |
| **A. Password-derived vault key** (extend backup crypto) | Family shares a vault password → PBKDF2/Argon2 → AES key | Simple UX; reuses mental model of backup password | Password sharing is weak; rotation is painful; no per-member revoke without re-encrypt |
| **B. Per-device key pairs + envelope encryption** | Vault key encrypts data; vault key wrapped per member device public key | True E2EE; revoke by dropping wrap; no shared password | Key ceremony, recovery, and multi-device UX complexity |
| **C. Account-provider E2EE** (e.g. provider-managed) | Rely on Drive/iCloud “private” | Less crypto to build | **Not** verifiable E2EE; provider or account compromise sees data; fails product promise |
| **D. Server-side encryption at rest only** | TLS + server DEK | Easy sync | Server (and operator) can read data — **reject for this product** |

#### Recommendation

- Target **Model B** for any real family vault.
- Keep **Model A** only as a transitional “encrypted archive handoff” (similar to sharing a backup password) — document risk clearly in UI (EN + বাংলা).
- Reuse algorithms already in-app where possible: AES-256-GCM for payloads; prefer Argon2id over PBKDF2 for new vault passwords if we introduce them.
- Media: encrypt blobs with content keys; store `checksum` of plaintext for dedupe **only on-device** after decrypt (never send plaintext hashes of medical docs to a server if avoidable — prefer encrypted object IDs).

#### Threat model (minimum)

Must resist: curious cloud operator, stolen backup blob, compromised sync API logs.  
Out of scope initially: nation-state against endpoint devices, malicious co-parent with valid membership (they are authorized readers).

---

### 3.2 Sync conflict resolution

Offline-first + two parents editing the same child is the hard case.

#### Strategies

| Strategy | Fit | Notes |
| --- | --- | --- |
| **Last-write-wins (LWW) on `updatedAt`** | Acceptable for many journal fields | Clock skew → prefer hybrid logical clock / Lamport per device |
| **Tombstones (`deletedAt`)** | Required | Already in schema; deleted must win over stale updates or use delete vector |
| **Field-level merge** | Good for profiles | e.g. name vs notes edited on different devices |
| **CRDTs** | Strong for lists/sets | Higher cost; consider for album membership / favorites only |
| **Manual conflict UI** | Needed for health | Vaccination dose, growth measurement, medicine — never silent wrong merge |
| **Record identity rules** (design §102) | Import/dedupe | Child: name+DOB; vaccine: child+vaccine+dose+date; media: checksum — useful for merge assistants, not as sole sync protocol |

#### Recommended policy (future implementation)

1. Every syncable row: `id` (UUID), `updated_at`, `deleted_at`, `lamport` or `sync_version`, `updated_by_device_id`.
2. Default: **LWW by (lamport, device_id)** with tombstone precedence rules.
3. **Health domain:** if two non-deleted versions diverge on clinical fields → surface “Review conflict” in UI; do not auto-pick.
4. **Media:** content-address by checksum after decrypt; attachments are links, not duplicate bytes when possible.
5. **Year-review preferences / drafts:** LWW or device-local only (regenerable).

Avoid operational transform / full CRDT framework until pain is proven.

---

### 3.3 Family invitations

Invitation is both a **UX** and a **cryptographic join** problem.

#### Flows considered

1. **QR / link + one-time invite key**  
   Owner generates invite containing: vault ID, invite public material, expiry, role. Accepter’s device creates key pair; owner (online) wraps vault key to accepter.  
2. **Shared vault password** (low bar)  
   Owner speaks/shows password; accepter restores encrypted package. Fast but poor revocation.  
3. **Provider account ACL** (Drive folder share)  
   Shares ciphertext file access only — still need vault password/keys separately. Useful as **transport**, not as gatekeeper of plaintext.

#### Recommendation

- Product invite UX: in-app “Invite co-parent” → show QR + short code, expiry (e.g. 48h), role picker.
- Cryptographically: one-time invite secret; after accept, member gets long-lived device wrap of vault key; invite secret invalidated.
- Never put child name, photo, or medical summary in the clear invite URL/query string (use opaque IDs + encrypted payload).
- Invitation requires **explicit owner action** and bilingual explanation of what the other parent will see (including health if granted).

---

### 3.4 Parent roles

Feature spec today assumes one primary parent on one device; “trusted caregiver” is same-device.

Proposed role model for a future vault:

| Role | Read journal | Write journal | Read health | Write health | Invite / revoke | Delete child vault |
| --- | --- | --- | --- | --- | --- | --- |
| **Owner** | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| **Co-parent** | ✓ | ✓ | ✓* | ✓* | Invite only if allowed | ✗ |
| **Caregiver** | ✓ limited | ✓ limited types | ✗ or view-only | ✗ | ✗ | ✗ |
| **Viewer** (optional later) | Albums / memories only | ✗ | ✗ | ✗ | ✗ | ✗ |

\* Health access should be a **separate grant**, default off for Caregiver, default on for Co-parent with owner override.

Roles must be enforced by **which key wraps they receive** (or which encrypted collections they can open), not only by UI flags. A “Caregiver” who downloads the full vault ciphertext and has the vault key can read everything — so limited roles need **collection keys** (memories vs health), or accept that Caregiver is trust-equivalent to co-parent for any data they can decrypt.

**Pragmatic MVP of sharing (later):** Owner + Co-parent only, full vault access, no partial crypto compartments. Document that Caregiver/Viewer needs compartmentalized keys and is Phase 2 of sharing.

---

### 3.5 Device identity

| Concern | Approach |
| --- | --- |
| Device ID | Random UUID generated at first launch; stored in secure storage; not equal to advertising ID |
| Device key pair | Ed25519 or X25519 for signing/wrapping; private key never leaves secure storage |
| Display name | Parent-chosen (“Ammu’s phone”) for conflict UI |
| Rotation | New device = new key pair + re-wrap by an existing authorized device |
| Loss | Recovery via owner recovery key / vault password backup — must be designed before launch |
| Binding to app lock | App PIN unlocks local DB; sync keys stay in Keystore/Keychain; separate from family membership |

Sync protocol messages should be **signed** by device keys so members can detect tampering of ciphertext metadata (even if payload is encrypted).

---

### 3.6 Shared albums

Today albums are local rows (`albums`, `album_items`) scoped by `child_id`.

Future options:

| Approach | Description | When |
| --- | --- | --- |
| **Album as filtered view** | Shared vault syncs all memories; “shared album” is a tag/query | Simplest if full vault is shared |
| **Album as share unit** | Encrypt/share only selected album + media | Better least-privilege; harder keying |
| **Export-only share** | Generate PDF/photo pack; no live sync | Already aligned with Year Review / share_plus — **keep as default** |

Recommendation: until full vault sync exists, **do not** build live shared albums. Continue offline album PDF/export. When vault sync exists, start with album-as-view inside a fully shared child vault.

---

### 3.7 Child ownership model

Design constraint (technical design §103): do not couple entities forever to a single device user.

Recommended model:

```text
FamilyVault (id, created_at, crypto metadata)
  └── VaultMember (role, device wraps, invited_at, revoked_at)
        └── ChildRecord (child_id)  // one or more children per vault
              └── Domain rows (journals, health, media, albums, …)
```

Rules:

1. **Legal/product owner** = vault Owner role (human), not “first device.”
2. A child belongs to exactly one vault in v1 (avoids split-brain custody sync).
3. Local-only children (never shared) remain device-private with no vault id (current behavior).
4. “Handover archive for adulthood” (feature spec §55) is a **one-way encrypted export**, not ongoing sync — plan separately.
5. Custody / separation: Owner can revoke; product cannot mediate legal disputes — copy must say data access follows who holds keys + role, and recommend exporting personal copies.

Schema fields when implementing (not now):

```text
owner_id          -- vault member id of Owner
created_by        -- device or member id
updated_by        -- device or member id
sync_version      -- monotonic / Lamport
vault_id          -- nullable; null = local-only
```

---

### 3.8 Revocation

Revocation is the privacy flashpoint.

| Action | Required behavior |
| --- | --- |
| Remove member | Delete their vault-key wrap; they cannot decrypt **new** epochs |
| Forward secrecy | Rotate vault key (epoch++); re-encrypt or ratchet collection keys; old ciphertext may still be readable if they kept offline copies — **disclose this** |
| Stolen device | Owner revokes device id; victim wipes app; optional remote “tombstone auth” if we have a relay |
| Leave family | Member deletes local vault data; unwraps removed |
| Owner transfer | Explicit two-phase handoff to co-parent before original owner loses delete rights |

**Without key rotation, “revoke” is theater.** Any v1 must either:

- Rotate vault key on revoke and re-wrap for remaining members, or  
- Scope sharing to non-health export packs only.

Server-side ACL alone is insufficient if the revoked user retained ciphertext + old key.

---

### 3.9 Offline merge

Parents will edit on airplanes. Merge must work after days offline.

Pipeline (future):

```text
Local mutations → outbox (encrypted ops or row snapshots)
       ↓  (when online)
Upload ciphertext ops / row versions
       ↓
Pull remote versions
       ↓
Decrypt → merge engine → apply → conflict queue for health
       ↓
Update lamport / ack outbox
```

Guidelines:

- Prefer **row snapshot sync** (encrypted JSON per entity version) over fine-grained op logs for v1 — simpler, aligns with Drift rows.
- Cap media upload with existing import pipeline (checksum, thumbnails local).
- Partial sync: metadata first, media on Wi-Fi — UX must show “photo pending.”
- Never block journaling on network.
- Merge tests must cover: concurrent edit, delete-vs-edit, duplicate media checksum, clock skew, restore-from-backup-then-sync.

---

## 4. Architecture options (when we build)

### Option 0 — Status quo (recommended now)

Encrypted local DB + optional encrypted cloud **backup** packages.  
Cross-device = manual backup/restore.  
**No family identity.** Privacy policy unchanged.

### Option 1 — Encrypted vault handoff (lowest risk next step)

- Owner creates “Family vault package” (child-scoped or full DB subset).
- Co-parent imports with password/QR.
- Still mostly single-active-writer; optional “who last restored” warning.
- Reuses backup crypto patterns.

### Option 2 — Ciphertext sync relay (multi-device)

- Thin backend: auth of opaque vault id, store encrypted blobs, fan-out.
- Or: sync via shared cloud folder of encrypted objects (no custom server) — harder presence/push, easier privacy story (“files you control”).
- Clients own keys and merge.

### Option 3 — Full BaaS with server-readable data

**Rejected** for Shishur Dinlipi’s privacy positioning.

---

## 5. Privacy, legal, and product impact

Shipping any of Options 1–2 requires:

1. **Privacy policy rewrite** — accounts or vault IDs, what metadata the relay sees (timestamps, approximate sizes, member count), retention, deletion.
2. **Store listings** — can no longer claim “never leaves device” without qualification.
3. **Support burden** — lost vault password ≈ unrecoverable data (correct for E2EE); must educate in EN + বাংলা.
4. **Health data** — higher sensitivity; consider vault-level “include health in sync” default **off** until co-parent explicitly enables.
5. **Notifications** — sync push must not leak child names in notification bodies (existing privacy blur / notification rules apply).

---

## 6. Suggested phased roadmap (post–Sprint 20)

| Phase | Scope | Exit criteria |
| --- | --- | --- |
| **R0 — Done (this sprint)** | Research doc + explicit non-goals | Stakeholders agree sync is not MVP |
| **R1 — Schema-ready (optional)** | Document-only field list; still no sync code | Design review |
| **R2 — Vault handoff prototype** | Child-scoped encrypted package + invite password; import on second device | Manual test two phones; no relay |
| **R3 — Device identity + roles** | Owner / Co-parent; device keys; revoke + key rotate | Security review |
| **R4 — Multi-writer sync** | Outbox, LWW + health conflict UI, media pipeline | Conflict test suite; threat model review |
| **R5 — Shared albums / caregiver** | Compartmentalized keys if needed | Role matrix tests |

Do **not** start R4 until R2–R3 prove key UX and revocation.

---

## 7. Explicit non-goals of Sprint 20

- No sync server, WebSocket, or Firebase/Supabase integration
- No `vault_id` / `owner_id` schema migration yet
- No family invite UI
- No change to privacy policy production text beyond acknowledging research
- No weakening of local encryption or backup password requirements

---

## 8. Open questions (product)

1. Is the primary need **second parent on another phone**, or **same family viewing albums only**?
2. Must health records sync in v1, or memories-only first?
3. Will we operate a relay, or only sync via user-owned cloud folders?
4. Recovery: paper recovery key vs vault password vs “no recovery by design”?
5. Geography / data residency if we run a relay (especially for BD families abroad)?

---

## 9. Exit criteria (Sprint 20)

- [x] E2EE options compared; Model B recommended for real sharing
- [x] Conflict / offline merge policy sketched
- [x] Invitation, roles, device identity, ownership, revocation analyzed
- [x] Shared albums deferred to post-vault
- [x] Phased roadmap with hard stop on rushing multi-writer sync
- [x] Linked from sprint plan §27

---

## 10. Related code & docs (read before any implementation sprint)

| Path | Why |
| --- | --- |
| `lib/core/backup/backup_crypto.dart` | Cipher patterns to extend carefully |
| `lib/core/backup/cloud/backup_provider.dart` | Transport abstraction for opaque packages |
| `lib/core/security/db_encryption_key_store.dart` | Device-local DB key (not vault key) |
| `lib/core/media/` | Checksums / import — media identity |
| `docs/plan/icloud_backup_evaluation.md` | Precedent for discovery-only sprints |
| `docs/design/…` §103, §121 | Future fields & Phase 4 placement |
