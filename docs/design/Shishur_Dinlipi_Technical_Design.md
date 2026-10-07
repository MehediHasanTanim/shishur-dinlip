# Shishur Dinlipi — Technical Design Document
## Child Development Journal

**Product Name:** Shishur Dinlipi  
**বাংলা নাম:** শিশুর দিনলিপি  
**Document Type:** Technical Design  
**Primary Platforms:** Android and iOS  
**Architecture Style:** Offline-first mobile application  
**Languages:** English and বাংলা  
**Backend:** Not required for core functionality  
**Primary Storage:** Local encrypted database + secure local media/document storage

---

# 1. Purpose

This document defines the technical architecture for **Shishur Dinlipi**, a private child development and memory journal for parents.

The application must support:

- Multiple child profiles.
- Growth tracking.
- Developmental milestones.
- First words and first steps.
- School milestones.
- Vaccination records.
- Illness history.
- Medicines.
- Doctor visits.
- Photos and media.
- Achievements.
- Funny moments.
- General journaling.
- Automatic age/year-based summaries.
- Offline PDF/photo album generation.
- English and বাংলা.
- Secure offline storage.
- Backup and restore.

The core application should remain fully usable without internet access.

---

# 2. Technical Goals

The implementation should prioritize:

1. **Offline-first reliability**
2. **Strong privacy**
3. **Long-term data durability**
4. **Simple maintainable architecture**
5. **Fast local search**
6. **Efficient photo/document handling**
7. **Bilingual UI**
8. **Safe local backup and restore**
9. **Scalable schema for many years of child history**
10. **Platform-independent business logic where practical**

---

# 3. Recommended Technology Stack

The recommended implementation is Flutter because the application:

- Targets both Android and iOS.
- Is heavily form-driven.
- Requires custom visual layouts for albums.
- Needs local database support.
- Needs offline PDF generation.
- Benefits from a shared codebase.

## 3.1 Mobile Framework

**Flutter**

Recommended:

- Latest stable Flutter SDK.
- Dart.
- Material 3.
- Cupertino adaptations where appropriate.

## 3.2 State Management

Recommended:

**Riverpod**

Use:

- `flutter_riverpod`
- `riverpod_annotation`
- code generation where beneficial.

Riverpod should handle:

- Screen state.
- Child selection.
- Filters.
- Settings.
- Form state.
- PDF-generation state.
- Backup/restore progress.

## 3.3 Local Database

Recommended:

**Drift + SQLite**

Reasons:

- Strong relational modeling.
- Transactions.
- SQL search.
- Migration support.
- Good fit for long-term structured data.
- Easy aggregation for reports and year summaries.

Alternative:

- Isar.

Drift is preferred because the domain has many related entities and historical records.

## 3.4 Secure Key Storage

Use:

- `flutter_secure_storage`

Store:

- Database encryption key.
- PIN metadata.
- Cloud-provider tokens if future sync is introduced.
- Backup encryption metadata where appropriate.

## 3.5 File Storage

Use app-private filesystem storage through:

- `path_provider`
- `dart:io`

Store:

- Photos.
- Thumbnails.
- Documents.
- Generated PDFs.
- Export packages.
- Temporary import files.

## 3.6 PDF Generation

Recommended:

- `pdf`
- `printing`

Use for:

- Year in Review.
- Health summary.
- Birthday album.
- Custom album.
- Printable reports.

## 3.7 Media

Recommended packages:

- `image_picker`
- `camera` if an in-app camera is needed.
- `photo_manager` if advanced gallery browsing is required.

For image processing:

- `image`

## 3.8 Local Notifications

Use:

- `flutter_local_notifications`
- `timezone`

Use for:

- Vaccination reminders.
- Medicine reminders.
- Doctor follow-up.
- Birthday reminders.
- Weekly memory prompts.
- Backup reminders.

## 3.9 Biometrics

Use:

- `local_auth`

Support:

- Face ID.
- Touch ID.
- Android biometrics.

## 3.10 Sharing

Use:

- `share_plus`

For sharing:

- PDFs.
- Album images.
- Quote cards.
- Export archives.

## 3.11 Localization

Use:

- Flutter `intl`
- ARB localization files.

Languages:

- `en`
- `bn`

---

# 4. High-Level Architecture

Use a layered architecture.

```text
Presentation
    ↓
Application / Use Cases
    ↓
Domain
    ↓
Data
    ↓
SQLite / File Storage / Secure Storage / Platform Services
```

Recommended project style:

```text
lib/
├── app/
├── core/
├── features/
├── shared/
└── main.dart
```

---

# 5. Architecture Layers

## 5.1 Presentation Layer

Responsibilities:

- Screens.
- Widgets.
- Navigation.
- User input.
- View state.
- Form validation.
- Loading/error/empty states.

Should not contain:

- Raw SQL.
- File-system logic.
- PDF business rules.
- Backup encryption details.

## 5.2 Application Layer

Contains:

- Use cases.
- Coordinators.
- Workflow services.

Examples:

- `CreateChildProfileUseCase`
- `AddGrowthRecordUseCase`
- `RecordMilestoneUseCase`
- `GenerateYearInReviewUseCase`
- `CreateEncryptedBackupUseCase`

## 5.3 Domain Layer

Contains:

- Business entities.
- Value objects.
- Domain rules.
- Repository contracts.

Examples:

- `Child`
- `GrowthRecord`
- `Milestone`
- `HealthEvent`
- `JournalEntry`
- `AlbumDefinition`

## 5.4 Data Layer

Contains:

- Repository implementations.
- Drift DAOs.
- File storage.
- Secure storage.
- Local notification adapters.
- Export/import adapters.

---

# 6. Feature-Based Module Structure

