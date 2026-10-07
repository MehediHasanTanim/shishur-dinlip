# Shishur Dinlipi — Child Development Journal
## Detailed Feature Specification

**Product Name:** Shishur Dinlipi  
**বাংলা নাম:** শিশুর দিনলিপি  
**Product Type:** Offline-first Child Development Journal  
**Primary Users:** Parents and caregivers  
**Target Platform:** Mobile app — Android and iOS  
**Primary Market:** Bangladesh, with support for broader bilingual use  
**Languages:** English and বাংলা  
**Core Principle:** A private, simple, parent-friendly place to preserve a child’s growth, health history, milestones, memories, and achievements over the years.

---

# 1. Product Vision

**Shishur Dinlipi** is a personal child-development journal designed for parents who want to preserve both important records and meaningful memories of their child in one place.

The app combines:

- Physical growth tracking.
- Developmental milestones.
- School milestones.
- Vaccination records.
- Illness history.
- Medicine history.
- Doctor visit records.
- Photos and memory albums.
- Achievements.
- Funny and memorable moments.
- Yearly summaries.
- Printable or shareable offline PDF/photo albums.

The app should feel more like a **family memory journal** than a clinical medical application.

Example generated keepsake:

> **Azwad — Age 5: Year in Review**

The review can include:

- Growth changes.
- Important milestones.
- School memories.
- Favorite photos.
- Health highlights.
- Achievements.
- Funny quotes.
- Memorable moments.
- Parent-written notes.

---

# 2. Product Goals

## 2.1 Primary Goals

1. Help parents preserve their child's development history from early childhood onward.
2. Make recording memories extremely quick and simple.
3. Keep important child-health information organized.
4. Automatically transform scattered journal entries into meaningful yearly memories.
5. Allow parents to generate beautiful offline PDF/photo albums.
6. Support both English and Bengali-speaking families.
7. Keep sensitive child data private and locally controlled.

## 2.2 Secondary Goals

- Help parents remember important events years later.
- Make doctor-history review easier during appointments.
- Keep vaccination and medicine information accessible.
- Create a meaningful digital archive that can eventually be handed to the child.
- Encourage parents to record positive, emotional, and funny memories—not only medical records.

---

# 3. Target Users

## 3.1 Primary User

Parent or guardian of one or more children.

Typical needs:

- Quickly record events.
- Add photos.
- Track development.
- Find old health information.
- Generate yearly memory albums.
- Use the app without technical complexity.

## 3.2 Secondary User

Trusted caregiver or family member using the same device.

Possible examples:

- Mother.
- Father.
- Grandparent.
- Legal guardian.

For the first version, the app can remain primarily **single-device and single-owner**.

---

# 4. Product Principles

1. **Simple first**
   - Minimal technical language.
   - Large touch targets.
   - Clear forms.
   - Few mandatory fields.

2. **Memory-oriented**
   - Important health records should coexist naturally with happy memories.

3. **Offline-first**
   - Core app functionality must work without internet.

4. **Private by default**
   - Child information remains on-device unless the parent explicitly exports or backs it up.

5. **Bilingual**
   - English and বাংলা should be first-class languages.

6. **Flexible**
   - Parents should be able to record incomplete information.

7. **Non-judgmental**
   - Avoid messages implying a child is "late," "behind," or "abnormal."

8. **Long-term archive**
   - Data structures should support many years of history.

---

# 5. Language & Localization

## 5.1 Supported Languages

- English
- বাংলা

## 5.2 Language Selection

Users can choose:

- English
- বাংলা

Language can be changed later from Settings.

## 5.3 Mixed-Language Content

Parent-created content should never be automatically translated unless explicitly requested.

Example:

A parent may use:

- Bengali notes.
- English school names.
- Mixed Bengali-English descriptions.

The app must preserve the exact original text.

## 5.4 Bengali Date & Number Preferences

Optional preferences:

