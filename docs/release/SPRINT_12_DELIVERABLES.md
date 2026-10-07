# Sprint 12 Deliverables

| Deliverable | Location / evidence |
|-------------|---------------------|
| Production RC readiness | Schema v9, encrypted DB/backup, unlock, store assets |
| Automated regression | `test/integration/mvp_regression_test.dart` (+ full `flutter test`) |
| Store assets | `assets/branding/`, Android mipmaps, iOS AppIcon, `STORE_LISTING.md` |
| Privacy / security review | `SECURITY_REVIEW.md`, `PRIVACY_POLICY.md` |
| MVP staged rollout | Follow `BETA_CHECKLIST.md` (Internal track + TestFlight) |

## §17 map

1. **Performance** — indexes, `AppThumbnail` + decode cache, timeline `cacheWidth`  
2. **Indexes** — `@TableIndex` + `_ensurePerformanceIndexes` (v9)  
3. **Accessibility** — `ACCESSIBILITY.md`, `AppStateViews` / `AppTouchTarget`  
4. **Localization QA** — `LOCALIZATION_QA.md`, EN/BN state+storage strings  
5. **Common UI states** — `lib/shared/widgets/app_state_views.dart`  
6. **Storage** — Settings → Storage; temp / export / orphan cleanup  
7. **Integration tests** — MVP regression path  
8. **Security** — checklist complete for MVP RC  
9. **Release prep** — `RELEASE_PREP.md`, signing example, icons, splash  
10. **Beta** — `BETA_CHECKLIST.md` (manual store upload next)  
