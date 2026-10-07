# Shishur Dinlipi — Sprint-wise Technical Implementation Plan
## Child Development Journal

**Product Name:** Shishur Dinlipi  
**বাংলা নাম:** শিশুর দিনলিপি  
**Document Type:** Sprint-wise Technical Implementation Plan  
**Target Platforms:** Android and iOS  
**Recommended Framework:** Flutter  
**Architecture:** Offline-first, local encrypted storage  
**Sprint Length Assumption:** 2 weeks  
**Core MVP Duration:** 12 sprints / ~24 weeks  
**Optional Advanced Phases:** Additional sprints after MVP  

---

# 1. Implementation Goals

The implementation should deliver a production-ready mobile application that allows parents to:

- Create multiple child profiles.
- Track height and weight.
- Record developmental milestones.
- Record first words and first steps.
- Record school milestones.
- Maintain vaccination history.
- Track illnesses.
- Track medicines.
- Record doctor visits.
- Attach photos and documents.
- Record achievements.
- Record funny moments.
- Write general journal entries.
- Browse a unified child timeline.
- Search historical records.
- Generate an offline “Year in Review”.
- Export the review as PDF/photo album.
- Use the application in English or বাংলা.
- Protect private child data with local encryption and app lock.
- Create and restore encrypted local backups.

---

# 2. Delivery Strategy

Implementation is divided into four major stages.

## Stage 1 — Foundation

Sprints 1–2

Deliver:

- Project structure.
- Architecture.
- Database foundation.
- Localization.
- Navigation.
- Theme.
- Error framework.
- Basic security foundation.

## Stage 2 — Core Child Journal

Sprints 3–7

Deliver:

- Child profiles.
- Timeline.
- Journal.
- Growth.
- Milestones.
- School.
- Health modules.

## Stage 3 — Memories & Keepsakes

Sprints 8–10

Deliver:

- Photos.
- Achievements.
- Funny moments.
- Search.
- Albums.
- Year in Review.
- PDF generation.

## Stage 4 — Production Hardening

Sprints 11–12

Deliver:

- Backup/restore.
- PIN/biometric security.
- Performance.
- Accessibility.
- Testing.
- Store readiness.
- MVP release.

---

# 3. Team Assumption

Suggested minimum delivery team:

- 1 Flutter Engineer.
- 1 Backend-equivalent Mobile/Data Engineer or second Flutter Engineer.
- 1 UI/UX Designer.
- 1 QA Engineer.
- Part-time Product Owner / PM.

Because the app has no core backend, engineering effort is concentrated on:

- Mobile architecture.
- Local persistence.
- Media handling.
- Backup/restore.
- PDF generation.
- Security.

---

# 4. Definition of Done

A task is considered complete only when:

- Functional requirements are implemented.
- Unit tests are added where practical.
- UI states are handled.
- English and বাংলা strings are included.
- Accessibility labels are present.
- Error states are handled.
- No sensitive data is logged.
- Code review is complete.
- QA acceptance criteria are passed.
- No critical blocker remains.

---

# 5. Engineering Standards

Throughout all sprints:

- Use feature-based modular architecture.
- Keep widgets free of raw database logic.
- Use repositories and use cases.
- Use Riverpod for state.
- Use Drift for relational local storage.
- Use UUID identifiers.
- Use app-private media storage.
- Use typed failures.
- Preserve data across migrations.
- Add tests with every feature.
- Never hard-code user-facing strings.
- Never hard-code encryption keys.

---

# 6. Sprint 1 — Project Foundation & Architecture

## Sprint Goal

Create a stable Flutter project foundation that future features can build on safely.

## 6.1 Project Setup

Tasks:

- Create Flutter project.
- Configure application IDs for Android and iOS.
- Set minimum supported Android version.
- Set minimum supported iOS version.
- Configure development, staging, and production flavors.
- Add environment configuration.
- Configure versioning.
- Add Git repository standards.
- Add `.gitignore`.
- Add README.
- Add architecture documentation.

## 6.2 Dependency Setup

Add and configure:

- flutter_riverpod.
- riverpod_annotation.
- go_router.
- drift.
- sqlite3_flutter_libs.
- path_provider.
- uuid.
- intl.
- flutter_secure_storage.
- local_auth.
- image_picker.
- flutter_local_notifications.
- timezone.
- pdf.
- printing.
- share_plus.
- archive.
- crypto.
- fl_chart.

## 6.3 Folder Structure

Create:

```text
lib/
├── app/
├── core/
├── features/
└── shared/
```

Create baseline submodules:

```text
core/database
core/security
core/files
core/errors
core/logging
core/notifications
core/backup
core/pdf
```

## 6.4 App Shell

Implement:

- Root app.
- Material 3 theme.
- Light theme.
- Dark theme.
- System theme.
- Base typography.
- Bengali-friendly typography.
- Global scaffold patterns.

## 6.5 Navigation

Implement GoRouter.

Routes:

- Splash.
- Onboarding.
- Home.
- Timeline.
- Add.
- Albums.
- More.
- Settings.

Add route guards where future app-lock support will apply.

## 6.6 Localization Foundation

Create:

- `app_en.arb`
- `app_bn.arb`

Implement:

- English.
- বাংলা.
- Language switching.
- Locale persistence.

Add initial common strings.

## 6.7 Error Framework

Implement typed failures:

- DatabaseFailure.
- FileFailure.
- ValidationFailure.
- PermissionFailure.
- BackupFailure.
- RestoreFailure.
- PdfGenerationFailure.

Create:

- Error mapper.
- Localized error messages.
- Generic retry state.

## 6.8 Logging

Implement safe logger.

Requirements:

- Debug logging in dev only.
- Redact sensitive fields.
- No journal text in logs.
- No health notes in logs.
- No child photos or file contents in logs.

## 6.9 CI

Set up pipeline:

- Format check.
- Flutter analyze.
- Unit tests.
- Android build.
- iOS build where runner environment supports it.

## Sprint Deliverables

- App launches on Android and iOS.
- Bottom shell/navigation exists.
- English/বাংলা switching works.
- Theme switching works.
- CI succeeds.
- Architecture foundation documented.

## Sprint QA

Test:

- App cold start.
- Route navigation.
- Theme change.
- Language change.
- Rotation where supported.
- Basic accessibility labels.
- Release build compilation.

---

# 7. Sprint 2 — Local Database, Storage & Core Infrastructure

## Sprint Goal

Create the persistence and local infrastructure required by all functional modules.

## 7.1 Drift Database Setup

Implement:

- AppDatabase.
- Schema versioning.
- Migration framework.
- Connection provider.
- Transaction helper.

## 7.2 Base Tables

Create:

- children.
- settings.
- media_assets.
- attachments.
- reminders.
- tags.
- tag_links.
- audit_events.

## 7.3 Common Entity Fields

Standardize:

- id.
- created_at.
- updated_at.
- deleted_at.

Implement UUID generator.

## 7.4 Repository Base Patterns

Create:

- Repository contracts.
- DAO pattern.
- Mapping utilities.
- Domain-to-database mappers.

## 7.5 File Storage Service

Implement app-private directories:

```text
media/images
media/thumbnails
media/documents
exports/pdf
exports/album_images
backups
temp
```

Implement:

- Directory bootstrap.
- File naming.
- Temp-file cleanup.
- Atomic writes where possible.

## 7.6 Media Service Foundation

Implement:

- Import image.
- Copy image into app-private storage.
- Extract metadata.
- Generate thumbnail.
- Generate checksum.
- Create media record.
- Delete unused media safely.

## 7.7 Settings Storage

Implement:

- Selected language.
- Theme.
- Selected child.
- Height unit.
- Weight unit.
- Temperature unit.
- Bengali digit preference.

## 7.8 Permission Abstraction

Implement service for:

- Camera.
- Photos.
- Notifications.
- Biometrics.

Request permissions only at point of use.

## 7.9 Local Notification Foundation

Configure:

- Initialization.
- Android notification channels.
- iOS permissions.
- Timezone initialization.
- Notification ID management.

## Sprint Deliverables

- Database created.
- Migrations tested.
- Media can be imported privately.
- Thumbnail generation works.
- Settings survive app restart.
- Local notification engine initialized.

## Sprint QA

Test:

- Fresh install.
- App restart.
- Schema migration simulation.
- Import large image.
- Broken file case.
- Permission denial.
- Temp cleanup.
- Media checksum generation.

---

# 8. Sprint 3 — Child Profiles, Onboarding & Child Context

## Sprint Goal

Allow users to create and manage children, complete first-run onboarding, and establish child-scoped app behavior.

## 8.1 First Run

Implement flow:

- Splash.
- Language selection.
- Privacy summary.
- Create first child.
- Optional security skip.
- Home.

## 8.2 Child Profile Data

Extend children table as defined in technical design.

Fields:

- Name.
- Nickname.
- Date of birth.
- Gender.
- Blood group.
- Birth weight.
- Birth height.
- Birthplace.
- School.
- Class.
- Profile photo.
- Notes.

## 8.3 Child CRUD

Implement:

- Create child.
- Edit child.
- View child.
- Soft delete child.
- Confirm deletion.

## 8.4 Multiple Children

Implement:

- Child switcher.
- Selected child persistence.
- Child context provider.
- Empty no-child state.

## 8.5 Age Calculation

Implement domain utility:

- Current age.
- Age at event.
- Years/months/days.
- Localized formatting.

## 8.6 Profile Photo

Implement:

- Camera.
- Gallery.
- Crop optional.
- Thumbnail.
- Replace.
- Remove.

## 8.7 Dashboard Skeleton

Create first dashboard shell with:

- Child header.
- Current age.
- Empty growth snapshot.
- Recent memories placeholder.
- Quick Add.
- Upcoming reminders placeholder.

