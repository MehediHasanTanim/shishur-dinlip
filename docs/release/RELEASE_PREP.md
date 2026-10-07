# Release Preparation — Sprint 12 (§17.9)

## Android

| Item | Status / location |
|------|-------------------|
| App icon | `android/app/src/main/res/mipmap-*/ic_launcher.png` (from `docs/UX/Icons.png`) |
| Adaptive icon | `mipmap-anydpi-v26/ic_launcher.xml` + foreground/background |
| Splash | Flutter `LaunchScreen` / Android launch theme (cream) |
| Signing | `android/key.properties.example` → copy to `key.properties` (gitignored) |
| AAB | `flutter build appbundle --flavor prod --release` |
| Privacy | Play Data safety → see `STORE_LISTING.md` + `PRIVACY_POLICY.md` |
| Listing copy | `STORE_LISTING.md` |
| Feature graphic | `assets/branding/play_feature_graphic_1024x500.png` |

## iOS

| Item | Status / location |
|------|-------------------|
| App icon set | `ios/Runner/Assets.xcassets/AppIcon.appiconset/` |
| Launch screen | `LaunchScreen.storyboard` |
| Signing | Xcode team / provisioning (manual) |
| Privacy usage | `Info.plist` Face ID, Camera, Photos, Microphone |
| TestFlight | Archive → upload App Store Connect |
| Metadata | `STORE_LISTING.md` |

## Source branding

- Master sheet: `docs/UX/Icons.png`
- Extracted primary: `assets/branding/app_icon_1024.png`
- Play feature graphic: `assets/branding/play_feature_graphic_1024x500.png`

## Build commands

```bash
# Localizations
flutter gen-l10n

# Codegen (Drift indexes)
dart run build_runner build --delete-conflicting-outputs

# Tests
flutter test

# Prod Android AAB (requires key.properties)
flutter build appbundle --flavor prod --release

# iOS (on macOS with signing)
flutter build ipa --flavor prod --release
```
