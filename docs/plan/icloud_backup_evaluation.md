# iCloud Backup Evaluation (Optional Sprint 16)

## Goal

Optional cloud destination for encrypted `.sdjbackup` packages on Apple devices,
behind the same `BackupProvider` abstraction as Google Drive, OneDrive, and Dropbox.

## Options considered

| Approach | Pros | Cons |
| --- | --- | --- |
| **iCloud Drive ubiquity container** (`NSFileManager` ubiquity URL) | Familiar Files.app folder; works offline-first with system sync | Requires native iOS plugin + App Group / iCloud entitlements; Flutter has no first-party API |
| **CloudKit (CKRecord / CKAsset)** | Structured metadata, conflict APIs | Heavier than “drop encrypted file”; still native; not ideal for large opaque blobs |
| **Share sheet / Files picker only** | Zero entitlements; already possible via `share_plus` / document picker | Not automatic “app folder” CRUD; user must pick destination each time |
| **Third-party Flutter plugins** | Faster start | Maintenance / account / App Store review risk; often incomplete delete/list |

## Recommendation for Shishur Dinlipi

1. **Do not ship iCloud as a full `BackupProvider` in this sprint.**
2. Keep [`ICloudBackupProvider`](../../lib/core/backup/cloud/providers/icloud_backup_provider.dart) in the registry as **unsupported** so UI can explain the status.
3. On iOS, continue to rely on:
   - Local encrypted backups, and
   - System share / Files export of `.sdjbackup`.
4. Revisit iCloud when there is capacity for a small **Swift plugin** that:
   - Resolves the app’s ubiquity container,
   - Creates `Documents/ShishurDinlipi/` (or similar),
   - Implements upload / list / download / delete of `.sdjbackup` only,
   - Surfaces sync errors without reading plaintext journal data (packages stay encrypted).

## Privacy notes

- Backups remain **password-encrypted** before any cloud write (same as other providers).
- iCloud still implies Apple account sync; copy must stay clear that medical/family data leaves the device only as ciphertext.
- Prefer app-specific container over a user-visible generic folder when implementing natively.

## Exit criteria for a future iCloud sprint

- [ ] Native plugin with entitlements documented for Debug/Release
- [ ] Implements `BackupProvider` CRUD against ubiquity folder
- [ ] Conflict / “not downloaded yet” handling
- [ ] Integration tests on a physical iPhone with iCloud signed in
- [ ] EN + বাংলা UI copy for connect / errors / “open in Files”