## Sprint Deliverables

- Parent can create multiple child profiles.
- Child switcher updates app context.
- Profile details display correctly.
- Age calculation works.
- English/বাংলা profile flows complete.

## Sprint QA

Test:

- Create one child.
- Create multiple children.
- Switch children.
- Edit child.
- Invalid DOB.
- Profile photo add/remove.
- Bengali text input.
- Child deletion safeguards.

---

# 9. Sprint 4 — General Journal, Funny Moments & Achievements

## Sprint Goal

Deliver the first real journaling experience so parents can start preserving memories.

## 9.1 Journal Schema

Create:

- journal_entries.
- funny_moments.
- achievements.

## 9.2 General Journal

Implement:

- Add memory.
- Edit memory.
- Delete memory.
- Favorite memory.
- Date.
- Title.
- Story.
- Mood.
- Location text.
- Tags.
- Attach photos.

## 9.3 Quick Journal Templates

Implement:

- Something funny.
- Something new.
- Proud moment.
- Difficult day.
- Favorite moment.
- Photo memory.

## 9.4 Funny Moments

Implement:

- Add funny moment.
- Funny quote.
- Story.
- Who was present.
- Favorite flag.
- Attach media.

## 9.5 Achievements

Implement:

- Add achievement.
- Category.
- Date.
- Description.
- Certificate/photo attachment.
- Favorite flag.

## 9.6 Reusable Attachment UI

Build:

- Attachment strip.
- Photo picker.
- Preview.
- Reorder.
- Remove.

## 9.7 Recent Memories

Update dashboard:

- Show latest journal.
- Show funny moment.
- Show achievement.
- Show thumbnail.

## Sprint Deliverables

- Parents can record general memories.
- Funny moments and achievements are functional.
- Photos can be attached.
- Recent memory cards display on home.

## Sprint QA

Test:

- Add/edit/delete journal.
- Multiple photos.
- Broken attachment.
- Long Bengali content.
- Emoji.
- Favorite/unfavorite.
- Draft loss warning.
- Empty states.

---

# 10. Sprint 5 — Growth Tracking & Developmental Milestones

## Sprint Goal

Implement core child development tracking.

## 10.1 Growth Schema

Create:

- growth_records.

## 10.2 Growth Entry

Implement:

- Height.
- Weight.
- Date.
- Location.
- Notes.

Canonical storage:

- cm.
- kg.

## 10.3 Unit Conversion

Implement:

- cm ↔ ft/in.
- kg ↔ lb.

## 10.4 Growth History

Implement:

- Chronological list.
- Latest value.
- Previous value.
- Difference.

## 10.5 Growth Charts

Implement:

- Height chart.
- Weight chart.
- Date axis.
- Localized values.

## 10.6 Milestone Schema

Create:

- milestones.
- first_words.

## 10.7 Milestone Categories

Implement:

- Movement.
- Speech.
- Social.
- Self-care.
- Learning.
- Custom.

## 10.8 Milestone Templates

Implement quick actions:

- First crawl.
- First stand.
- First step.
- First walk.
- First run.
- First bicycle ride.
- First word.
- First sentence.
- Wrote own name.

## 10.9 Approximate Dates

Implement:

- Exact date.
- Month only.
- Year only.
- Approximate.
- Unknown.

## 10.10 First Words

Implement:

- Word.
- Language.
- Date.
- Story/context.
- Optional audio placeholder or future flag.

## Sprint Deliverables

- Growth tracking complete.
- Growth charts functional.
- Milestones complete.
- Approximate historical dates supported.
- First words journal functional.

## Sprint QA

Test:

- Unit conversions.
- Invalid values.
- Future date validation.
- Many growth points.
- Approximate date formatting.
- Bengali numerals.
- Multiple milestone categories.

---

# 11. Sprint 6 — School & Learning History

## Sprint Goal

Deliver school-related milestones and academic memory tracking.

## 11.1 School Schema

Create:

- school_profiles.
- school_events.

## 11.2 School Profile

Implement:

- School name.
- Start date.
- End date.
- Current class.
- Teacher.
- Notes.

## 11.3 School Events

Support:

- First day.
- Exam.
- School performance.
- Sports event.
- Certificate.
- Class promotion.
- Project.
- Report card.
- Custom.

## 11.4 Document Attachments

Allow:

- Report card image.
- Certificate.
- PDF.
- School photo.

## 11.5 School Timeline

Create school-specific timeline.

## 11.6 Dashboard Integration

Show:

- Recent school event.
- Latest achievement.
- Upcoming school milestone if manually added.

## Sprint Deliverables

- School profile complete.
- School milestones can be added.
- Certificates/report cards supported.
- School events appear in child history.

## Sprint QA

Test:

- School changes.
- Multiple schools.
- Missing end date.
- Certificate image.
- PDF attachment.
- Class history.

---

# 12. Sprint 7 — Health: Vaccination, Illness, Medicine & Doctor Visits