- Bengali numerals.
- English numerals.
- Gregorian calendar display.
- Bengali-friendly date formatting.

Example:

**English**

12 October 2026

**বাংলা**

১২ অক্টোবর ২০২৬

---

# 6. Child Profiles

## 6.1 Multiple Child Support

Parents can create multiple child profiles.

Example:

- Azwad
- Zariyah
- Ishraq

Each child maintains completely separate:

- Growth.
- Milestones.
- Health history.
- Photos.
- School events.
- Achievements.
- Memories.
- Reports.

## 6.2 Child Profile Fields

Required:

- Child name.
- Date of birth.

Optional:

- Nickname.
- Gender.
- Blood group.
- Birth weight.
- Birth height.
- Birthplace.
- School.
- Class/grade.
- Profile photo.
- Parent notes.

## 6.3 Child Profile Header

Display:

- Photo.
- Name.
- Current age.
- Date of birth.
- Quick health summary.
- Latest height.
- Latest weight.

Example:

> **Azwad**  
> 5 years 4 months  
> Height: 113 cm  
> Weight: 19.2 kg

---

# 7. Home Dashboard

The dashboard should provide a warm, memory-focused overview.

## 7.1 Dashboard Sections

### Child Selector

Parents with multiple children can switch profiles.

### Today's Memory Prompt

Examples:

- What made your child laugh today?
- Did your child say something funny?
- What new thing did your child learn today?
- Add today's favorite photo.

### Recent Memories

Display latest:

- Photos.
- Milestones.
- Achievements.
- Funny moments.
- Journal notes.

### Growth Snapshot

Show:

- Latest height.
- Latest weight.
- Change since previous measurement.

### Upcoming Health Items

Examples:

- Vaccination due.
- Follow-up doctor visit.
- Medicine schedule.

### Memory From the Past

Example:

> **2 years ago today**  
> Azwad rode a bicycle without help for the first time.

### Quick Add

Primary quick actions:

- Memory.
- Photo.
- Growth.
- Milestone.
- Health.
- Achievement.

---

# 8. Timeline

The timeline is the heart of the app.

## 8.1 Unified Timeline

Chronologically display:

- Milestones.
- Growth records.
- Photos.
- Vaccinations.
- Illnesses.
- Doctor visits.
- Medicines.
- School events.
- Achievements.
- Funny moments.
- General journal entries.

## 8.2 Timeline Card

Each item may show:

- Date.
- Category icon.
- Title.
- Short description.
- Photo thumbnail.
- Child age at event.

Example:

> **First Day of School**  
> 15 January 2026  
> Age 4 years 9 months  
> Azwad was excited but held Baba's hand until the classroom door.

## 8.3 Timeline Filters

Filter by:

- All.
- Memories.
- Growth.
- Milestones.
- Health.
- Vaccination.
- School.
- Achievements.
- Photos.
- Funny moments.

## 8.4 Timeline Search

Search by:

- Keyword.
- Date.
- Year.
- Category.

---

# 9. Growth Tracking

## 9.1 Height Records

Fields:

- Date.
- Height.
- Unit: cm / ft-in.
- Measurement location.
- Notes.

Optional examples:

- Home.
- Doctor chamber.
- School health check.

## 9.2 Weight Records

Fields:

- Date.
- Weight.
- Unit: kg / lb.
- Notes.

## 9.3 Combined Measurement

Allow adding height and weight together.

## 9.4 Growth History

Display:

- Latest measurement.
- Previous measurement.
- Difference.
- Historical list.

## 9.5 Growth Charts

Charts:

- Height over time.
- Weight over time.

Optional advanced:

- BMI.
- WHO growth percentile references.

If medical-reference percentiles are introduced, clearly state they are informational and not a diagnosis.

## 9.6 Growth Memory

Parents can optionally attach:

- Photo.
- Note.
- Context.

Example:

> "Measured before his first school sports day."

---

# 10. Developmental Milestones

