# Shishur Dinlipi — Architecture Overview

**Product:** Offline-first child development journal (শিশুর দিনলিপি)  
**Platforms:** Android & iOS  
**Framework:** Flutter (Dart)  
**Primary references:** `docs/design/`, `docs/feature/`, `docs/plan/`, `docs/UX/`

This document describes the **project foundation** established in Sprint 1. Detailed domain, schema, and security designs live in `docs/design/Shishur_Dinlipi_Technical_Design.md`.

---

## 1. Goals

1. Offline-first reliability — core features work without network.
2. Strong privacy — child/health data stays on-device by default.
3. Long-term data durability — years of history, safe migrations.
4. Feature-based modularity — widgets never talk to the database directly.
5. Bilingual UI — English and বাংলা as first-class locales.

---

## 2. High-level layers

```text
Presentation (Flutter widgets, screens)
        ↓
State (Riverpod — Sprint 1.2+)
        ↓
Application / Use cases
        ↓
Repositories (interfaces + implementations)
        ↓
Data sources (Drift/SQLite, secure storage, files)
```

Rules:

- No raw DB access from widgets.
- Domain models stay immutable where practical.
- Failures are typed (see Sprint 1.7 error framework).

---

## 3. `lib/` layout (Sprint 1)

```text
lib/
├── app/                 # Root app, theme, router, shell
├── core/
│   ├── config/          # Flavors & environment
│   ├── database/        # Drift AppDatabase, tables, DAOs, migrations
│   ├── domain/          # UUID generator + domain models
│   ├── repository/      # Repository contracts + Drift implementations
│   ├── mappers/         # Domain ↔ DB mapping
│   ├── security/        # Secure storage wrapper
│   ├── files/           # App-private file storage service
│   ├── media/           # Image import, thumbnails, checksums
│   ├── permissions/     # Camera/photos/notifications/biometrics
│   ├── errors/          # Typed failures + mapper
│   ├── logging/         # Privacy-safe logger
│   ├── notifications/   # Channels, IDs, initialization
│   ├── settings/        # Drift-backed app settings
│   ├── di/              # Riverpod core providers
│   ├── backup/          # Placeholder
│   └── pdf/             # Placeholder
├── features/            # splash, onboarding, home, timeline, add, albums, more, settings
├── shared/              # Shared widgets
└── l10n/                # EN + BN ARB + generated localizations
```

---

## 4. Environments & flavors

| Flavor   | Android applicationId              | iOS bundle ID                      | Entry point            |
|----------|------------------------------------|------------------------------------|------------------------|
| `dev`    | `com.shishurdinlipi.app.dev`       | `com.shishurdinlipi.app.dev`       | `lib/main_dev.dart`    |
| `staging`| `com.shishurdinlipi.app.staging`   | `com.shishurdinlipi.app.staging`   | `lib/main_staging.dart`|
| `prod`   | `com.shishurdinlipi.app`           | `com.shishurdinlipi.app`           | `lib/main_prod.dart`   |

`AppConfig` (`lib/core/config/`) controls debug logging, crash-tool hooks, and flavor banners.

Run examples:

```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor prod -t lib/main_prod.dart
```

---

## 5. Platform minimums

| Platform | Minimum                          |
|----------|----------------------------------|
| Android  | API 24 (Android 7.0)             |
| iOS      | 15.0                             |

---

## 6. Versioning

Owned by `pubspec.yaml`:

```text
version: <versionName>+<versionCode>
```

Example: `0.1.0+1`

- **versionName** (`0.1.0`) — user-visible semantic version.
- **versionCode** (`1`) — monotonically increasing store build number.

Keep `AppConfig.versionName` / `versionCode` in sync until `package_info` is wired.

---

## 7. Recommended stack (Sprint 1.2+)

| Concern            | Choice                         |
|--------------------|--------------------------------|
| State              | Riverpod                       |
| Navigation         | go_router                      |
| Local DB           | Drift + SQLite                 |
| Secure keys        | flutter_secure_storage         |
| Auth lock          | local_auth                     |
| PDF                | pdf + printing                 |
| Notifications      | flutter_local_notifications    |

---

## 8. UX authority

All UI work must follow `docs/UX/` (spec + mockups + `Icons.png`). See `.cursor/rules/ux-design.mdc`.

---

## 9. Privacy baseline

- Encrypted local database (Sprint 2+).
- App-private media storage.
- No sensitive content in logs or crash reports.
- No child/medical data shown before app unlock.
- Exports and backups only when the parent explicitly chooses.

---

## 10. Related docs

| Doc | Purpose |
|-----|---------|
| `docs/feature/…` | Product & feature requirements |
| `docs/design/…` | Full technical design |
| `docs/plan/…` | Sprint-wise implementation plan |
| `docs/plan/family_sharing_sync_research.md` | Sprint 20 discovery: E2EE family vault / sync (not implemented) |
| `docs/UX/…` | UI specification & mockups |
| `docs/architecture/GIT.md` | Git repository standards |