## Sprint Goal

Build the full offline child health record.

## 12.1 Health Schemas

Create:

- vaccinations.
- illness_episodes.
- medicines.
- medicine_schedules.
- doctor_visits.
- medical_documents.

## 12.2 Vaccination

Implement:

- Add vaccination.
- Vaccine name.
- Dose.
- Scheduled date.
- Given date.
- Provider.
- Clinic.
- Batch number.
- Status.
- Notes.
- Vaccination card attachment.

Statuses:

- Upcoming.
- Completed.
- Delayed.
- Skipped.
- Unknown.

## 12.3 Illness History

Implement:

- Start/end date.
- Symptoms.
- Temperature.
- Diagnosis.
- Recovery note.
- Doctor relationship.
- Attachments.

## 12.4 Symptom Selector

Quick-select:

- Fever.
- Cough.
- Cold.
- Vomiting.
- Diarrhea.
- Rash.
- Headache.
- Stomach pain.
- Breathing difficulty.
- Allergy.
- Injury.
- Other.

## 12.5 Medicine

Implement:

- Name.
- Strength.
- Dose.
- Frequency.
- Start/end.
- Reason.
- Prescriber.
- Status.
- Notes.

## 12.6 Doctor Visits

Implement:

- Doctor.
- Specialty.
- Chamber/hospital.
- Reason.
- Symptoms.
- Diagnosis.
- Tests.
- Follow-up date.
- Notes.
- Prescription attachment.

## 12.7 Medical Documents

Implement centralized list:

- Prescription.
- Diagnostic report.
- Vaccination card.
- Discharge summary.
- Medical certificate.
- Other.

## 12.8 Health Summary

Build basic child health summary:

- Blood group.
- Latest growth.
- Current medicine.
- Recent illness.
- Vaccination.
- Last doctor visit.

Add medical disclaimer.

## Sprint Deliverables

- Parent can manage core child health history.
- Medical documents are linked to relevant records.
- Health summary available.
- Health records remain completely offline.

## Sprint QA

Test:

- Ongoing illness.
- Completed illness.
- Active medicine.
- Medicine stopped.
- Missing diagnosis.
- Vaccine scheduled vs completed.
- Doctor visit attachment.
- Bengali health notes.
- Health disclaimer.

---

# 13. Sprint 8 — Reminders, Calendar & Unified Timeline

## Sprint Goal

Connect all modules into a cohesive time-based child history and local reminder system.

## 13.1 Unified Timeline

Build query/service that combines:

- Journal.
- Growth.
- Milestones.
- School.
- Vaccinations.
- Illnesses.
- Doctor visits.
- Achievements.
- Funny moments.

## 13.2 Timeline Pagination

Implement:

- Initial page.
- Load more.
- Date ordering.
- Child scope.
- Filter.

## 13.3 Timeline Filters

Support:

- All.
- Memories.
- Growth.
- Milestones.
- Health.
- School.
- Achievements.
- Photos.
- Funny moments.

## 13.4 Timeline Card Design

Standardize:

- Date.
- Category icon.
- Title.
- Subtitle.
- Child age.
- Thumbnail.

## 13.5 Reminder Engine

Implement database-backed reminders.

Types:

- Vaccination.
- Medicine.
- Doctor follow-up.
- Birthday.
- Weekly memory prompt.
- Backup reminder.

## 13.6 Notification Scheduling

Implement:

- Create.
- Update.
- Cancel.
- Reschedule.
- Timezone safety.

## 13.7 Calendar View

Implement:

- Month view.
- Event indicators.
- Date detail.
- Filter by event type.

## 13.8 On This Day

Implement local historical query.

Dashboard card:

- 1 year ago.
- 2 years ago.
- etc.

## Sprint Deliverables

- Unified child timeline works.
- Timeline is paginated.
- Filters work.
- Reminders generate local notifications.
- Calendar history works.
- On This Day works.

## Sprint QA

Test:

- Thousands of timeline entries.
- Same-day event ordering.
- Notification permission denied.
- Timezone changes.
- App restart.
- Reminder reschedule.
- Child switch.

---

# 14. Sprint 9 — Search, Tags, Photos & Album Foundation

## Sprint Goal

Make long-term historical records easy to find and organize.

## 14.1 Global Search

Implement initial SQL search across:

- Journal.
- Milestones.
- Medicines.
- Doctors.
- Illnesses.
- School.
- Achievements.

## 14.2 Search UX

Support:

- Search query.
- Child scope.
- Result type.
- Date filtering.
- Empty result state.
- Recent searches optional.

## 14.3 Tags

Implement:

- Add tag.
- Remove tag.
- Reuse tag.
- Tag filter.

## 14.4 Photo Library

Build in-app photo view grouped by:

- Year.
- Age.
- Category.
- Favorites.

## 14.5 Favorite Photos

Implement:

- Favorite/unfavorite.
- Favorite list.
- Use preference in future album selection.