## 10.1 Milestone Categories

### Movement

- First roll.
- First crawl.
- First stand.
- First step.
- First walk.
- First run.
- First bicycle ride.

### Speech & Communication

- First sound.
- First word.
- First sentence.
- First song.
- First story.

### Social

- First smile.
- First friend.
- First playgroup.
- First independent activity.

### Self-Care

- Started feeding independently.
- Toilet training milestone.
- Dressing independently.

### Learning

- Recognized letters.
- Counted numbers.
- Read first word.
- Wrote own name.

## 10.2 Custom Milestones

Parents can create their own milestone.

Fields:

- Milestone title.
- Category.
- Date.
- Approximate date toggle.
- Description.
- Photos/videos.
- Parent note.

## 10.3 Approximate Dates

Important for older memories.

Options:

- Exact date.
- Month only.
- Year only.
- Approximate date.

---

# 11. First Words Journal

Dedicated memory feature.

## 11.1 Word Entry

Fields:

- Word.
- Date.
- Child age.
- Language.
- Context.
- Parent note.
- Audio recording optional.

Example:

**Word:** Baba  
**Date:** 18 June 2023  
**Story:** Said "Baba" clearly while pointing at the door.

## 11.2 Funny Pronunciations

Parents can preserve childhood pronunciations.

Example:

> "Helicopter" → "Hecopter"

---

# 12. First Steps & Movement Memories

Dedicated quick templates for important physical milestones.

Templates:

- First crawl.
- First stand.
- First step.
- First independent walk.
- First run.
- First bicycle ride.
- First swim.

Fields:

- Date.
- Location.
- Description.
- Who was present.
- Photo/video.

---

# 13. School & Learning Milestones

## 13.1 School Profile

Fields:

- School name.
- Start date.
- Current class.
- Teacher.
- Notes.

## 13.2 School Milestones

Examples:

- First day of school.
- First homework.
- First exam.
- First school performance.
- First sports event.
- First certificate.
- Changed school.
- Promoted to new class.

## 13.3 Academic Memories

Parents can record:

- Report card.
- Favorite subject.
- Teacher comment.
- School project.
- Artwork.
- Certificates.

## 13.4 School Documents

Attach:

- Photos.
- PDF.
- Report card image.
- Certificate image.

---

# 14. Vaccination Records

## 14.1 Vaccination Entry

Fields:

- Vaccine name.
- Dose.
- Date given.
- Scheduled date.
- Clinic/hospital.
- Doctor/provider.
- Batch/lot number optional.
- Notes.
- Attachment/photo.

## 14.2 Vaccination Status

Statuses:

- Upcoming.
- Completed.
- Delayed.
- Skipped.
- Unknown.

## 14.3 Vaccination Timeline

Display chronological vaccination history.

## 14.4 Vaccination Reminders

Optional local notifications.

Example:

> Azwad's next vaccination is scheduled for 15 November.

## 14.5 Vaccination Card Archive

Parents can photograph and preserve physical vaccination cards.

---

# 15. Illness History

## 15.1 Illness Episode

Fields:

- Illness/title.
- Start date.
- End date.
- Symptoms.
- Maximum temperature.
- Diagnosis.
- Doctor consulted.
- Medicines.
- Lab tests.
- Notes.
- Attachments.

## 15.2 Common Symptoms

Quick selection:

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

## 15.3 Recovery Note

Parents can record:

- Recovery date.
- Final condition.
- Follow-up requirement.

---

# 16. Medicine Records

## 16.1 Medicine Entry

Fields:

- Medicine name.
- Strength.
- Dosage.
- Frequency.
- Start date.
- End date.
- Reason.
- Prescribed by.
- Notes.

## 16.2 Medicine Course

Example:

> Amoxicillin  
> 5 ml — three times daily  
> 7 days

## 16.3 Medicine History

Searchable history grouped by:

- Illness.
- Date.
- Doctor.
- Medicine name.

