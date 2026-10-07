# Shishur Dinlipi — শিশুর দিনলিপি

Offline-first **child development journal** for parents: growth, health, milestones, memories, and yearly keepsakes — private by default, English + বাংলা.

## Status

Sprint **1 — Project Foundation & Architecture** (shell, themes, l10n, routing, CI).

## Requirements

- Flutter **3.47+** (stable)
- Xcode 15+ (iOS)
- Android SDK with API **24+** device/emulator

## Application IDs

| Flavor | Android | iOS |
|--------|---------|-----|
| Development | `com.shishurdinlipi.app.dev` | `com.shishurdinlipi.app.dev` |
| Staging | `com.shishurdinlipi.app.staging` | `com.shishurdinlipi.app.staging` |
| Production | `com.shishurdinlipi.app` | `com.shishurdinlipi.app` |

**Minimum OS:** Android 7.0 (API 24) · iOS 15.0

## Getting started

```bash
flutter pub get
flutter run --flavor dev -t lib/main_dev.dart
```

Other flavors:

```bash
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor prod -t lib/main_prod.dart
```

## Versioning

`pubspec.yaml` uses `versionName+versionCode` (e.g. `0.1.0+1`).  
Bump **versionName** for user-facing releases; bump **versionCode** for every store build.

## Documentation

| Path | Contents |
|------|----------|
| [docs/architecture/ARCHITECTURE.md](docs/architecture/ARCHITECTURE.md) | Architecture overview |
| [docs/architecture/GIT.md](docs/architecture/GIT.md) | Git standards |
| [docs/UX/](docs/UX/) | **UI source of truth** (mockups + icons) |
| [docs/feature/](docs/feature/) | Feature specification |
| [docs/design/](docs/design/) | Technical design |
| [docs/plan/](docs/plan/) | Sprint implementation plan |

## Project layout (target)

```text
lib/
  app/       # Root app, theme, router
  core/      # Config, DB, security, files, …
  features/  # Feature modules
  shared/    # Shared UI & helpers
```

## License

Private / unpublished — rights reserved by the project owner.