Recommended:

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   ├── theme/
│   └── localization/
│
├── core/
│   ├── database/
│   ├── security/
│   ├── files/
│   ├── notifications/
│   ├── backup/
│   ├── pdf/
│   ├── logging/
│   ├── errors/
│   └── utils/
│
├── features/
│   ├── children/
│   ├── dashboard/
│   ├── timeline/
│   ├── growth/
│   ├── milestones/
│   ├── first_words/
│   ├── school/
│   ├── vaccination/
│   ├── illness/
│   ├── medicine/
│   ├── doctor_visits/
│   ├── medical_documents/
│   ├── journal/
│   ├── funny_moments/
│   ├── achievements/
│   ├── photos/
│   ├── birthdays/
│   ├── favorites/
│   ├── interests/
│   ├── albums/
│   ├── year_review/
│   ├── search/
│   ├── reminders/
│   ├── backup_restore/
│   └── settings/
│
└── shared/
    ├── widgets/
    ├── models/
    └── extensions/
```

---

# 7. Navigation Architecture

Recommended bottom navigation:

1. Home
2. Timeline
3. Add
4. Albums
5. More

Use declarative navigation.

Recommended package:

- `go_router`

## 7.1 Route Example

```text
/
├── home
├── timeline
├── add
├── albums
├── more
│
├── child/:childId
├── growth/:childId
├── milestone/:id
├── health/:childId
├── doctor-visit/:id
├── journal/:id
└── year-review/:childId/:year
```

---

# 8. Child Context

Most features operate within a selected child.

Maintain:

```dart
selectedChildId
```

as application-level state.

Rules:

- No health/memory entry can be created without a child.
- Child selector must update all child-scoped screens.
- Deep links/routes should carry the child ID where needed.

---

# 9. Database Design Principles

The database should support:

- Multiple children.
- Years of historical data.
- Efficient timeline queries.
- Search.
- Attachments.
- Soft deletion where needed.
- Backup consistency.

## 9.1 Common Columns

Most tables should contain:

```text
id
child_id
created_at
updated_at
deleted_at
```

Use UUIDs rather than auto-increment IDs.

Benefits:

- Safer backup/import.
- Future sync compatibility.
- Easy data merging.

---

# 10. Core Database Tables

Recommended tables:

```text
children
growth_records
milestones
first_words
school_profiles
school_events
vaccinations
illness_episodes
medicines
medicine_schedules
doctor_visits
medical_documents
journal_entries
funny_moments
achievements
birthdays
birthday_answers
favorites
interests
media_assets
attachments
tags
tag_links
reminders
albums
album_items
year_review_preferences
parent_notes
settings
audit_events
```

---

# 11. Child Table

## children

Fields:

```text
id UUID PK
name TEXT NOT NULL
nickname TEXT NULL
date_of_birth DATE NOT NULL
gender TEXT NULL
blood_group TEXT NULL
birth_weight_kg REAL NULL
birth_height_cm REAL NULL
birthplace TEXT NULL
school_name TEXT NULL
class_name TEXT NULL
profile_photo_id UUID NULL
notes TEXT NULL
created_at DATETIME
updated_at DATETIME
deleted_at DATETIME NULL
```

---

# 12. Growth Record Table

## growth_records

```text
id UUID PK
child_id UUID FK
measured_at DATETIME
height_cm REAL NULL
weight_kg REAL NULL
measurement_location TEXT NULL
notes TEXT NULL
created_at DATETIME
updated_at DATETIME
```

Indexes:

```text
(child_id, measured_at DESC)
```

---

# 13. Milestone Table

## milestones

```text
id UUID PK
child_id UUID FK
category TEXT
title TEXT
event_date DATE NULL
date_precision TEXT
description TEXT NULL
location_text TEXT NULL
people_present TEXT NULL
created_at DATETIME
updated_at DATETIME
```

`date_precision`:

```text
exact
month
year
approximate
unknown
```

---

# 14. First Words Table

## first_words

```text
id UUID PK
child_id UUID FK
word TEXT NOT NULL
language_code TEXT NULL
event_date DATE NULL
date_precision TEXT
context_note TEXT NULL
audio_asset_id UUID NULL
created_at DATETIME
updated_at DATETIME
```

---

# 15. School Tables

## school_profiles

```text
id UUID PK
child_id UUID FK
school_name TEXT
start_date DATE NULL
end_date DATE NULL
class_name TEXT NULL
teacher_name TEXT NULL
notes TEXT NULL
```

## school_events

```text
id UUID PK
child_id UUID FK
school_profile_id UUID NULL
event_type TEXT
title TEXT
event_date DATE
description TEXT NULL
created_at DATETIME
updated_at DATETIME
```

Examples of `event_type`:

- first_day
- exam
- certificate
- sports
- performance
- class_promotion
- project
- report_card
- custom

---

# 16. Vaccination Table

## vaccinations

```text
id UUID PK
child_id UUID FK
vaccine_name TEXT
dose_label TEXT NULL
scheduled_date DATE NULL
given_date DATE NULL
status TEXT
provider_name TEXT NULL
clinic_name TEXT NULL
batch_number TEXT NULL
notes TEXT NULL
created_at DATETIME
updated_at DATETIME
```

Statuses:

```text
upcoming
completed
delayed
skipped
unknown
```

---

# 17. Illness Table

## illness_episodes

```text
id UUID PK
child_id UUID FK
title TEXT
start_date DATE
end_date DATE NULL
symptoms_json TEXT NULL
max_temperature_c REAL NULL
diagnosis TEXT NULL
doctor_visit_id UUID NULL
recovery_note TEXT NULL
notes TEXT NULL
created_at DATETIME
updated_at DATETIME
```

Store structured symptom selection either as:

- JSON, or
- separate relation table.

For MVP, JSON is acceptable.

---

# 18. Medicine Tables

## medicines

```text
id UUID PK
child_id UUID FK
illness_id UUID NULL
doctor_visit_id UUID NULL
name TEXT
strength TEXT NULL
dosage TEXT NULL
frequency_text TEXT NULL
start_date DATE NULL
end_date DATE NULL
reason TEXT NULL
prescribed_by TEXT NULL
status TEXT
notes TEXT NULL
created_at DATETIME
updated_at DATETIME
```

Statuses:

- active
- completed
- stopped
- as_needed

## medicine_schedules

```text
id UUID PK
medicine_id UUID FK
time_of_day TEXT
days_json TEXT NULL
notification_enabled BOOLEAN
notification_id INTEGER NULL
```

---

# 19. Doctor Visit Table

## doctor_visits

```text
id UUID PK
child_id UUID FK
visit_date DATETIME
doctor_name TEXT
specialty TEXT NULL
hospital_or_chamber TEXT NULL
reason TEXT NULL
symptoms TEXT NULL
diagnosis TEXT NULL
tests_advised TEXT NULL
follow_up_date DATE NULL
notes TEXT NULL
created_at DATETIME
updated_at DATETIME
```

---

# 20. Medical Documents Table

## medical_documents

```text
id UUID PK
child_id UUID FK
document_type TEXT
title TEXT
document_date DATE NULL
illness_id UUID NULL
doctor_visit_id UUID NULL
media_asset_id UUID
notes TEXT NULL
created_at DATETIME
updated_at DATETIME
```

Document types:

- prescription
- diagnostic_report
- vaccination_card
- discharge_summary
- certificate
- growth_chart
- other

---

# 21. Journal Table

## journal_entries

```text
id UUID PK
child_id UUID FK
entry_type TEXT
title TEXT NULL
body TEXT
event_date DATETIME
mood TEXT NULL
location_text TEXT NULL
is_private BOOLEAN DEFAULT FALSE
is_favorite BOOLEAN DEFAULT FALSE
created_at DATETIME
updated_at DATETIME
```

Entry types:

- general
- proud_moment
- difficult_day
- family_event
- trip
- memory
- reflection

---

# 22. Funny Moments

## funny_moments

```text
id UUID PK
child_id UUID FK
event_date DATE
title TEXT NULL
story TEXT NULL
quote_text TEXT NULL
people_present TEXT NULL
is_favorite BOOLEAN
created_at DATETIME
updated_at DATETIME
```

---

# 23. Achievements

## achievements

```text
id UUID PK
child_id UUID FK
title TEXT
category TEXT
event_date DATE
description TEXT NULL
is_favorite BOOLEAN
created_at DATETIME
updated_at DATETIME
```

---

# 24. Birthday Data

## birthdays

```text
id UUID PK
child_id UUID FK
age INTEGER
birthday_date DATE
location_text TEXT NULL
theme TEXT NULL
favorite_gift TEXT NULL
parent_message TEXT NULL
notes TEXT NULL
```

## birthday_answers

```text
id UUID PK
birthday_id UUID FK
question_key TEXT
answer TEXT
sort_order INTEGER
```

---

# 25. Favorites

## favorites

```text
id UUID PK
child_id UUID FK
category TEXT
value TEXT
start_date DATE NULL
end_date DATE NULL
notes TEXT NULL
```

---

# 26. Interests

## interests

```text
id UUID PK
child_id UUID FK
name TEXT
first_noticed DATE NULL
interest_level INTEGER NULL
notes TEXT NULL
```

Recommended `interest_level`:

```text
1..5
```

---

# 27. Media Asset Model

A central media table should avoid duplicate storage logic.

## media_assets

```text
id UUID PK
child_id UUID FK
asset_type TEXT
local_path TEXT
thumbnail_path TEXT NULL
mime_type TEXT
original_filename TEXT NULL
file_size_bytes INTEGER
width INTEGER NULL
height INTEGER NULL
duration_ms INTEGER NULL
captured_at DATETIME NULL
imported_at DATETIME
checksum TEXT NULL
is_favorite BOOLEAN DEFAULT FALSE
created_at DATETIME
```

Types:

- image
- video
- audio
- pdf
- document

---

# 28. Attachment Linking

Use generic attachment relationships.

## attachments

```text
id UUID PK
media_asset_id UUID FK
entity_type TEXT
entity_id UUID
sort_order INTEGER
caption TEXT NULL
created_at DATETIME
```

Example:

```text
entity_type = "milestone"
entity_id = milestone UUID
```

This allows attachments to work across all features.

---

# 29. Tags

## tags

```text
id UUID PK
name TEXT UNIQUE
created_at DATETIME
```

## tag_links

```text
id UUID PK
tag_id UUID FK
entity_type TEXT
entity_id UUID
```

---

# 30. Reminder Table

## reminders

```text
id UUID PK
child_id UUID NULL
entity_type TEXT
entity_id UUID NULL
reminder_type TEXT
scheduled_at DATETIME
repeat_rule TEXT NULL
notification_id INTEGER NULL
is_enabled BOOLEAN
created_at DATETIME
updated_at DATETIME
```

---

# 31. Album Tables

## albums

```text
id UUID PK
child_id UUID FK
album_type TEXT
title TEXT
start_date DATE NULL
end_date DATE NULL
cover_asset_id UUID NULL
theme TEXT
language_code TEXT
created_at DATETIME
updated_at DATETIME
```

## album_items

```text
id UUID PK
album_id UUID FK
entity_type TEXT
entity_id UUID
sort_order INTEGER
is_included BOOLEAN
custom_caption TEXT NULL
```

---

# 32. Timeline Architecture

The unified timeline should combine multiple domain tables.

Avoid maintaining a duplicate timeline table initially.

Instead create a timeline query/service that merges:

- milestones
- growth
- school events
- vaccinations
- illness episodes
- doctor visits
- journal entries
- funny moments
- achievements
- birthdays

Return a shared DTO:

```dart
class TimelineItem {
  final String id;
  final String childId;
  final TimelineItemType type;
  final DateTime eventDate;
  final String title;
  final String? subtitle;
  final String? thumbnailPath;
  final bool favorite;
}
```

For performance:

- Query by date range.
- Paginate.
- Use indexes on `child_id + event_date`.

If complexity becomes high, later add a denormalized `timeline_index` table.

---

# 33. Search Architecture

Implement local search.

## MVP

Use SQL `LIKE` queries across:

- journal titles/body
- milestone title/description
- medicine names
- doctor names
- illness title/diagnosis
- school events
- achievements

## Advanced

Use SQLite FTS5.

Recommended virtual table:

```text
search_index
```

Fields:

```text
entity_id
entity_type
child_id
title
body
keywords
```

Rebuild index when:

- Entry created.
- Entry updated.
- Entry deleted.
- Import completed.

---

# 34. File Storage Layout

Recommended app directory:

```text
/app_data/
├── media/
│   ├── images/
│   ├── thumbnails/
│   ├── videos/
│   ├── audio/
│   └── documents/
│
├── exports/
│   ├── pdf/
│   └── album_images/
│
├── backups/
│
└── temp/
```

Never rely on external public paths as the canonical copy.

---

# 35. Image Handling

When importing an image:

1. Copy into app-private storage.
2. Generate a thumbnail.
3. Read metadata.
4. Calculate checksum.
5. Insert `media_assets`.
6. Link using `attachments`.

Recommended image sizes:

- Original: preserve where practical.
- Preview: 1600–2048 px long edge.
- Thumbnail: 300–500 px.

This prevents huge photos from making the UI slow.

---

# 36. Photo Deduplication

Optional but useful.

Calculate SHA-256 checksum for imported files.

If the checksum already exists:

- Reuse existing asset.
- Create another attachment link if needed.

---

# 37. Database Encryption

Sensitive child and health records should not be stored in plain SQLite where possible.

Recommended:

- SQLCipher-compatible encrypted SQLite solution.

Encryption key:

- Generate random high-entropy key.
- Store only in Keychain/Android Keystore through secure storage.

Never hard-code encryption keys.

---

# 38. App Lock

Security flow:

```text
Launch
  ↓