## 16.4 Medicine Reminder

Optional local notification schedule.

## 16.5 Medicine Completion

Statuses:

- Active.
- Completed.
- Stopped early.
- As needed.

---

# 17. Doctor Visits

## 17.1 Visit Record

Fields:

- Visit date.
- Doctor name.
- Specialty.
- Hospital/chamber.
- Reason.
- Symptoms.
- Diagnosis.
- Prescription.
- Tests advised.
- Follow-up date.
- Notes.

## 17.2 Attachments

Allow:

- Prescription photo.
- Test report.
- Doctor note.
- Invoice.
- Other document.

## 17.3 Follow-Up Reminder

Local reminder for follow-up date.

## 17.4 Doctor History

Show:

- Doctors previously visited.
- Number of visits.
- Last visit.
- Common reasons.

---

# 18. Medical Documents

Central archive for child-related health files.

Document types:

- Prescription.
- Diagnostic report.
- Vaccination card.
- Medical certificate.
- Discharge summary.
- Growth chart.
- Other.

Fields:

- Title.
- Date.
- Document type.
- Related illness.
- Related doctor visit.
- Attachment.
- Notes.

---

# 19. Photos & Media Journal

## 19.1 Add Photo

Sources:

- Camera.
- Gallery.

## 19.2 Photo Metadata

Optional:

- Date.
- Caption.
- Location text.
- Child age.
- Tags.
- Related milestone.

## 19.3 Albums

Automatic albums:

- By year.
- By age.
- By category.
- School.
- Birthdays.
- Achievements.

Custom albums are also supported.

## 19.4 Favorite Photos

Parents can mark photos as favorites.

Favorites can be prioritized for yearly albums.

## 19.5 Video Support

Optional phase:

- Store local video references.
- Add video thumbnail to timeline.

Generated PDFs should use a thumbnail rather than embed full video.

---

# 20. Achievements

## 20.1 Achievement Types

Examples:

- School certificate.
- Sports award.
- Drawing competition.
- Quran/recitation achievement.
- Music performance.
- Dance.
- Reading milestone.
- Swimming.
- Cycling.
- Personal goal.
- Helping others.
- Custom achievement.

## 20.2 Achievement Entry

Fields:

- Title.
- Date.
- Category.
- Description.
- Photo.
- Certificate.
- Parent note.

## 20.3 Achievement Wall

Visual grid of major achievements.

---

# 21. Funny Moments

This should be one of the most emotionally engaging features.

## 21.1 Funny Moment Entry

Fields:

- Date.
- Title.
- What happened?
- Funny quote.
- Photo/video.
- Who was there?

Example:

> **Azwad's Weather Forecast**  
> "The clouds are angry because Mama didn't give them chocolate."

## 21.2 Funny Quotes

Quick-add mode specifically for quotes.

## 21.3 Quote Cards

Generate shareable quote cards.

Example:

> "When I grow up, I will become Batman and a doctor."

— Azwad, Age 5

---

# 22. Daily Journal

## 22.1 General Memory Entry

For moments that do not fit a structured category.

Fields:

- Title.
- Date.
- Story.
- Mood.
- Photo/video.
- Tags.

## 22.2 Quick Journal

One-tap shortcuts:

- Something funny.
- Something new.
- Proud moment.
- Difficult day.
- Favorite moment.
- Photo memory.

## 22.3 Parent Reflection

Optional private field:

> How did this moment make you feel?

---

# 23. Birthdays

## 23.1 Birthday Record

For each year:

- Age.
- Date.
- Location.
- Theme.
- Guests.
- Favorite gift.
- Birthday message.
- Photos.
- Videos.

## 23.2 Birthday Interview

Reusable annual questions:

- Favorite food.
- Favorite color.
- Favorite cartoon.
- Best friend.
- Favorite game.
- What do you want to be?
- What makes you happy?

## 23.3 Comparison

Show answers across years.

Example:

