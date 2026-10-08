# Privacy Policy — Shishur Dinlipi

**Last updated:** 2026-10-08

Shishur Dinlipi (“the App”) is an offline-first personal journal for parents. This policy describes how information is handled in the MVP release.

## What we store

The App stores on your device:

- Child profiles and journal / health / school records you enter  
- Photos, videos, and attachments you import  
- Optional PIN / biometric unlock settings  
- Encrypted local backups you create  

## What we do not collect

The MVP does **not** require an account and does **not** upload your journal plaintext to our servers. We do not sell personal information.

## Optional cloud backup (ciphertext only)

If you choose a cloud backup provider (for example Google Drive or iCloud via OAuth), the App uploads only **password-encrypted backup packages** (ciphertext). Your journal contents are not readable by the cloud provider or by us without your backup password. OAuth tokens used for upload/download stay on your device in platform secure storage.

## On-device OCR

Document scanning uses **on-device** text recognition (ML Kit). Images and extracted text are processed locally and are not sent to our servers for OCR. You should review and correct extracted medical text before saving. Bangla script is not fully supported by the on-device engine; when using বাংলা UI we show a limitation notice so you can verify results carefully.

## Notifications & lock-screen privacy

Optional reminders you configure may appear as system notifications. When **private lock-screen notifications** is enabled (default), notification titles and bodies avoid child names and medical details on the lock screen. A privacy blur appears when the App is in the background / app switcher. On Android you may optionally enable **block screenshots** (`FLAG_SECURE`) to reduce capture risk in Recent Apps.

## Permissions

- **Camera / Photos / Microphone:** only to capture or attach media you choose  
- **Biometrics / Face ID:** optional unlock after you set a PIN  
- **Notifications:** optional reminders you configure  

## Security

- Production builds aim to encrypt the local database at rest  
- Backups use password-based encryption (AES-256-GCM)  
- A privacy blur appears when the App is in the background  

## Your controls

You can lock the App, export encrypted backups, restore backups, delete records in-app, and remove all data by clearing app storage or uninstalling.

## Contact

For privacy questions before store submission, update this section with a contact email and policy URL.
