# Localization QA (§17.4)

Review every primary screen in **English** and **বাংলা**.

## Screens checklist

- [ ] Launch / onboarding / unlock  
- [ ] Home  
- [ ] Timeline + filters  
- [ ] Quick Add  
- [ ] Journal / Funny / Achievements forms  
- [ ] Growth / Milestones / First words  
- [ ] School  
- [ ] Health (vaccination, illness, medicine, doctor)  
- [ ] Photos / Albums  
- [ ] Search  
- [ ] Reminders / Calendar  
- [ ] Year in Review + PDF  
- [ ] Backup / Restore  
- [ ] Settings / Security / Storage  
- [ ] Common states (empty, error, permission)  

## Test cases

| Case | What to verify |
|------|----------------|
| Truncation | Titles/CTAs use ellipsis; no clipped Bengali glyph bottoms |
| Long labels | BN strings longer than EN still fit 360px width |
| Bengali numerals | Dates/ages respect locale formatting where applicable |
| Mixed-language data | User EN title + BN body renders without font fallback boxes |
| PDF fonts | Year in Review PDF embeds Noto Sans Bengali + Latin fallback |

## Fonts

- UI: system + Material (Bengali via OS fonts)  
- PDF: `assets/fonts/NotoSansBengali-Regular.ttf`, `NotoSans-Regular.ttf`  
