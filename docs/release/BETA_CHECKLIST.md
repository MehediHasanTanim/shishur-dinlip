# Beta Rollout Checklist (§17.10)

## Internal Android

1. Build release AAB with signing (`flutter build appbundle --release`)  
2. Upload to Play Console → Internal testing  
3. Invite testers; confirm install + first launch unlock flow  
4. Collect crash / ANR from Play Vitals  

## TestFlight (iOS)

1. Archive with correct signing & privacy usage strings  
2. Upload to App Store Connect → TestFlight  
3. Invite internal testers; confirm Face ID / PIN fallback  
4. Collect feedback via TestFlight  

## Feedback categories

| Area | Ask testers |
|------|-------------|
| Crashes | Reproduce steps + device + locale |
| UX | Confusing labels, CTA reachability, empty states |
| Performance | Cold start, timeline scroll, PDF, backup time |
| বাংলা | Truncation, mixed EN/BN data, numerals, PDF fonts |

## Exit criteria for staged MVP rollout

- [ ] No P0 crashes in 48h internal beta  
- [ ] MVP regression suite green (`test/integration/mvp_regression_test.dart`)  
- [ ] Security review checklist signed off  
- [ ] Store assets + privacy policy URL live  
