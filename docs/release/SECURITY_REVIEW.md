# Sprint 12 — Security Review Checklist

Status: **complete for MVP RC** (local review). Re-check before each store submission.

## Secrets in source

- [x] No API keys, passwords, or encryption keys hardcoded in `lib/`
- [x] Release signing uses `android/key.properties` (gitignored) — see `key.properties.example`
- [x] Secure storage keys are identifiers only (`SecureStorageKeys`)

## Sensitive logs

- [x] `AppLogger` redacts names, notes, paths, passwords, PINs, letters, quotes, keys
- [x] Production flavor disables verbose logging via `AppConfig.enableDebugLogging`
- [ ] Confirm crash reporters (if added later) scrub the same fields

## Database encryption

- [x] Production opens SQLite with `PRAGMA key` when sqlite3mc/SQLCipher is available
- [x] Encryption key generated and stored in platform secure storage
- [x] Plain → encrypted migration path via `PRAGMA rekey`
- [ ] Device QA: verify `PRAGMA cipher_version` / encrypted file unreadable without key

### Device QA how-to — `cipher_version`

On a physical device or emulator with a production/staging build that uses sqlite3mc:

1. Locate the app DB under application support (Android: app data; iOS: Application Support). Path is typically under `…/shishur_files` adjacent to the Drift DB file created by the app.
2. With a SQLCipher-compatible CLI (`sqlcipher` or `sqlite3` linked to sqlite3mc), open the DB **without** a key and confirm the file is unreadable (garbled / “file is not a database”).
3. Open with the device key from secure storage (dev builds may log presence of encryption, never the key itself) and run:

   ```sql
   PRAGMA cipher_version;
   ```

   Expect a non-empty version string (e.g. SQLCipher / sqlite3mc build id).
4. Confirm `SELECT count(*) FROM sqlite_master;` succeeds only with the correct key.
5. Leave this checkbox unchecked until the above is signed off on a real device build.

## Backup encryption

- [x] `.sdjbackup` = ZIP + AES-256-GCM, password via PBKDF2
- [x] Wrong password / corrupt package rejected in tests
- [x] Password confirmation required on create

## App-private media

- [x] Media under application support `shishur_files/` (not shared storage)
- [x] Android scoped storage permissions only for picker import
- [x] iOS photo/camera usage strings present in `Info.plist`

## Biometric fallback

- [x] Biometrics require PIN first
- [x] Unlock UI falls back to PIN on biometric failure / enrollment change
- [x] Auto-lock + unlock gate via `appUnlockedProvider`

## Screenshots / app switcher

- [x] Blur overlay while app is inactive/paused (`AppPrivacyLifecycle`)
- [x] Auto-lock after configured timeout on resume
- [x] Optional Android `FLAG_SECURE` via Settings → Security (`FlagSecure` / `com.shishurdinlipi.app/flag_secure`); off by default, user-toggleable

## Privacy declarations

- [x] iOS usage descriptions: Face ID, Camera, Photos, Microphone
- [x] Play / App Store privacy copy drafts in `docs/release/STORE_LISTING.md`