## 14.6 Album Schema

Create:

- albums.
- album_items.
- generated_exports.

## 14.7 Basic Albums

Implement:

- Custom album.
- Add/remove items.
- Reorder.
- Cover photo.
- Title.
- Theme placeholder.

## Sprint Deliverables

- Global local search works.
- Tags work.
- Photo library works.
- Custom album foundation exists.
- Favorite photos supported.

## Sprint QA

Test:

- English search.
- Bengali search.
- Mixed-language query.
- Large result set.
- Tag duplicates.
- Missing media.
- Album reorder.

---

# 15. Sprint 10 — Year in Review & Offline PDF Generation

## Sprint Goal

Deliver the app's signature feature: automatically generated child yearly memory album.

## 15.1 Year Review Query Engine

Implement:

- Child.
- Year/date range.
- Age at review.
- Growth summary.
- Milestones.
- School events.
- Achievements.
- Funny moments.
- Favorite photos.
- Birthday.
- Journal highlights.
- Optional health highlights.

## 15.2 Highlight Selection

Prioritize:

1. Favorites.
2. Milestones.
3. Achievements.
4. Birthday.
5. Funny quotes.
6. School memories.
7. Photos.
8. Journal entries.

## 15.3 Review Editor

Parent can:

- Include item.
- Exclude item.
- Reorder section.
- Edit caption.
- Choose cover.
- Add parent letter.

## 15.4 Year Review Preferences

Create:

- year_review_preferences.

Store:

- Theme.
- Cover.
- Health inclusion.
- Language.
- Parent letter.

## 15.5 PDF Theme Engine

Implement MVP themes:

- Minimal.
- Playful.
- Colorful.
- Elegant.

## 15.6 Bengali PDF Font

Bundle offline Bengali font with appropriate license.

Test:

- Bengali headings.
- Long Bengali paragraphs.
- Mixed English/বাংলা.

## 15.7 PDF Generation Pipeline

Implement:

- Prepare data.
- Optimize images.
- Build cover.
- Render sections.
- Save temp.
- Validate.
- Move to exports.
- Persist export metadata.

## 15.8 Progress UI

Show:

- Preparing memories.
- Processing photos.
- Building pages.
- Saving PDF.
- Complete.

## 15.9 PDF Actions

Implement:

- Preview.
- Share.
- Save/export.
- Print where supported.

## Sprint Deliverables

User can generate:

> Azwad — Age 5: Year in Review

entirely offline.

## Sprint QA

Test:

- No photos.
- Hundreds of photos.
- Bengali-only review.
- Mixed-language review.
- Large images.
- Long parent letter.
- Health section disabled.
- Interrupted generation.
- Low storage.
- PDF reopen.

---

# 16. Sprint 11 — Privacy, PIN, Biometrics & Backup/Restore

## Sprint Goal

Protect long-term child data and provide safe data portability.

## 16.1 Secure Storage

Implement:

- Encryption key storage.
- PIN verifier storage.
- Security settings.

## 16.2 Database Encryption

Integrate production-ready encrypted SQLite solution.

Tasks:

- Generate encryption key.
- Securely store key.
- Open encrypted DB.
- Test migration from non-production plain DB if needed.

## 16.3 PIN

Implement:

- Set PIN.
- Verify PIN.
- Change PIN.
- Remove PIN.
- Retry handling.

## 16.4 Biometrics

Implement:

- Enable biometrics.
- Verify biometric.
- Fallback to PIN.
- Device biometric change handling.

## 16.5 Auto-lock

Options:

- Immediately.
- 1 minute.
- 5 minutes.
- 15 minutes.

## 16.6 Background Privacy

Implement:

- Blur recent app snapshot where supported.
- Lock after timeout.

## 16.7 Backup Package

Implement:

- Database snapshot.
- Media collection.
- Documents.
- Manifest.
- Checksums.
- Archive.

## 16.8 Backup Encryption

Implement:

- AES-256-GCM.
- Password-derived key.
- Password confirmation.
- Backup metadata.

## 16.9 Backup UI

Implement:

- Create backup.
- Progress.
- Save/share backup.
- Backup history if stored locally.

## 16.10 Restore

Implement:

- Pick backup.
- Validate.
- Password.
- Integrity check.
- Preview summary.
- Safety backup.
- Restore.
- Run migrations.
- Rebuild reminders.
- Rebuild search.

## Sprint Deliverables

- App lock works.
- Biometrics work.
- Local encrypted database used.
- Encrypted backup can be created.
- Backup can restore to fresh install.

## Sprint QA

Must test:

- Wrong PIN.
- Wrong backup password.
- Corrupt backup.
- Missing asset.
- Old schema.
- Large backup.
- Interrupted restore.
- Fresh device restore.
- Biometric failure.
- Auto-lock.

---

# 17. Sprint 12 — Hardening, Accessibility, QA & MVP Release

## Sprint Goal

Prepare Shishur Dinlipi for public production release.