Has app lock?
  ├── No → App
  └── Yes
       ↓
  PIN/Biometric
       ↓
  Unlock database/session
```

Configurable:

- PIN only.
- Biometrics.
- Auto-lock after timeout.
- Lock when app goes to background.

---

# 39. Backup Architecture

Backups must include:

- Database.
- Media.
- Documents.
- Metadata.
- App version.
- Schema version.
- Manifest.

Recommended backup package:

```text
shishur-dinlipi-backup.sdjbackup
```

Internally:

```text
backup/
├── manifest.json
├── database.sqlite
├── media/
├── documents/
└── checksums.json
```

Then:

1. Zip.
2. Encrypt.
3. Save/export.

---

# 40. Backup Manifest

Example:

```json
{
  "formatVersion": 1,
  "appVersion": "1.0.0",
  "databaseSchemaVersion": 4,
  "createdAt": "2026-10-07T08:00:00+06:00",
  "childCount": 2,
  "assetCount": 340
}
```

---

# 41. Backup Encryption

Recommended:

- AES-256-GCM.

Encryption key options:

### Option A — User password

Derive key from password using:

- Argon2id, or
- PBKDF2 with high iteration count.

### Option B — Device-only backup

Encrypt using secure device-managed key.

For cross-device restore, password-based encryption is better.

---

# 42. Restore Flow

Restore should validate before changing local data.

Process:

1. Select backup.
2. Read header.
3. Request password if encrypted.
4. Verify integrity.
5. Verify format version.
6. Verify database schema compatibility.
7. Show summary.
8. User confirms.
9. Create safety backup of current data.
10. Restore database.
11. Restore media.
12. Run migrations if required.
13. Rebuild search index.
14. Reschedule reminders.

---

# 43. Backup Integrity

Use SHA-256 checksums for files.

Backup manifest should include:

```text
path
size
checksum
```

Reject corrupted restore packages.

---

# 44. Cloud Backup — Future

Core app should not require cloud.

Optional providers later:

- Google Drive.
- Microsoft OneDrive.
- Dropbox.
- iCloud Drive.

Architecture:

```text
BackupService
  ├── LocalBackupProvider
  ├── GoogleDriveProvider
  ├── OneDriveProvider
  ├── DropboxProvider
  └── ICloudProvider