Age 4 → Pilot  
Age 5 → Doctor  
Age 6 → Astronaut

---

# 24. Child Favorites

Track favorite things over time.

Categories:

- Food.
- Color.
- Toy.
- Cartoon.
- Book.
- Song.
- Game.
- Friend.
- Place.
- Subject.
- Hobby.

Each favorite includes:

- Value.
- Start date.
- Optional end date.
- Note.

---

# 25. Skills & Interests

Parents can track emerging interests.

Examples:

- Drawing.
- Football.
- Cricket.
- Music.
- Reading.
- LEGO.
- Science.
- Coding.
- Dancing.
- Gardening.

Fields:

- Interest.
- First noticed.
- Interest level.
- Notes.
- Photos.

---

# 26. Memories by Age

Provide automatic age-based collections.

Examples:

- 0–1 year.
- Age 1.
- Age 2.
- Age 3.
- Age 4.
- Age 5.

Each view contains:

- Growth.
- Milestones.
- Photos.
- School events.
- Achievements.
- Funny moments.
- Health records.
- Parent notes.

---

# 27. Year in Review

One of the core differentiators.

## 27.1 Automatic Yearly Summary

The app automatically organizes the year's records.

Example title:

> **Azwad — Age 5: Year in Review**

## 27.2 Suggested Sections

1. Cover.
2. About Azwad at Age 5.
3. Growth this year.
4. Big milestones.
5. School memories.
6. Favorite photos.
7. Achievements.
8. Funny things Azwad said.
9. Favorite things.
10. Health highlights.
11. Family memories.
12. Birthday memories.
13. Parent letter.
14. Year-end highlights.

## 27.3 Highlight Selection

The app can automatically suggest:

- Most favorited photos.
- Milestones.
- Achievements.
- Funny quotes.
- Important growth changes.

Parent can:

- Add.
- Remove.
- Rearrange.
- Edit.

## 27.4 Parent Letter

Provide a special page:

> **A letter to Azwad at age 5**

Parent writes a personal message to preserve for the future.

---

# 28. PDF / Photo Album Generator

## 28.1 Offline PDF Generation

The complete PDF should be generated on-device.

No server dependency is required.

## 28.2 Album Types

Generate:

- Year in Review.
- Birthday Album.
- First Year Album.
- School Year Album.
- Milestone Album.
- Health Summary.
- Custom Memory Album.

## 28.3 Themes

Examples:

- Minimal.
- Playful.
- Baby.
- School.
- Colorful.
- Elegant.

## 28.4 PDF Customization

Parent can choose:

- Cover image.
- Title.
- Date range.
- Sections.
- Photos.
- Theme.
- Language.
- Page size.
- Photo density.

## 28.5 PDF Output

Capabilities:

- Preview.
- Save locally.
- Share.
- Print.
- Export.

## 28.6 Photo Album Export

Optionally export selected album pages as:

- JPG.
- PNG.

Useful for:

- WhatsApp.
- Messenger.
- Social sharing.
- Printing shops.

---

# 29. Health Summary

Generate a concise child health profile.

Includes:

- Blood group.
- Allergies.
- Current medicines.
- Recent illnesses.
- Vaccination status.
- Recent doctor visits.
- Height.
- Weight.
- Emergency notes.

This can be useful during doctor appointments.

---

# 30. Allergies

Track:

- Food allergies.
- Medicine allergies.
- Environmental allergies.
- Unknown reactions.

Fields:

- Allergen.
- Reaction.
- Severity.
- First observed.
- Doctor confirmed?
- Notes.

---

# 31. Important Health Information

Parents can maintain quick-reference information:

- Blood group.
- Known allergies.
- Chronic conditions.
- Special medical instructions.
- Emergency doctor.
- Preferred hospital.

Keep this information clearly marked as **parent-entered information**.

---

# 32. Search

Global search across:

- Memories.
- Milestones.
- Medicines.
- Illnesses.
- Doctors.
- School records.
- Achievements.
- Photos.
- Notes.

Example searches:

- "fever"
- "first school"
- "Dr Rahman"
- "amoxicillin"
- "birthday"

---

# 33. Tags

Parents can add flexible tags.

Examples:

- Family trip.
- School.
- Eid.
- Dhaka.
- Grandparents.
- Vacation.
- Football.

Tags help organize memories across categories.

---

# 34. Calendar View

Show days containing journal events.

Indicators for:

- Memory.
- Health.
- School.
- Milestone.
- Birthday.
- Vaccination.

Tap a date to view all entries.

---

# 35. Memory Prompts

Optional daily or weekly prompts.

Examples:

- What made your child proud this week?
- What funny sentence did they say?
- What new skill did they learn?
- What is their current favorite toy?
- Add a photo from this week.

Users can disable prompts.

---

# 36. On This Day

Show historical memories.

Example:

> **3 years ago today**  
> Zariyah took her first step.

Actions:

- View memory.
- Share.
- Add reflection.

---

# 37. Family Events

Allow recording important family memories involving the child.

Examples:

- Eid.
- Wedding.
- Family vacation.
- Grandparent visit.
- New sibling.
- Moving home.
- First flight.

---

# 38. Places & Trips

Optional memory feature.

Fields:

- Place.
- Date.
- Story.
- Photos.
- Child reaction.

Example:

> First visit to Cox's Bazar.

No GPS tracking is required.

---

# 39. Parent Notes

Private parent-only notes.

Examples:

- Concerns.
- Observations.
- Parenting reflections.
- Future reminders.

These notes can optionally be excluded from generated albums.

---

# 40. Data Privacy

## 40.1 Local-First Storage

Core child data should remain in the device's local database.

## 40.2 No Mandatory Account

The app should work without registration.

## 40.3 Optional App Lock

Security options:

- PIN.
- Face unlock.
- Fingerprint.

## 40.4 Sensitive Media

Photos and documents should be stored securely.

## 40.5 Screenshot Protection

Optional setting for sensitive screens.

---

# 41. Backup & Restore

## 41.1 Manual Backup

Create encrypted backup containing:

- Profiles.
- Timeline.
- Health data.
- Journal.
- Photos.
- Documents.
- Settings.

## 41.2 Restore

User can restore backup to:

- Same device.
- New device.

## 41.3 Cloud Storage Integration

Advanced version can support user-authorized backup/export to:

- Google Drive.
- OneDrive.
- Dropbox.
- iCloud where applicable.

The app itself should not require a central backend for core functionality.

---

# 42. Export Data

Export options:

- Full archive.
- Child profile.
- Health data.
- Milestones.
- Yearly album.
- Photos.
- JSON/structured backup.
- PDF reports.

---

# 43. Import

Possible imports:

- Previous Shishur Dinlipi backup.
- Photos from device gallery.
- PDF/document attachments.

Advanced:

- CSV import for growth or vaccination history.

---

# 44. Notifications & Reminders

Local notifications can support:

- Vaccination reminder.
- Medicine reminder.
- Doctor follow-up.
- Birthday reminder.
- Weekly journal prompt.
- Backup reminder.

All reminder categories should be individually configurable.

---

# 45. App Navigation

Recommended bottom navigation:

1. Home
2. Timeline
3. Add
4. Albums
5. More

## Home

Dashboard and memories.

## Timeline

Complete chronological history.

## Add

Quick entry selector.

## Albums

Photos, yearly reviews, generated albums.

## More

- Child profiles.
- Growth.
- Health.
- School.
- Achievements.
- Search.
- Backup.
- Settings.

---

# 46. Quick Add Menu

When tapping Add:

- Memory.
- Photo.
- Milestone.
- Growth.
- Funny Moment.
- Achievement.
- Illness.
- Medicine.
- Doctor Visit.
- Vaccination.
- School Event.