## 17.1 Performance

Profile:

- Startup.
- Timeline scroll.
- Photo loading.
- Search.
- Growth charts.
- PDF generation.
- Backup.

Optimize:

- Database queries.
- Indexes.
- Image caching.
- Thumbnail usage.
- Rebuild scope.
- Riverpod providers.

## 17.2 Database Index Review

Add/verify indexes for:

- Child + event date.
- Search fields.
- Reminder date.
- Media relationships.
- Tags.

## 17.3 Accessibility

Audit:

- Semantics.
- Dynamic text.
- Contrast.
- Bengali readability.
- Touch targets.
- Focus order.
- Screen reader labels.

## 17.4 Localization QA

Review every screen in:

- English.
- বাংলা.

Test:

- Truncation.
- Long labels.
- Bengali numerals.
- Mixed-language data.
- PDF fonts.

## 17.5 Common UI States

Complete production UI for:

- Loading.
- Skeleton.
- Empty state.
- No search results.
- Save progress.
- Save success.
- Save failure.
- Delete confirmation.
- Permission denied.
- Notification denied.
- Storage almost full.
- Migration.
- Backup progress.
- Restore progress.
- PDF generation.
- Generic error.

## 17.6 Storage Management

Add:

- Storage usage summary.
- Temp cleanup.
- Orphan media checker.
- Generated export cleanup options.

## 17.7 Integration Test Suite

Automate:

1. First launch.
2. Create child.
3. Add photo.
4. Add growth.
5. Add milestone.
6. Add journal.
7. Add illness.
8. Add medicine.
9. Add doctor visit.
10. Generate PDF.
11. Create backup.
12. Restore backup.

## 17.8 Security Review

Check:

- No secrets in source.
- No sensitive logs.
- Production DB encrypted.
- Backup encrypted.
- App-private media.
- Biometric fallback.
- Screenshots behavior.

## 17.9 Release Preparation

Android:

- App icon.
- Adaptive icon.
- Splash.
- Signing.
- AAB.
- Privacy declarations.
- Play Store listing.

iOS:

- App icon set.
- Launch screen.
- Signing.
- Privacy usage descriptions.
- TestFlight.
- App Store metadata.

## 17.10 Beta

Release to:

- Internal Android testers.
- TestFlight testers.

Collect:

- Crash reports.
- UX issues.
- Performance issues.
- Bengali-language issues.

## Sprint Deliverables

- Production release candidate.
- Automated regression suite.
- Store assets ready.
- Privacy/security review complete.
- MVP ready for staged rollout.

---

# 18. MVP Sprint Summary

| Sprint | Primary Outcome |
|---|---|
| 1 | Project architecture and app shell |
| 2 | Database, files, media, settings infrastructure |
| 3 | Child profiles and onboarding |
| 4 | Journal, funny moments, achievements |
| 5 | Growth and milestones |
| 6 | School history |
| 7 | Vaccination, illness, medicines, doctor visits |
| 8 | Timeline, reminders, calendar |
| 9 | Search, tags, photos, albums |
| 10 | Year in Review and PDF generation |
| 11 | Encryption, PIN, biometric, backup/restore |
| 12 | Hardening, QA and release |

---

# 19. Suggested Release Milestones

## Milestone A — Internal Prototype

End of Sprint 3.

Includes:

- Onboarding.
- Child profile.
- Navigation.
- Local database.

## Milestone B — Core Journal Alpha

End of Sprint 5.

Includes:

- Journal.
- Photos.
- Achievements.
- Growth.
- Milestones.

## Milestone C — Functional Beta

End of Sprint 8.

Includes:

- Health.
- School.
- Timeline.
- Reminders.
- Calendar.

## Milestone D — Feature Complete

End of Sprint 10.

Includes:

- Search.
- Albums.
- Year Review.
- Offline PDF.

## Milestone E — Release Candidate

End of Sprint 12.

Includes:

- Encryption.
- Backup/restore.
- QA.
- Release hardening.

---

# 20. Optional Sprint 13 — Birthday Memories & Favorites

## Sprint Goal

Expand long-term memory value after MVP.

Tasks:

- Birthday records.
- Birthday annual interview.
- Favorite food.
- Favorite color.
- Favorite cartoon.
- Favorite book.
- Favorite game.
- Favorite friend.
- Compare answers by age.
- Birthday album template.
- Birthday-specific PDF.

---

# 21. Optional Sprint 14 — Interests, Family Events & Trips

Tasks:

- Child interests.
- Interest level.
- Family events.
- Eid memories.
- Travel memories.
- Places.
- First flight.
- First beach trip.
- Family-event album templates.
- New dashboard memory cards.

---

# 22. Optional Sprint 15 — Advanced Search & FTS

Tasks:

- SQLite FTS5.
- Search index table.
- Index rebuild service.
- Search highlighting.
- Search by date range.
- Search by tags.
- Search by type.
- Search performance benchmarks.

---