```

Interface:

```dart
abstract class BackupProvider {
  Future<void> upload(BackupFile file);
  Future<List<RemoteBackup>> list();
  Future<File> download(RemoteBackup backup);
}
```

---

# 45. Local Notification Design

All notifications should derive from stored reminder records.

Examples:

- Vaccine scheduled date.
- Medicine times.
- Doctor follow-up.
- Birthday.
- Weekly journal prompt.
- Backup reminder.

On startup:

- Validate scheduled notifications.
- Recreate missing notification schedules if required.

After restore:

- Rebuild all enabled reminders.

---

# 46. Medicine Reminder Architecture

Store medicine schedule independently from platform notifications.

Source of truth:

```text
medicine_schedules
```

Platform notification IDs are disposable.

This is important because:

- App updates can invalidate notifications.
- Restore to new device requires rescheduling.
- OS may remove scheduled notifications.

---

# 47. Localization Architecture

Use ARB files:

```text
lib/l10n/
├── app_en.arb
└── app_bn.arb
```

Example:

```json
{
  "addMemory": "Add Memory",
  "growth": "Growth"
}
```

Bengali:

```json
{
  "addMemory": "স্মৃতি যোগ করুন",
  "growth": "বৃদ্ধি"
}
```

Never store translated UI labels inside business records.

---

# 48. User-Generated Language

User content should remain untouched.

Example:

Parent enters:

> আজ আজওয়াদ প্রথম নিজে সাইকেল চালিয়েছে।

The app stores exactly this text.

No automatic translation in the MVP.

---

# 49. Number and Date Formatting

Use locale-aware formatting.

Examples:

English:

```text
12 October 2026
19.2 kg
```

বাংলা:

```text
১২ অক্টোবর ২০২৬
১৯.২ কেজি
```

Keep raw numeric values language-neutral in storage.

---

# 50. Units

Canonical storage:

- Height: centimeters.
- Weight: kilograms.
- Temperature: Celsius.

UI may convert:

- cm ↔ ft/in.
- kg ↔ lb.
- °C ↔ °F.

Never store only formatted display values.

---

# 51. Growth Charts

Chart data:

```text
date
height_cm
weight_kg
```

Recommended package:

- `fl_chart`

Charts:

- Height over time.
- Weight over time.

For older children with many measurements:

- Downsample only for display.
- Preserve all raw records.

---

# 52. Year-in-Review Engine

The year-review generator should be deterministic and editable.

Input:

```text
childId
startDate
endDate
```

Collect:

- Growth summary.
- Milestones.
- School events.
- Achievements.
- Funny moments.
- Photos.
- Birthdays.
- Favorites.
- Family memories.
- Optional health summary.

---

# 53. Year-in-Review Selection Rules

Suggested prioritization:

1. User-favorited items.
2. Milestones.
3. Achievements.
4. Birthday.
5. Funny quotes.
6. School events.
7. Photos with captions.
8. General journal memories.

Health items should not dominate the album.

---

# 54. Year-in-Review Data Model

Create a view model:

```dart
class YearReview {
  Child child;
  int age;
  DateTime startDate;
  DateTime endDate;
  GrowthSummary growth;
  List<Milestone> milestones;
  List<Achievement> achievements;
  List<FunnyMoment> funnyMoments;
  List<MediaAsset> favoritePhotos;
  List<SchoolEvent> schoolEvents;
  Birthday? birthday;
  String? parentLetter;
}
```

---

# 55. PDF Rendering Architecture

Use a template-driven approach.

```text
YearReviewData
       ↓
