# Accessibility Audit (§17.3)

## Pass criteria (MVP)

| Area | Approach |
|------|----------|
| Semantics | `AppStateViews` live regions; photo tiles labeled; skeleton labeled |
| Dynamic text | Material tap targets padded; list tiles min vertical padding 12 |
| Contrast | Forest teal CTAs on cream; avoid color-only meaning (icons + text) |
| Bengali readability | Prefer natural BN copy; PDF Noto Bengali; UI uses OS fonts |
| Touch targets | `AppTouchTarget` 48×48; `IconButton` min 48×48 |
| Focus order | Standard Flutter focus traversal on forms; sticky CTAs at bottom |
| Screen reader | Empty/error/loading expose labels; confirm dialogs use Cancel/Delete |

## Manual device checks before store

1. TalkBack / VoiceOver: unlock → home → add journal → save  
2. Largest text size: home, timeline cards, settings rows  
3. BN locale: bottom nav labels fully visible  
4. Reduce motion: no essential info only in animation  