# 23. Optional Sprint 16 — Cloud Backup Providers

## Google Drive

Tasks:

- OAuth.
- Drive app folder.
- Upload backup.
- List backup.
- Download.
- Delete remote backup.

## OneDrive

Tasks:

- Microsoft authentication.
- App folder.
- Backup CRUD.

## Dropbox

Tasks:

- OAuth.
- App folder.
- Backup CRUD.

## iCloud

Evaluate iOS-specific implementation.

All providers must work through the common `BackupProvider` abstraction.

---

# 24. Optional Sprint 17 — OCR

Tasks:

- Vaccination card scan.
- Prescription scan.
- Diagnostic report scan.
- Local OCR where feasible.
- Highlight extracted values.
- Parent confirmation.
- Never auto-save medical facts without review.

---

# 25. Optional Sprint 18 — Smart Year Review

Tasks:

- Better highlight scoring.
- Photo scoring based on favorites.
- Duplicate photo removal.
- Section recommendations.
- Automatically suggested title.
- Suggested photo collage.

No external AI required for this sprint.

---

# 26. Optional Sprint 19 — AI-Assisted Memories

Only if product privacy policy supports it.

Tasks:

- AI service abstraction.
- Explicit consent.
- Data minimization.
- Year summary generation.
- Caption suggestion.
- Journal title suggestion.
- Local fallback.
- Privacy notice.
- AI disable setting.

---

# 27. Optional Sprint 20 — Family Sharing / Sync Research

This should begin as a technical discovery sprint.

Research:

- End-to-end encryption.
- Sync conflict resolution.
- Family invitations.
- Parent roles.
- Device identity.
- Shared albums.
- Child ownership model.
- Revocation.
- Offline merge.

Do not rush this feature because it materially changes the product's privacy model.

---

# 28. Detailed Cross-Sprint Task Tracks

The following tracks run across multiple sprints.

---

# 29. Testing Track

## Every Sprint

Required:

- Unit tests.
- Repository tests.
- Widget tests for complex UI.
- Manual regression.
- Bengali UI test.

## From Sprint 7

Add health-data regression.

## From Sprint 10

Add generated-PDF snapshots or structural validation.

## From Sprint 11

Add security and backup regression.

---

# 30. Database Migration Track

Every schema change must include:

- Schema increment.
- Migration code.
- Migration unit test.
- Existing-data test.
- Rollback/recovery strategy where possible.

Never solve migration issues by clearing production data.

---

# 31. Localization Track

For each new feature:

1. Add English copy.
2. Add Bengali copy.
3. Review Bengali terminology.
4. Check layout.
5. Test dynamic font size.
6. Test mixed user-entered content.

---

# 32. Accessibility Track

Every new screen should include:

- Semantic labels.
- Logical focus order.
- Large tap targets.
- Sufficient contrast.
- Text scaling support.

Do not postpone all accessibility work until the last sprint.

---

# 33. Privacy Track

For each feature, review:

- What sensitive data is stored?
- Is it logged?
- Is it exported?
- Does it appear in notification text?
- Is it included in backup?
- Is it visible on lock screen?

Example:

Medicine notification should avoid revealing unnecessary medical details if the user selects privacy mode.

---

# 34. Performance Track

Monitor:

- SQL query count.
- Timeline query duration.
- Large image memory usage.
- Thumbnail decode.
- PDF image processing.
- Backup file streaming.

---

# 35. Media Track

Across media-enabled sprints:

- Import.
- Thumbnail.
- Preview.
- Checksum.
- Attachment relation.
- Delete safely.
- Backup.
- Restore.
- Broken-file handling.

---

# 36. Security Track

## Sprint 2

Secure-storage foundation.

## Sprint 3–10

Avoid sensitive logs and public file storage.

## Sprint 11

Full encryption and app lock.

## Sprint 12

Security validation.

---

# 37. PDF Track

## Sprint 9

Album schema.

## Sprint 10

Full rendering engine.

## Sprint 12

Performance and edge-case hardening.

## Future

More layouts and print formats.

---

# 38. Technical Risk Register

## Risk 1 — Very Large Photo Libraries

Impact:

- Storage growth.
- Slow backup.
- High memory use.

Mitigation:

- Thumbnail pipeline.
- Streaming operations.
- Image resize for PDF.
- Storage usage dashboard.

## Risk 2 — Bengali PDF Rendering

Impact:

- Broken text.
- Incorrect glyph shaping.

Mitigation:

- Validate Bengali font early.
- Test mixed text.
- Test all PDF themes.

## Risk 3 — Database Migration Failure

Impact:

- Long-term user data loss.

Mitigation:

- Migration tests.
- Safety backup before risky operations.
- No destructive reset.

## Risk 4 — Backup Corruption

Mitigation:

- Manifest.
- Checksums.
- Atomic writes.
- Restore validation.

## Risk 5 — OS Notification Restrictions

Mitigation:

- Reminder DB remains authoritative.
- Explain permission state.
- Rebuild schedules.