AlbumTemplate
       ↓
PDF Renderer
       ↓
Generated PDF
```

Template interface:

```dart
abstract class AlbumTemplate {
  pw.Widget buildCover(...);
  List<pw.Widget> buildPages(...);
}
```

---

# 56. PDF Themes

Initial themes:

- Minimal.
- Playful.
- Colorful.
- Elegant.

Theme settings:

```text
font set
heading sizes
spacing
background assets
decorations
photo frames
page templates
```

---

# 57. Bengali Font Support in PDF

PDF generation must embed a Unicode Bengali font that properly renders বাংলা.

Recommended strategy:

- Bundle licensed/open-source Bengali font in app assets.
- Load font locally.
- Use fallback fonts.

Never depend on network-loaded fonts for offline PDF generation.

---

# 58. PDF Image Optimization

Before embedding:

- Resize huge originals.
- JPEG-compress.
- Respect page dimensions.
- Cache processed versions temporarily.

Otherwise PDFs can become hundreds of MB.

---

# 59. PDF Generation Progress

Generation should report stages:

```text
Preparing memories
Processing photos
Building pages
Saving PDF
Complete
```

Use isolate/background processing for expensive image operations where possible.

---

# 60. PDF Storage

Generated PDFs:

```text
/app_data/exports/pdf/
```

Store metadata:

```text
id
child_id
report_type
title
file_path
created_at
date_range
```

Optional table:

## generated_exports

---

# 61. Album Image Export

For sharing individual pages:

1. Render PDF pages to images, or
2. Build dedicated image-card layouts.

Output:

- PNG.
- JPG.

Used for:

- Messenger.
- WhatsApp.
- Printing.

---

# 62. Quote Card Generator

Funny quotes can be rendered to shareable images.

Input:

```text
child name
age
quote
optional photo
theme
```

Output:

- JPG/PNG.

Do not automatically publish anywhere.

---

# 63. Health Summary Generator

Generate from local records.

Include:

- Blood group.
- Allergies.
- Active medicines.
- Recent illnesses.
- Recent doctor visits.
- Vaccination status.
- Latest growth values.

Always label:

> Parent-entered information. Not a substitute for medical records or professional advice.

---

# 64. Error Handling

Use typed failures.

Example:

```dart
sealed class AppFailure {}

class DatabaseFailure extends AppFailure {}
class FileFailure extends AppFailure {}
class ValidationFailure extends AppFailure {}
class BackupFailure extends AppFailure {}
class RestoreFailure extends AppFailure {}
class PdfGenerationFailure extends AppFailure {}
class PermissionFailure extends AppFailure {}
```

UI maps failures to localized messages.

---

# 65. Logging

Do not log sensitive content.

Avoid logging:

- Child names where unnecessary.
- Medical notes.
- Journal body.
- Prescriptions.
- Photos.
- File paths containing personal names.

Safe logs:

- Feature.
- Action type.
- Duration.
- Error category.
- Database migration version.

---

# 66. Audit Events

Optional local audit table.

Examples:

```text
profile_created
record_deleted
backup_created
restore_completed
pdf_generated
security_setting_changed
```

Do not store excessive private content.

---

# 67. Database Migration Strategy

Every release that changes schema must:

1. Increment schema version.
2. Add tested migration.
3. Preserve existing user data.
4. Run integrity checks.
5. Never reset database automatically.

Example:

```text
v1 → base
v2 → add attachments
v3 → add reminders
v4 → add year review settings
```

---

# 68. Transaction Boundaries

Use transactions for multi-step writes.

Example:

Adding a doctor visit with prescription photo:

```text
BEGIN
create doctor_visit
create media_asset
create attachment
create follow_up reminder
COMMIT
```

If any step fails:

```text
ROLLBACK
```

---

# 69. Deletion Strategy

Prefer soft delete for critical historical entries.

Example:

```text
deleted_at
```

Hard-delete media only when:

- No attachment links remain.
- User explicitly confirms.
- Backup/export is not in progress.

---

# 70. Media Cleanup

Background maintenance can:

- Find orphaned thumbnails.
- Find unused assets.
- Find broken file references.
- Remove stale temp files.

Never remove user media solely because it appears old.

---

# 71. Offline-First Behavior

All primary flows work offline:

- Create profile.
- Add memory.
- Add photo.
- Record growth.
- Add milestone.
- Record illness.
- Add doctor visit.
- Add vaccine.
- Search.
- Generate PDF.
- Backup locally.

Internet is only needed for future optional cloud features.

---

# 72. Permission Strategy

Request permissions only when needed.

Examples:

Camera:

- Ask when user chooses camera.

Photos:

- Ask when user imports image.

Notifications:

- Ask when user enables reminders.

Biometrics:

- Ask when user enables app lock.

Avoid requesting every permission during onboarding.

---

# 73. App Startup Flow

Recommended:

```text
Launch
 ↓
Initialize secure storage
 ↓
Open encrypted DB
 ↓
Run migration
 ↓
Check app lock
 ↓
Load settings
 ↓
Load selected child
 ↓
Home
```

---

# 74. First-Run Flow

Recommended:

```text
Splash
 ↓
Language
 ↓
Privacy summary
 ↓