Keep the most common options visually prominent.

---

# 47. Home Screen Widgets

Optional OS widgets:

- Today's memory prompt.
- Upcoming vaccination.
- Add memory.
- Memory from previous years.

---

# 48. Accessibility

Support:

- Dynamic font size.
- Screen readers.
- High contrast.
- Large tap targets.
- Clear Bengali typography.
- Reduced motion.
- Simple icons with labels.

---

# 49. Appearance

Themes:

- Light.
- Dark.
- System.

Optional child-profile accent themes.

Examples:

- Blue.
- Pink.
- Green.
- Yellow.
- Purple.

Avoid gender-locking colors.

---

# 50. Settings

## 50.1 General

- Language.
- Date format.
- Units.
- Default child.
- Appearance.

## 50.2 Journal

- Memory prompts.
- On This Day.
- Default photo quality.

## 50.3 Health

- Vaccination reminders.
- Medicine reminders.
- Doctor follow-up reminders.

## 50.4 Privacy

- App PIN.
- Biometrics.
- Auto-lock.
- Screenshot protection.

## 50.5 Backup

- Create backup.
- Restore.
- Backup reminder.
- Cloud provider.

## 50.6 Export

- Export child data.
- Generate archive.
- PDF defaults.

---

# 51. Common UI States

The app should define reusable designs for:

1. Initial loading.
2. Skeleton loading.
3. Empty timeline.
4. Empty photos.
5. Empty health history.
6. Empty milestones.
7. No search results.
8. Save in progress.
9. Save successful.
10. Save failed.
11. Delete confirmation.
12. Delete failed.
13. Unsaved changes.
14. Permission denied.
15. Camera permission denied.
16. Photo permission denied.
17. Notification permission denied.
18. Storage almost full.
19. Database migration.
20. Backup in progress.
21. Backup successful.
22. Backup failed.
23. Restore in progress.
24. Restore successful.
25. Restore failed.
26. Corrupt backup.
27. PDF generating.
28. PDF generation failed.
29. Export successful.
30. Export failed.
31. Unsupported file.
32. Missing attachment.
33. Generic error.
34. Date picker.
35. Child selector.
36. Category selector.
37. Search & filter sheet.
38. Confirmation bottom sheet.

---

# 52. Empty-State Examples

## Timeline

**English**

> No memories yet  
> Add your first memory and begin your child's story.

**বাংলা**

> এখনো কোনো স্মৃতি যোগ করা হয়নি  
> প্রথম স্মৃতিটি যোগ করে আপনার শিশুর গল্প শুরু করুন।

## Photos

> No photos yet  
> Add a favorite photo from today.

## Health

> No health records  
> Illnesses, vaccinations, medicines and doctor visits will appear here.

## Achievements

> Every achievement matters  
> Add the first proud moment.

---

# 53. Non-Goals

The initial application should not attempt to become:

- A replacement for pediatricians.
- A diagnostic medical system.
- A hospital EMR.
- A social media platform.
- A public child profile.
- A complex school-management platform.
- A parental surveillance application.

---

# 54. Suggested MVP

The MVP should include:

## Child Management

- Multiple child profiles.
- Basic profile information.
- Profile photo.

## Timeline

- Unified timeline.
- Search.
- Category filter.

## Memories

- General journal.
- Photos.
- Funny moments.
- Achievements.

## Growth

- Height.
- Weight.
- Growth history.
- Basic charts.

## Milestones

- First words.
- First steps.
- Custom milestones.

## School

- School milestones.
- Basic school events.

## Health

- Vaccination.
- Illness.
- Medicine.
- Doctor visits.
- Attachments.

## Album

- Age/year-based memories.
- Year in Review.
- Offline PDF generation.

## Security

- Local database.
- App PIN/biometric.
- Manual encrypted backup.

## Language

- English.
- বাংলা.

---

# 55. Suggested Advanced Features

Potential later phases:

- Video memories.
- Audio memories.
- Voice-to-text journal entry.
- OCR for vaccination cards.
- OCR for prescriptions.
- Automatic photo date import.
- Smart yearly highlight suggestions.
- Cloud backup integrations.
- Shared family vault.
- Growth percentile charts.
- Custom printable photo-book layouts.
- AI-assisted memory summaries.
- AI-generated year-in-review narrative.
- Secure family sharing.
- Child handover archive for adulthood.

Any AI feature must remain optional and should never silently send private child information to an external service.

---

# 56. Sample Year-in-Review Structure

## Cover

**Azwad — Age 5**  
**Year in Review**

Photo + date range.

## Page 1 — About Me

- Age.
- Height.
- Weight.
- School.
- Favorite food.
- Favorite color.
- Favorite activity.

## Page 2 — How Much I Grew

- Height at beginning of year.
- Height at end.
- Weight change.

## Page 3 — My Big Moments

- Learned cycling.
- First school performance.
- Learned to write full name.

## Page 4 — School Memories

- First day.
- Teacher.
- Favorite subject.
- School photos.

## Page 5 — Things I Said

> "When I become big, I will buy Baba a red car."

## Page 6 — My Achievements

- Certificate.
- Sports result.
- Reading milestone.

## Page 7 — Favorite Memories

Photo collage.

## Page 8 — Family Adventures

Trips and special events.

## Page 9 — Health Snapshot

- Vaccinations.
- Significant illnesses.
- Doctor visits.

Keep this section compact and optional.

## Page 10 — Letter From My Parents

A personal letter preserved for the future.

---

# 57. Example Bengali Labels

| English | বাংলা |
|---|---|
| Home | হোম |
| Timeline | সময়রেখা |
| Add Memory | স্মৃতি যোগ করুন |
| Growth | বৃদ্ধি |
| Height | উচ্চতা |
| Weight | ওজন |
| Milestones | মাইলস্টোন |
| First Word | প্রথম কথা |
| First Step | প্রথম পদক্ষেপ |
| School | স্কুল |
| Vaccination | টিকা |
| Illness | অসুস্থতা |
| Medicine | ওষুধ |
| Doctor Visit | ডাক্তার দেখানো |
| Photos | ছবি |
| Achievements | অর্জন |
| Funny Moments | মজার মুহূর্ত |
| Year in Review | বছরের স্মৃতিচারণ |
| Generate PDF | PDF তৈরি করুন |
| Backup | ব্যাকআপ |
| Restore | পুনরুদ্ধার |
| Settings | সেটিংস |

---

# 58. Product Success Criteria

The product should be considered successful when a parent can:

1. Create a child profile in under two minutes.
2. Add a basic memory in under 30 seconds.
3. Record height/weight easily.
4. Find a previous medicine or doctor visit quickly.
5. Browse several years of child memories without confusion.
6. Generate a meaningful yearly album without manually designing pages.
7. Use all core features offline.
8. comfortably use the entire application in either English or Bengali.
9. Keep sensitive child information private.
10. Feel that the app is preserving their child's story, not merely storing records.

---

# 59. Recommended Product Positioning

**English**

> **Shishur Dinlipi**  
> Your child's growth, health and precious memories — preserved in one private journal.

**বাংলা**

> **শিশুর দিনলিপি**  
> আপনার শিশুর বেড়ে ওঠা, স্বাস্থ্য আর ছোট ছোট স্মৃতি — সব এক নিরাপদ দিনলিপিতে।

---

# 60. Core Differentiator

The key distinction is that **Shishur Dinlipi is not merely a baby tracker, vaccination tracker, medical history app, or photo album.**

It combines all four ideas:

**Development + Health + Memories + Keepsakes**

into one long-term child journal.

The most emotionally valuable outcome is not a database entry.

It is the moment when a parent generates:

> **“Azwad — Age 5: Year in Review”**

and sees an entire year of their child's life preserved as a story.