## Risk 6 — Encryption Integration Complexity

Mitigation:

- Prototype encrypted DB before Sprint 11 if library risk is high.
- Avoid late unsupported plugin discovery.

---

# 39. Recommended Pre-Sprint Technical Spike

Before Sprint 1 or during Sprint 1, spend a short engineering spike validating:

- Drift + chosen SQLCipher approach.
- Bengali text rendering in Flutter PDF.
- Image compression performance.
- Backup encryption library.
- iOS file export.
- Android scoped storage behavior.

These are high-risk dependencies and should be verified early.

---

# 40. Acceptance Criteria for MVP

MVP is ready only if all following pass.

## Profile

- Parent can create and manage multiple children.

## Journal

- Parent can record memories with photos.

## Growth

- Parent can record height and weight.

## Milestones

- Parent can record major milestones.

## School

- Parent can record school events.

## Health

- Parent can manage vaccinations, illnesses, medicines and doctor visits.

## Timeline

- All major event types appear chronologically.

## Search

- Parent can find old records locally.

## Reminder

- Local reminders function reliably.

## Year Review

- Parent can generate yearly review.

## PDF

- English and Bengali PDFs render correctly.

## Security

- Sensitive records are encrypted locally.

## Backup

- Full app backup and restore work.

## Offline

- All core features function in airplane mode.

## Accessibility

- Core screens support screen readers and scalable text.

---

# 41. Suggested Backlog Priority Model

Use priorities:

## P0 — Release Blocking

- Data loss.
- Broken backup.
- Broken restore.
- Database corruption.
- Security failure.
- App crash in major flows.

## P1 — Critical Experience

- Cannot add record.
- PDF generation broken.
- Notification scheduling broken.
- Bengali UI unusable.

## P2 — Important

- Filter bug.
- Chart issue.
- Minor attachment bug.
- Layout issue.

## P3 — Enhancement

- Animation.
- Minor visual polish.
- Additional templates.

---

# 42. Sprint Ceremonies

Recommended:

## Sprint Planning

Review:

- Sprint goal.
- Dependencies.
- Data migrations.
- Security impact.
- QA scope.

## Daily Stand-up

Track:

- Feature progress.
- Blockers.
- Migration changes.
- Device-specific issues.

## Mid-Sprint Review

For risky features:

- Media.
- PDF.
- Encryption.
- Backup.

## Sprint Review

Demo on:

- Android.
- iOS.
- English.
- বাংলা.

## Retrospective

Evaluate:

- Architecture.
- Build time.
- Test gaps.
- UX blockers.

---

# 43. Suggested Story Sizing

Use relative sizing:

- XS: 0.5 day.
- S: 1 day.
- M: 2–3 days.
- L: 4–5 days.
- XL: Must split.

Examples:

- Add Bengali label: XS.
- Growth form: M.
- Unified timeline: L.
- Backup/restore: must split into multiple L stories.
- PDF engine: multiple L stories.

---

# 44. Example Sprint Backlog Format

Each backlog item should include:

```text
Story:
As a parent, I want to record my child's height so I can see how they grow over time.

Acceptance Criteria:
- Height can be entered in cm.
- Existing ft/in preference converts correctly.
- Date is required.
- Invalid negative values are rejected.
- Record is visible in growth history.
- English and Bengali labels exist.
- Unit tests cover conversion.
```

---

# 45. Recommended Repository Milestones

Suggested tags:

```text
v0.1-foundation
v0.2-profile
v0.3-journal
v0.4-development
v0.5-health
v0.6-timeline
v0.7-albums
v0.8-year-review
v0.9-security
v1.0-mvp
```

---

# 46. Release Strategy

## Alpha

Internal engineering team.

## Beta

Small parent group.

Focus:

- Ease of use.
- Bengali language.
- Data confidence.
- PDF quality.

## Release Candidate

No P0/P1 bugs.

## Production

Staged rollout.

Recommended:

- Small Android percentage.
- Monitor crash-free sessions.
- Expand gradually.
- Submit iOS rollout after TestFlight acceptance.

---

# 47. Post-Release Priorities

First production updates should focus on:

1. Crash fixes.
2. Backup reliability.
3. Restore reliability.
4. PDF issues.
5. Bengali text/layout.
6. Storage performance.
7. UX simplification.

Feature expansion should come after data-safety confidence.

---

# 48. Final Delivery Principle

The project should not optimize only for reaching the first App Store release.

**Shishur Dinlipi is designed to preserve a child's history for many years.**

Therefore the implementation plan prioritizes:

- Stable schemas.
- Safe migrations.
- Strong backup.
- Offline availability.
- Secure storage.
- Media durability.
- Exportability.

The most important technical success case is not simply:

> “The app works today.”

It is:

> **A parent can open Shishur Dinlipi years later, restore it on a new phone, and still find the child's first word, first school day, doctor history, favorite photos, and every yearly memory album intact.**