Create first child
 ↓
Optional app lock
 ↓
Home
```

Keep onboarding short.

---

# 75. Dashboard Query Design

Dashboard should not load entire history.

Separate queries:

- Current child.
- Latest height/weight.
- 5 recent timeline items.
- Upcoming reminders.
- On This Day.
- Suggested memory prompt.

---

# 76. On This Day Query

Match:

```text
month(event_date) = current_month
day(event_date) = current_day
year(event_date) < current_year
```

Return:

- Most recent historical memory first.
- Limit results.

---

# 77. Child Age Calculation

Do not store current age.

Compute dynamically from:

```text
date_of_birth
event_date
```

This prevents stale values.

For events:

```dart
Age ageAtEvent(DateTime dob, DateTime eventDate)
```

Return:

```text
years
months
days
```

---

# 78. Parent Letter

Store separately or inside year-review preferences.

Recommended:

## year_review_preferences

```text
id UUID PK
child_id UUID
year INTEGER
parent_letter TEXT NULL
cover_asset_id UUID NULL
theme TEXT
include_health BOOLEAN
language_code TEXT
updated_at DATETIME
```

---

# 79. Data Validation

Examples:

## Growth

- Height must be positive.
- Weight must be positive.
- Future measurement date blocked unless intentionally supported.

## Vaccination

- Given date can be empty for upcoming doses.

## Medicine

- End date cannot be before start date.

## Illness

- End date cannot be before start date.

## Child

- Date of birth cannot be after today.

Use soft warnings rather than excessive blocking where historical data may be approximate.

---

# 80. Approximate Dates

Some memories lack exact dates.

Domain type:

```dart
enum DatePrecision {
  exact,
  month,
  year,
  approximate,
  unknown,
}
```

Store:

```text
event_date
date_precision
```

Display:

```text
Around March 2023
Sometime in 2022
```

---

# 81. Parent-Entered Medical Disclaimer

For health pages:

> Information in Shishur Dinlipi is entered by the parent or caregiver and should not replace official medical records or professional medical advice.

বাংলা:

> শিশুর দিনলিপিতে সংরক্ষিত স্বাস্থ্য তথ্য অভিভাবক বা পরিচর্যাকারীর দেওয়া তথ্য। এটি চিকিৎসকের পরামর্শ বা সরকারি/হাসপাতালের মেডিকেল রেকর্ডের বিকল্প নয়।

---

# 82. Performance Targets

Recommended targets:

- App cold start: under 2–3 seconds on mid-range device where practical.
- Timeline first page: under 500 ms.
- Local search: under 500 ms for normal datasets.
- Save typical entry: under 300 ms excluding media copy.
- Thumbnail load: smooth 60 FPS scrolling where device allows.
- PDF generation: asynchronous with visible progress.

---

# 83. Large Dataset Strategy

Expected long-term usage:

- 10–20 years.
- Thousands of entries.
- Thousands of photos.

Use:

- Pagination.
- Thumbnail images.
- Indexed queries.
- Lazy image loading.
- FTS for search.
- Streaming file operations for backups.

---

# 84. Memory Safety

Do not load all photos into memory.

When generating large albums:

- Process one image/page at a time.
- Resize before embedding.
- Release buffers.
- Write output incrementally where supported.

---

# 85. Testing Strategy

## Unit Tests

Cover:

- Age calculation.
- Growth conversions.
- Date precision.
- Year-review selection.
- Validation.
- Backup manifest generation.
- Reminder calculations.

## Repository Tests

Cover:

- CRUD.
- Transactions.
- Filtering.
- Search.
- Soft deletion.

## Widget Tests

Cover:

- Child selector.
- Forms.
- Empty states.
- Language switching.

## Integration Tests

Cover:

- Create child.
- Add memory.
- Add photo.
- Generate review.
- Backup.
- Restore.

---

# 86. Backup/Restore Test Cases

Must test:

- Empty database.
- Large photo library.
- Wrong password.
- Corrupt archive.
- Missing media.
- Older schema.
- Interrupted restore.
- Restore to fresh install.
- Multiple children.

---

# 87. Localization Testing

Test:

- Bengali layout wrapping.
- Long Bengali text.
- Dynamic font size.
- Mixed English/Bengali.
- Bengali numerals if enabled.
- PDF Bengali rendering.

---

# 88. Security Testing

Test:

- PIN brute-force controls.
- Secure key storage.
- Backup encryption.
- Database encryption.
- App background snapshots.
- Biometric failure.
- Lock timeout.
- File exposure.

---

# 89. App Background Privacy

When app enters background:

Optional:

- Blur sensitive screen.
- Hide recent-app preview.
- Auto-lock after configured duration.

---

# 90. Screenshot Protection

Android:

- Optional `FLAG_SECURE`.

iOS:

- Detect screen capture where feasible.
- Blur snapshot when app backgrounds.

Make this configurable because parents may want screenshots of memories.

---

# 91. Crash Recovery

Before critical long operations:

- Save draft where useful.
- Use temp files.
- Rename only after successful write.

Example backup:

```text
backup.tmp
→ checksum
→ backup.sdjbackup
```

Never leave partially written backup appearing valid.

---

# 92. Draft Handling

Forms such as:

- Journal.
- Doctor visit.
- Illness.
- Year-review parent letter.

Can support local draft state.

Use:

- Riverpod form state.
- Optional draft table for long forms.

---

# 93. Optional Draft Table

## drafts

```text
id UUID PK
child_id UUID NULL
draft_type TEXT
payload_json TEXT
updated_at DATETIME
```

Automatically clear after successful save.

---

# 94. Notifications After Restore

After restore:

1. Query all active reminders.
2. Cancel obsolete platform notifications.
3. Schedule future notifications.
4. Skip past occurrences.
5. Log failures safely.

---

# 95. Child Switching

Switching child should invalidate:

- Dashboard providers.
- Timeline providers.
- Search scope.
- Album lists.
- Health summaries.

Use Riverpod families where practical.

---

# 96. Caching

Safe cache candidates:

- Thumbnails.
- PDF preview pages.
- Derived summaries.
- Search suggestions.

Do not use cache as authoritative storage.

---

# 97. Settings Storage

Use database or SharedPreferences for non-sensitive UI preferences.

Examples:

- Theme.
- Language.
- Selected child.
- Unit preferences.
- Prompt frequency.

Use secure storage for:

- Encryption key.
- PIN verifier.
- Tokens.
- Sensitive cryptographic material.

---

# 98. App Settings Model

```dart
class AppSettings {
  Locale locale;
  ThemeMode themeMode;
  String? selectedChildId;
  HeightUnit heightUnit;
  WeightUnit weightUnit;
  TemperatureUnit temperatureUnit;
  bool useBengaliDigits;
  bool onThisDayEnabled;
  bool memoryPromptsEnabled;
}
```

---

# 99. Data Export

Export should support:

## PDF

- Health summary.
- Year review.
- Custom album.

## Structured export

Optional:

- JSON.
- CSV for growth.
- CSV for vaccinations.

## Full archive

Encrypted backup.

---

# 100. JSON Export Example

```json
{
  "child": {
    "name": "Azwad",
    "dateOfBirth": "2021-04-10"
  },
  "growthRecords": [],
  "milestones": [],
  "journalEntries": []
}
```

This is different from encrypted backup.

Backup is for restoration.

JSON export is for portability.

---

# 101. Import Safety

Never overwrite local data immediately.

Import flow:

```text
Parse
 ↓
Validate
 ↓
Preview
 ↓
Resolve duplicates
 ↓
Commit transaction
```

---

# 102. Duplicate Detection

Potential matching rules:

### Child

- Same name + DOB.

### Growth

- Same child + same date + same height/weight.

### Vaccine

- Same child + vaccine + dose + date.

### Media

- Same SHA-256 checksum.

---

# 103. Future Family Sharing

If family sharing is added later, do not tightly couple MVP entities to a single device user.

Future fields could include:

```text
owner_id
created_by
updated_by
sync_version
```

Do not require these for MVP unless sync work is planned early.

---

# 104. Future AI Architecture

AI should remain an optional adapter.

Potential features:

- Yearly narrative.
- Memory summary.
- Caption suggestions.
- OCR.
- Semantic search.

Interface:

```dart
abstract class AiService {
  Future<String> summarizeYear(...);
}
```

Never embed AI logic directly into repositories.

---

# 105. AI Privacy Rule

Any future AI feature must:

- Ask permission.
- Explain what data leaves the device.
- Minimize transmitted data.
- Avoid sending entire child archives unnecessarily.
- Allow AI to remain fully disabled.

---

# 106. OCR — Future

Use cases:

- Vaccination card.
- Prescription.
- Report.

Recommended flow:

```text
Photo
 ↓
Local OCR where possible
 ↓
Review extracted fields
 ↓
Parent confirms
 ↓
Save
```

Never save extracted medical details without confirmation.

---

# 107. Analytics

For a privacy-focused child journal, analytics should be minimal.

If included:

Track anonymous product events such as:

- Screen opened.
- Feature used.
- PDF generation success/failure.

Do not collect:

- Child names.
- Medical details.
- Journal text.
- Photos.

Provide opt-out.

---

# 108. Crash Reporting

If remote crash reporting is introduced:

- Strip sensitive context.
- Do not attach database.
- Do not attach screenshots.
- Avoid custom logs containing child data.

---

# 109. Release Build Security

Production builds should:

- Disable debug logs.
- Obfuscate Dart symbols if desired.
- Store secrets outside source.
- Enforce signing.
- Validate backup cryptography.
- Use release database migrations.

---

# 110. Android Considerations

Support:

- Scoped storage.
- Photo Picker where available.
- BiometricPrompt.
- Notification permission on supported Android versions.
- Background notification rescheduling after reboot if needed.

Avoid unnecessary broad storage permissions.

---

# 111. iOS Considerations

Support:

- Photo library limited access.
- Face ID/Touch ID.
- Local notifications.
- Files export/share.
- Privacy usage descriptions.

Use app-private sandbox storage.

---

# 112. Accessibility Technical Requirements

Every major control should support:

- Semantic labels.
- Screen readers.
- Dynamic type.
- Minimum touch target sizes.
- Logical focus order.
- Non-color-only status indicators.

---

# 113. Common Reusable Components

Create reusable widgets for:

- Child switcher.
- Timeline card.
- Empty state.
- Error state.
- Photo picker.
- Attachment strip.
- Date precision picker.
- Search bar.
- Filter bottom sheet.
- Money-free numeric input.
- Growth input.
- Reminder editor.
- Confirmation sheet.
- PDF generation progress.

---

# 114. Domain Repository Interfaces

Example:

```dart
abstract class ChildRepository {
  Future<List<Child>> getChildren();
  Future<Child?> getById(String id);
  Future<void> save(Child child);
  Future<void> delete(String id);
}
```

Timeline:

```dart
abstract class TimelineRepository {
  Future<List<TimelineItem>> getPage({
    required String childId,
    DateTime? before,
    int limit = 30,
    Set<TimelineItemType>? filters,
  });
}
```

---

# 115. Year Review Use Case

Pseudo-flow:

```text
GenerateYearInReview
    ↓
Load child
    ↓
Calculate age range
    ↓
Load growth summary
    ↓
Load milestones
    ↓
Load school events
    ↓
Load favorite memories/photos
    ↓
Load achievements
    ↓
Load funny moments
    ↓
Load birthday/favorites
    ↓
Apply inclusion preferences
    ↓
Return YearReview model
```

---

# 116. PDF Generation Use Case

```text
GenerateYearReviewPdf
    ↓
Build YearReview
    ↓
Prepare optimized images
    ↓
Load template
    ↓
Render PDF
    ↓
Write temp file
    ↓
Validate
    ↓
Move to exports
    ↓
Save export metadata
```

---

# 117. Backup Use Case

```text
CreateBackup
    ↓
Checkpoint database
    ↓
Copy database snapshot
    ↓
Collect referenced media
    ↓
Build manifest
    ↓
Generate checksums
    ↓
Create archive
    ↓
Encrypt archive
    ↓
Write final file
```

---

# 118. Database Backup Consistency

Before copying SQLite database:

- Use WAL checkpoint.
- Ensure transaction completes.
- Copy consistent database state.

Alternatively:

- Use SQLite backup API where supported.

---

# 119. Suggested Database Indexes

Examples:

```sql
CREATE INDEX idx_growth_child_date
ON growth_records(child_id, measured_at DESC);

CREATE INDEX idx_milestone_child_date
ON milestones(child_id, event_date DESC);

CREATE INDEX idx_journal_child_date
ON journal_entries(child_id, event_date DESC);

CREATE INDEX idx_vaccine_child_date
ON vaccinations(child_id, scheduled_date);

CREATE INDEX idx_doctor_child_date
ON doctor_visits(child_id, visit_date DESC);

CREATE INDEX idx_achievement_child_date
ON achievements(child_id, event_date DESC);
```

---

# 120. Recommended MVP Technical Scope

## Foundation

- Flutter.
- Riverpod.
- GoRouter.
- Drift.
- Encrypted SQLite.
- Secure storage.
- App-private filesystem.

## Features

- Child profiles.
- Timeline.
- Journal.
- Growth.
- Milestones.
- School.
- Vaccination.
- Illness.
- Medicines.
- Doctor visits.
- Photos.
- Achievements.
- Funny moments.
- Year review.
- PDF generation.

## Security

- PIN.
- Biometrics.
- Local encryption.

## Backup

- Encrypted local backup.
- Restore.

## Localization

- English.
- বাংলা.

---

# 121. Suggested Later Technical Phases

## Phase 2

- Full-text search.
- Birthday interviews.
- Favorites.
- Interests.
- Custom albums.
- Quote cards.
- Photo page export.

## Phase 3

- Google Drive backup.
- OneDrive backup.
- Dropbox backup.
- iCloud integration.
- OCR.

## Phase 4

- AI-assisted summaries.
- Smart album suggestions.
- Shared family access.
- Cross-device sync.

---

# 122. Security Boundaries

The most sensitive assets are:

1. Encryption keys.
2. Child medical history.
3. Private journal entries.
4. Child photos.
5. Backup archives.

Threats to protect against:

- Lost phone.
- Casual unauthorized access.
- Unencrypted exported backup.
- Media leaking into public gallery.
- Logs exposing private data.
- Corrupted restores.

---

# 123. Recommended Privacy Defaults

Default:

- No account.
- No cloud.
- No analytics containing sensitive data.
- App-private photos.
- Encrypted database.
- Encrypted backup.
- Parent explicitly chooses export/share.

---

# 124. Development Environments

Recommended environments:

```text
dev
staging
prod
```

Even without a backend, this helps configure:

- Debug logging.
- Crash tools.
- Feature flags.
- Experimental features.

---

# 125. Feature Flags

Potential flags:

```text
cloud_backup
video_memories
ocr
ai_summary
growth_percentiles
family_sharing
```

This allows advanced features to remain disabled until ready.

---

# 126. CI/CD

Recommended:

- GitHub Actions or equivalent.

Pipeline:

```text
format
analyze
unit tests
widget tests
build Android
build iOS
artifact checks
```

Release:

- Google Play internal testing.
- TestFlight.

---

# 127. Code Quality

Enforce:

- Dart analyzer.
- Strict lints.
- No dynamic unless justified.
- Repository abstraction.
- Immutable domain models.
- Testable use cases.
- No direct DB access from widgets.

---

# 128. Suggested Dependencies

Indicative package list:

```yaml
dependencies:
  flutter:
    sdk: flutter

  flutter_riverpod:
  riverpod_annotation:
  go_router:
  drift:
  sqlite3_flutter_libs:
  path_provider:
  flutter_secure_storage:
  local_auth:
  image_picker:
  image:
  flutter_local_notifications:
  timezone:
  intl:
  pdf:
  printing:
  share_plus:
  file_picker:
  archive:
  crypto:
  uuid:
  fl_chart:
```

Encryption-related dependencies should be selected carefully during implementation.

---

# 129. Example Core Domain Model

```dart
class Child {
  final String id;
  final String name;
  final DateTime dateOfBirth;
  final String? nickname;
  final String? bloodGroup;
  final String? profilePhotoId;
}
```

Milestone:

```dart
class Milestone {
  final String id;
  final String childId;
  final String title;
  final MilestoneCategory category;
  final DateTime? eventDate;
  final DatePrecision datePrecision;
  final String? description;
}
```

---

# 130. Recommended Build Order

Implement in this dependency order:

1. Project foundation.
2. Database.
3. Child profile.
4. Media storage.
5. Timeline.
6. Journal.
7. Growth.
8. Milestones.
9. Health records.
10. School.
11. Achievements/funny moments.
12. Search.
13. Reminders.
14. Year Review.
15. PDF.
16. Security.
17. Backup/restore.
18. Polish/localization/testing.

---

# 131. Key Architectural Decision Summary

| Area | Decision |
|---|---|
| Client | Flutter |
| State | Riverpod |
| Navigation | GoRouter |
| Database | Drift + SQLite |
| Encryption | SQLCipher-compatible encrypted SQLite |
| Media | App-private filesystem |
| Secure secrets | Keychain/Keystore via secure storage |
| PDF | Local `pdf` package |
| Notifications | Local notifications |
| Search | SQL first, FTS5 later |
| Localization | ARB + intl |
| Backup | Encrypted archive |
| Backend | None for MVP |
| Cloud | Optional future integration |
| AI | Optional future adapter |

---

# 132. Final Technical Principle

The app should be designed as a **private long-term family archive**, not a disposable tracker.

That means technical decisions must prioritize:

- Data durability.
- Privacy.
- Offline access.
- Exportability.
- Recoverability.
- Stable migrations.

A parent may keep data in **Shishur Dinlipi** for 10–20 years.

The architecture should therefore treat every child's memory, photo, medical note, and milestone as information that must survive:

- App updates.
- Device changes.
- Database migrations.
- Backup/restore.
- Long periods of offline use.

The central engineering goal is:

> **Preserve a child's story safely for years, while keeping the app simple enough for a parent to use every day.**
