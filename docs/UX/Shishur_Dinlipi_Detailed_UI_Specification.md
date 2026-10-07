# Shishur Dinlipi — Detailed UI Specification
## All Screens, Flows, Components & States

**Product Name:** Shishur Dinlipi  
**বাংলা নাম:** শিশুর দিনলিপি  
**Product Type:** Offline-first Child Development Journal  
**Platforms:** Android and iOS  
**Languages:** English and বাংলা  
**Primary Users:** Parents and caregivers  
**Navigation Model:** Bottom navigation + nested detail flows  
**Core Sections:** Home, Timeline, Add, Albums, More  

---

# 1. UI Design Principles

The UI should feel warm, trustworthy, private, family-oriented, simple, calm, and emotionally meaningful.

Avoid clinical hospital-style visual language, dense dashboards, too many charts on one screen, technical terminology, heavy animation, and overly childish visuals.

The app should balance:

**Health record seriousness + family memory warmth**

---

# 2. Global Layout System

## 2.1 Mobile Width

Design primarily for 360–430 px phone width.

## 2.2 Spacing Scale

- 4 px — micro.
- 8 px — compact.
- 12 px — related.
- 16 px — standard.
- 24 px — section.
- 32 px — major section.
- 40+ px — screen separation.

## 2.3 Corner Radius

- Small controls: 8 px.
- Cards: 12–16 px.
- Large panels: 20 px.
- Bottom sheets: 24 px top corners.

## 2.4 Touch Targets

Minimum 44 × 44 px; prefer 48 × 48 px.

## 2.5 Typography

- Display: 28–32 px, bold.
- Screen title: 24 px, semibold/bold.
- Section heading: 18–20 px, semibold.
- Card title: 16 px, semibold.
- Body: 14–16 px.
- Caption: 12–13 px.

Bengali typography must remain readable at the same hierarchy.

---

# 3. Color Direction

Use a soft family-friendly palette.

Suggested semantic use:

- Primary: calm blue/teal.
- Positive: green.
- Reminder: amber.
- Health warning: warm red.
- Memory/highlight: soft purple.
- Background: warm neutral.

Never encode meaning with color alone; combine icon, label, and status text.

---

# 4. Bottom Navigation

Main navigation:

1. Home / হোম
2. Timeline / সময়রেখা
3. Add / যোগ করুন
4. Albums / অ্যালবাম
5. More / আরও

The Add destination should visually stand out and open a clear quick-add experience.

---

# 5. Screen Inventory

## A. Launch & Onboarding
1. Splash
2. Language Selection
3. Privacy Introduction
4. Welcome
5. Create First Child
6. Add Child Photo
7. Optional Security Setup
8. Setup Complete

## B. Authentication / App Lock
9. App Locked
10. Enter PIN
11. Biometric Prompt State
12. Forgot PIN Guidance
13. Change PIN
14. Set PIN
15. Verify Current PIN

## C. Home
16. Home Dashboard
17. Child Switcher
18. Memory Prompt
19. Memory From the Past
20. Upcoming Reminder Details

## D. Child Profiles
21. Child List
22. Child Profile
23. Add Child
24. Edit Child
25. Delete Child Confirmation
26. Child Photo Viewer

## E. Timeline
27. Timeline Home
28. Timeline Filter
29. Timeline Search
30. Timeline Date Jump
31. Timeline Item Detail

## F. Quick Add
32. Add Menu
33. Add General Memory
34. Add Photo Memory
35. Add Growth
36. Add Milestone
37. Add First Word
38. Add Funny Moment
39. Add Achievement
40. Add School Event
41. Add Vaccination
42. Add Illness
43. Add Medicine
44. Add Doctor Visit

## G. Journal
45. Journal List
46. Journal Detail
47. Edit Journal
48. Tag Selector
49. Mood Selector

## H. Growth
50. Growth Overview
51. Growth History
52. Add/Edit Growth
53. Height Chart
54. Weight Chart
55. Growth Record Detail

## I. Milestones
56. Milestone Overview
57. Milestone Categories
58. Milestone List
59. Milestone Detail
60. Add/Edit Milestone
61. Date Precision Selector
62. First Words List
63. First Word Detail
64. Add/Edit First Word

## J. School
65. School Overview
66. School Profiles
67. Add School
68. Edit School
69. School Events List
70. School Event Detail
71. Add/Edit School Event
72. Report Card/Certificate Viewer

## K. Health
73. Health Overview
74. Vaccination List
75. Vaccination Detail
76. Add/Edit Vaccination
77. Illness History
78. Illness Detail
79. Add/Edit Illness
80. Symptom Selector
81. Medicine List
82. Medicine Detail
83. Add/Edit Medicine
84. Medicine Schedule
85. Doctor Visits List
86. Doctor Visit Detail
87. Add/Edit Doctor Visit
88. Medical Documents
89. Medical Document Detail
90. Add Medical Document
91. Health Summary
92. Allergies List
93. Add/Edit Allergy

## L. Achievements & Funny Moments
94. Achievements List
95. Achievement Detail
96. Add/Edit Achievement
97. Funny Moments List
98. Funny Moment Detail
99. Add/Edit Funny Moment
100. Quote Card Preview

## M. Photos & Media
101. Photos Home
102. Photo Grid
103. Photo Detail
104. Media Picker
105. Photo Metadata
106. Favorites Photos
107. Media Missing State

## N. Birthdays & Favorites
108. Birthday Timeline
109. Birthday Detail
110. Add/Edit Birthday
111. Birthday Interview
112. Favorites Overview
113. Add/Edit Favorite

## O. Interests
114. Interests List
115. Interest Detail
116. Add/Edit Interest

## P. Albums
117. Albums Home
118. Album Detail
119. Create Album
120. Edit Album
121. Add Items to Album
122. Reorder Album Items
123. Album Theme Picker
124. Album Cover Picker

## Q. Year in Review
125. Year in Review Home
126. Select Year/Age
127. Review Highlights
128. Review Section Editor
129. Parent Letter
130. Review Cover Editor
131. Review Theme
132. Review Preview
133. Generate PDF
134. PDF Generation Progress
135. PDF Ready
136. PDF Viewer
137. Export/Share Sheet

## R. Search
138. Global Search
139. Search Filters
140. Search Results
141. Search Result Preview

## S. Calendar & Reminders
142. Calendar
143. Day Detail
144. Reminders List
145. Add/Edit Reminder
146. Reminder Detail
147. Notification Permission Explanation

## T. Backup & Restore
148. Backup & Restore Home
149. Create Backup
150. Backup Password
151. Backup Progress
152. Backup Complete
153. Restore File Picker
154. Restore Password
155. Restore Summary
156. Restore Confirmation
157. Restore Progress
158. Restore Complete
159. Corrupt Backup
160. Backup History

## U. Settings
161. Settings Home
162. General Settings
163. Language Settings
164. Appearance Settings
165. Unit Settings
166. Notification Settings
167. Memory Prompt Settings
168. Privacy & Security
169. App Lock Settings
170. Auto Lock Settings
171. Backup Settings
172. Export Settings
173. Storage Settings
174. About
175. Privacy Information
176. Medical Disclaimer

## V. Common Components & States
177. Initial Loading
178. Skeleton Loading
179. Empty State
180. No Search Results
181. Save in Progress
182. Save Success
183. Save Failed
184. Delete Confirmation
185. Delete Failed
186. Unsaved Changes
187. Permission Denied
188. Camera Permission Denied
189. Photo Permission Denied
190. Notification Permission Denied
191. Storage Almost Full
192. Database Migration
193. Backup Failed
194. Restore Failed
195. PDF Generation Failed
196. Generic Error
197. Date Picker
198. Month/Year Picker
199. Child Selector Sheet
200. Search & Filter Sheet
201. Confirmation Bottom Sheet
202. Attachment Picker
203. Attachment Preview
204. Full-screen Image Viewer

---

# 6. A. Launch & Onboarding

## 6.1 Splash Screen

Purpose: brand introduction and app initialization.

Layout:
- Centered app icon.
- App name: `Shishur Dinlipi`.
- Bengali name: `শিশুর দিনলিপি`.
- Tagline: `Your child's story, preserved with care.`
- Bengali: `আপনার শিশুর গল্প, যত্নে সংরক্ষিত।`
- Small progress indicator only if initialization is noticeable.

Do not show cached child names, medical records, or private thumbnails before unlock.

## 6.2 Language Selection

Title: `Choose your language` / `আপনার ভাষা বেছে নিন`

Options:
- English
- বাংলা

Each option uses a large radio card.

Primary CTA: `Continue / এগিয়ে যান`

## 6.3 Privacy Introduction

Sections:
- Private by default.
- Works offline.
- You control exports.

Primary CTA: Continue  
Secondary: Read privacy details

## 6.4 Welcome

Warm illustration.

Title:
`Preserve the little moments that become big memories.`

বাংলা:
`ছোট ছোট মুহূর্তগুলোই একদিন বড় স্মৃতি হয়ে থাকে।`

Highlights:
- Growth
- Health
- Milestones
- Photos
- Yearly albums

CTA: Create Child Profile

## 6.5 Create First Child

Fields:
- Child name*
- Nickname
- Date of birth*
- Gender optional
- Blood group optional

Photo placeholder at top.

Primary CTA: Continue  
Secondary: Add more details later

Validation:
- Name required
- DOB cannot be future

## 6.6 Add Child Photo

Large circular photo placeholder.

Actions:
- Take Photo
- Choose from Gallery
- Skip for now

## 6.7 Optional Security Setup

Title: `Protect your child's journal`

Options:
- Set PIN
- Enable biometrics
- Set up later

## 6.8 Setup Complete

Show child card and CTA `Go to Home`.

Optional secondary CTA: Add first memory.

---

# 7. B. Authentication / App Lock

## 7.1 App Locked

Show app icon, neutral background, and `Shishur Dinlipi is locked`.

Actions:
- Unlock with biometrics
- Enter PIN

No child details visible.

## 7.2 Enter PIN

Show 4–6 PIN dots and numeric keypad.

Actions:
- Use biometrics
- Forgot PIN?

Repeated failures should introduce delay.

## 7.3 Biometric Prompt State

Text:
`Use Face ID / fingerprint to unlock Shishur Dinlipi.`

Actions:
- Try Again
- Use PIN

## 7.4 Forgot PIN Guidance

Explain local/offline recovery limitations clearly.

Actions:
- Use biometric if available
- Restore from backup
- Return

## 7.5 Set PIN

Step 1: Create PIN  
Step 2: Confirm PIN

## 7.6 Change PIN

Fields:
- Current PIN
- New PIN
- Confirm new PIN

Success: `PIN updated.`

---

# 8. C. Home

## 8.1 Home Dashboard

Top app bar:
- Child avatar
- Child name
- Child switcher chevron
- Search icon

Hero:
`Good morning`
`Azwad is now 5 years 4 months`

Sections:

### Growth Snapshot
- Latest height
- Latest weight
- Measurement date
- Small trend

### Quick Add
- Memory
- Photo
- Growth
- Milestone
- Health
- Achievement

### Recent Memories
Show 3–5 recent items with icon, title, date, child age, thumbnail.

### Upcoming
- Vaccination
- Medicine
- Doctor follow-up
- Birthday

### Memory From the Past
Historical card.

### Memory Prompt
Example: `What made Azwad smile today?`

CTA: Write Memory

## 8.2 Child Switcher

Bottom sheet rows:
- Photo
- Name
- Age
- Checkmark

Actions:
- Add Child
- Manage Children

## 8.3 Memory Prompt

Actions:
- Write now
- New prompt
- Not now

## 8.4 Memory From the Past

Show:
- `2 years ago today`
- Photo
- Title
- Short story

Actions:
- View
- Share
- Add reflection

## 8.5 Upcoming Reminder Detail

Show:
- Reminder type
- Date/time
- Linked record
- Notes

Actions:
- Edit
- Mark done where applicable
- Snooze where appropriate

---

# 9. D. Child Profiles

## 9.1 Child List

Cards:
- Photo
- Name
- Age
- Latest height/weight
- School optional

Actions:
- Edit
- Set as default
- Delete

## 9.2 Child Profile

Header:
- Large photo
- Name
- Nickname
- Age
- DOB

Sections:
- About
- Growth
- School
- Health quick facts
- Recent milestones
- Recent photos

## 9.3 Add Child

Sections:
- Basic
- Birth
- Health
- School
- Notes

Sticky CTA: Save Child

## 9.4 Edit Child

Same as Add plus:
- Remove photo
- Archive/delete

## 9.5 Delete Child Confirmation

Strong warning. Recommend backup before deletion.

## 9.6 Child Photo Viewer

Full-screen image with Replace, Share if allowed, Close.

---

# 10. E. Timeline

## 10.1 Timeline Home

App bar: Timeline, Search, Filter.

Top:
- Child selector
- Filter chips

Chips:
- All
- Memories
- Growth
- Milestones
- Health
- School

List grouped by month.

Each card:
- Type icon
- Title
- Date
- Age at event
- Thumbnail
- Category

## 10.2 Timeline Filter

Fields:
- Category
- Date range
- Favorites only
- Has photos
- Tags

Actions: Reset / Apply

## 10.3 Timeline Search

Local search with immediate results.

## 10.4 Timeline Date Jump

Options:
- Today
- This month
- Select month/year
- Select exact date

## 10.5 Timeline Item Detail

Show category, date, age, title, description, attachments.

Actions:
- Edit
- Favorite
- Share
- Delete

---

# 11. F. Quick Add

## 11.1 Add Menu

Group into:
- Memories
- Development
- Health
- School

Items:
- Memory
- Photo
- Growth
- Milestone
- First Word
- Funny Moment
- Achievement
- School Event
- Vaccination
- Illness
- Medicine
- Doctor Visit

## 11.2 Add General Memory

Fields:
- Date/time
- Title
- Story
- Mood
- Location
- Photos
- Tags
- Favorite

CTA: Save Memory

## 11.3 Add Photo Memory

Step 1: Select/take photo  
Step 2: Caption, Date, Tags, Related milestone, Favorite

## 11.4 Add Growth

Fields:
- Date
- Height
- Weight
- Unit
- Location
- Notes

Show previous measurement for context.

## 11.5 Add Milestone

Fields:
- Category
- Title
- Date precision
- Date
- Story
- Location
- Who was present
- Attachments

## 11.6 Add First Word

Fields:
- Word
- Language
- Date
- Context/story
- Audio optional
- Photo

## 11.7 Add Funny Moment

Fields:
- Date
- Title
- Funny quote
- Story
- Who was there
- Photo/video
- Favorite

## 11.8 Add Achievement

Fields:
- Title
- Category
- Date
- Description
- Photo
- Certificate

## 11.9 Add School Event

Fields:
- School
- Event type
- Date
- Title
- Description
- Attachment

## 11.10 Add Vaccination

Fields:
- Vaccine name
- Dose
- Scheduled date
- Given date
- Status
- Provider
- Clinic
- Batch
- Attachment
- Notes
- Reminder toggle

## 11.11 Add Illness

Fields:
- Title
- Start date
- End date
- Symptoms
- Max temperature
- Diagnosis
- Doctor visit link
- Notes
- Attachments

## 11.12 Add Medicine

Fields:
- Medicine name
- Strength
- Dose
- Frequency
- Start
- End
- Reason
- Prescribed by
- Status
- Reminder toggle

## 11.13 Add Doctor Visit

Fields:
- Visit date
- Doctor
- Specialty
- Chamber/hospital
- Reason
- Symptoms
- Diagnosis
- Tests advised
- Follow-up
- Notes
- Prescription attachment

---

# 12. G. Journal

## 12.1 Journal List

Top:
- Search
- Filter
- Add

Filters:
- All
- Favorites
- Proud moments
- Family
- Difficult day

## 12.2 Journal Detail

Show full story, date, age, photos, tags, mood, location.

Actions: Edit / Favorite / Share / Delete

## 12.3 Edit Journal

Same as add with Save Changes and Discard Changes.

## 12.4 Tag Selector

Searchable bottom sheet:
- Recent
- Existing
- Create new

## 12.5 Mood Selector

Optional chips:
- Happy
- Proud
- Excited
- Calm
- Sad
- Tired
- Difficult

---

# 13. H. Growth

## 13.1 Growth Overview

Summary:
- Latest height
- Latest weight
- Mini height chart
- Mini weight chart

Actions:
- Add Measurement
- View History

## 13.2 Growth History

Rows:
- Date
- Height
- Weight
- Delta

## 13.3 Add/Edit Growth

Form with previous measurement shown as context.

## 13.4 Height Chart

Range controls:
- 6 months
- 1 year
- All time

## 13.5 Weight Chart

Same pattern.

## 13.6 Growth Record Detail

Show height, weight, date, location, note.

---

# 14. I. Milestones

## 14.1 Milestone Overview

Sections:
- Recent milestones
- Categories
- First words
- Suggested templates

## 14.2 Milestone Categories

Grid:
- Movement
- Speech
- Social
- Self-care
- Learning
- Custom

## 14.3 Milestone List

Cards with title, date, age, thumbnail.

## 14.4 Milestone Detail

Show title, category, date, age, story, location, people present, photos.

## 14.5 Add/Edit Milestone

Use full milestone form.

## 14.6 Date Precision Selector

Options:
- Exact date
- Month only
- Year only
- Approximate
- Unknown

## 14.7 First Words List

Cards with word, date, age, language, story excerpt.

## 14.8 First Word Detail

Large quoted word plus date, age, language, story, audio.

## 14.9 Add/Edit First Word

Use first-word form.

---

# 15. J. School

## 15.1 School Overview

Show:
- Current school
- Current class
- Teacher
- Recent event

Sections:
- School history
- Events
- Report cards/certificates

## 15.2 School Profiles

Current and previous schools.

## 15.3 Add School

Fields:
- School name
- Start date
- End date
- Class
- Teacher
- Notes

## 15.4 Edit School

Same form.

## 15.5 School Events List

Filter by event type.

## 15.6 School Event Detail

Show date, title, story, attachments.

## 15.7 Add/Edit School Event

Full form.

## 15.8 Report Card / Certificate Viewer

Document preview with Share, Replace, Delete Attachment, Open Externally.

---

# 16. K. Health

## 16.1 Health Overview

Quick health:
- Blood group
- Allergies
- Active medicine

Recent:
- Latest illness
- Latest doctor visit

Upcoming:
- Vaccine
- Follow-up

Grid:
- Vaccinations
- Illness History
- Medicines
- Doctor Visits
- Documents
- Allergies

Show unobtrusive medical disclaimer.

## 16.2 Vaccination List

Tabs:
- Upcoming
- Completed
- All

## 16.3 Vaccination Detail

Show all fields and actions Edit / Add Reminder / View Attachment / Delete.

## 16.4 Add/Edit Vaccination

Structured form with context-sensitive scheduled/given date emphasis.

## 16.5 Illness History

Grouped by year.

## 16.6 Illness Detail

Sections:
- Symptoms
- Diagnosis
- Temperature
- Doctor
- Medicines
- Tests
- Notes
- Attachments

## 16.7 Add/Edit Illness

Full form.

## 16.8 Symptom Selector

Search + common symptom chips + custom symptom.

## 16.9 Medicine List

Tabs:
- Active
- Completed
- As needed
- All

## 16.10 Medicine Detail

Show dose, frequency, reason, prescriber, linked illness, reminder schedule.

## 16.11 Add/Edit Medicine

Structured form.

## 16.12 Medicine Schedule

Fields:
- Time
- Days
- Start/end
- Notification

## 16.13 Doctor Visits List

Cards:
- Doctor
- Date
- Specialty
- Reason

## 16.14 Doctor Visit Detail

Sections:
- Visit info
- Symptoms
- Diagnosis
- Tests
- Prescription
- Follow-up

## 16.15 Add/Edit Doctor Visit

Full form.

## 16.16 Medical Documents

Filter chips:
- Prescription
- Test report
- Vaccination card
- Certificate
- Other

## 16.17 Medical Document Detail

Preview + metadata.

## 16.18 Add Medical Document

Fields:
- Type
- Title
- Date
- Related illness
- Related visit
- File
- Notes

## 16.19 Health Summary

Sections:
- Child identity
- Blood group
- Allergies
- Active medicines
- Recent health events
- Latest height/weight
- Vaccination overview

CTA: Export PDF

## 16.20 Allergies List

Cards with allergen, type, reaction, severity.

## 16.21 Add/Edit Allergy

Fields:
- Allergen
- Type
- Reaction
- Severity
- First observed
- Doctor confirmed
- Notes

---

# 17. L. Achievements & Funny Moments

## 17.1 Achievements List

Filters:
- School
- Sports
- Art
- Reading
- Custom

## 17.2 Achievement Detail

Hero photo plus title, date, age, category, story, certificate.

## 17.3 Add/Edit Achievement

Full form.

## 17.4 Funny Moments List

Quote-first cards where possible.

## 17.5 Funny Moment Detail

Large quote block, story, date, age, photo.

## 17.6 Add/Edit Funny Moment

Full form.

## 17.7 Quote Card Preview

Options:
- Theme
- Include child photo
- Include age
- Include date

Actions:
- Save Image
- Share

---

# 18. M. Photos & Media

## 18.1 Photos Home

Tabs:
- All
- Favorites
- By Year
- By Age

## 18.2 Photo Grid

Three-column lazy-loaded grid.

Badges:
- Favorite
- Video
- Linked milestone

## 18.3 Photo Detail

Full-screen photo with metadata panel.

Actions:
- Favorite
- Edit metadata
- Share
- Delete

## 18.4 Media Picker

Sources:
- Camera
- Photos
- Files

Preview selected items before confirm.

## 18.5 Photo Metadata

Fields:
- Caption
- Date
- Location
- Tags
- Favorite
- Link to milestone/event

## 18.6 Favorite Photos

Dedicated album-selection view.

## 18.7 Media Missing State

Message:
`This photo or file is no longer available.`

Actions:
- Locate File
- Remove Reference
- Cancel

---

# 19. N. Birthdays & Favorites

## 19.1 Birthday Timeline

Cards per age with cover photo, theme, favorite quote.

## 19.2 Birthday Detail

Sections:
- Photos
- Favorite gift
- Guests
- Parent message
- Annual interview

## 19.3 Add/Edit Birthday

Fields:
- Age
- Date
- Location
- Theme
- Favorite gift
- Notes
- Photos

## 19.4 Birthday Interview

Questions:
- Favorite food?
- Favorite color?
- Best friend?
- What do you want to be?
- What makes you happy?

## 19.5 Favorites Overview

Cards by category with current and historical values.

## 19.6 Add/Edit Favorite

Fields:
- Category
- Value
- Start date
- End date optional
- Note

---

# 20. O. Interests

## 20.1 Interests List

Cards with first noticed, interest level, latest note.

## 20.2 Interest Detail

Show history and photos.

## 20.3 Add/Edit Interest

Fields:
- Name
- First noticed
- Interest level
- Notes
- Photos

---

# 21. P. Albums

## 21.1 Albums Home

Sections:
- Year in Review
- Birthdays
- Custom Albums
- Recent Exports

## 21.2 Album Detail

Cover header and item grid/list.

Actions:
- Edit
- Reorder
- Preview
- Export

## 21.3 Create Album

Fields:
- Title
- Date range
- Cover
- Theme

## 21.4 Edit Album

Same plus delete album.

## 21.5 Add Items to Album

Tabs:
- Photos
- Milestones
- Achievements
- Funny moments
- Journal
- School

## 21.6 Reorder Album Items

Drag and drop.

## 21.7 Album Theme Picker

Themes:
- Minimal
- Playful
- Colorful
- Elegant

## 21.8 Album Cover Picker

Options:
- Existing photo
- Theme cover
- Custom title

---

# 22. Q. Year in Review

## 22.1 Year in Review Home

Hero:
`Create a beautiful story of your child's year.`

List available years/ages.

CTA: Create New Review

## 22.2 Select Year / Age

Options:
- Calendar year
- Age year

Show expected item count.

## 22.3 Review Highlights

Sections:
- Growth
- Milestones
- School
- Achievements
- Funny moments
- Photos
- Birthday
- Family memories
- Health optional

Each section:
- Include toggle
- Item count
- Edit

## 22.4 Review Section Editor

Actions:
- Add
- Remove
- Reorder
- Edit caption

## 22.5 Parent Letter

Large editor with prompt:
`Write something you want your child to read one day.`

Autosave draft.

## 22.6 Review Cover Editor

Fields:
- Cover photo
- Title
- Subtitle
- Date range

## 22.7 Review Theme

Theme cards with preview.

## 22.8 Review Preview

Scrollable page preview.

CTA: Generate PDF

## 22.9 Generate PDF

Settings:
- Language
- Theme
- Page size
- Include health?
- Photo quality

## 22.10 PDF Generation Progress

Steps:
1. Preparing memories
2. Processing photos
3. Building pages
4. Saving PDF

## 22.11 PDF Ready

Show:
- File name
- Size
- Page count

Actions:
- View PDF
- Share
- Save
- Create Images

## 22.12 PDF Viewer

Native-style viewer with title, share, page number.

## 22.13 Export / Share Sheet

Options:
- PDF
- Page images
- Share
- Print
- Save to Files

---

# 23. R. Search

## 23.1 Global Search

Search across:
- Memories
- Health
- School
- Medicine
- Doctor
- Photos

## 23.2 Search Filters

Fields:
- Child
- Category
- Date range
- Tags
- Has attachment
- Favorites

## 23.3 Search Results

Grouped or chronological.

Each result:
- Icon
- Title
- Matched snippet
- Date

## 23.4 Search Result Preview

Bottom sheet or detail preview with Open Full Record.

---

# 24. S. Calendar & Reminders

## 24.1 Calendar

Monthly view with category indicators.

## 24.2 Day Detail

Show all events for selected date.

## 24.3 Reminders List

Sections:
- Today
- Upcoming
- Later

## 24.4 Add/Edit Reminder

Fields:
- Title
- Type
- Date/time
- Repeat
- Notification
- Linked record

## 24.5 Reminder Detail

Show time, linked item, repeat, notification status.

## 24.6 Notification Permission Explanation

Title:
`Turn on reminders?`

Text:
`Shishur Dinlipi can remind you about vaccinations, medicines, follow-up visits and important memories.`

Actions:
- Allow Notifications
- Not Now

---

# 25. T. Backup & Restore

## 25.1 Backup & Restore Home

Sections:
- Last backup
- Create Backup
- Restore from file
- Future cloud providers

Info:
`Backups can contain private child and health information.`

## 25.2 Create Backup

Summary:
- Children
- Entries
- Photos
- Estimated size

Option:
- Include media

## 25.3 Backup Password

Fields:
- Password
- Confirm password

Warning:
`You may need this password to restore on another device.`

## 25.4 Backup Progress

Steps:
- Preparing database
- Collecting media
- Encrypting
- Finalizing

## 25.5 Backup Complete

Show file name, size, date.

Actions:
- Save
- Share
- Done

## 25.6 Restore File Picker

Select local backup file.

## 25.7 Restore Password

Enter password.

## 25.8 Restore Summary

Show:
- Backup date
- App version
- Child count
- Media count
- Size

## 25.9 Restore Confirmation

Warn that local data may be replaced.

Option: Create safety backup first.

## 25.10 Restore Progress

Steps:
- Verifying
- Restoring database
- Restoring media
- Rebuilding search
- Restoring reminders

## 25.11 Restore Complete

Show restored children, records, media.

## 25.12 Corrupt Backup

Message:
`This backup could not be verified.`

Actions:
- Choose Another File
- View Details

## 25.13 Backup History

Rows:
- Date
- Size
- Location
- Status

---

# 26. U. Settings

## 26.1 Settings Home

Sections:
- General
- Language
- Appearance
- Units
- Notifications
- Memory Prompts
- Privacy & Security
- Backup & Restore
- Storage
- Export
- About

## 26.2 General Settings

Options:
- Default child
- Date format
- Bengali digits
- Start week on

## 26.3 Language Settings

Radio:
- English
- বাংলা

## 26.4 Appearance Settings

Options:
- Light
- Dark
- System
- Optional child accent color

## 26.5 Unit Settings

Height:
- cm
- ft/in

Weight:
- kg
- lb

Temperature:
- °C
- °F

## 26.6 Notification Settings

Toggles:
- Vaccination
- Medicine
- Doctor follow-up
- Birthday
- Memory prompts
- Backup reminder

## 26.7 Memory Prompt Settings

Options:
- Daily
- Weekly
- Off

Prompt types:
- Funny
- Learning
- Proud
- Photo

## 26.8 Privacy & Security

Items:
- App Lock
- PIN
- Biometrics
- Auto-lock
- Screenshot protection
- Background privacy

## 26.9 App Lock Settings

Toggle plus Set PIN flow.

## 26.10 Auto Lock Settings

Options:
- Immediately
- 1 minute
- 5 minutes
- 15 minutes
- Never

## 26.11 Backup Settings

Options:
- Backup reminder
- Include media by default
- Preferred export location
- Future cloud providers

## 26.12 Export Settings

Defaults:
- PDF language
- Theme
- Image quality
- Page size

## 26.13 Storage Settings

Show:
- Database size
- Photos
- Documents
- Generated PDFs
- Backups
- Temporary files

Actions:
- Clear temp
- Remove old exports
- Review large files

## 26.14 About

Show:
- App name
- Version
- Build
- Privacy
- Terms
- Licenses

## 26.15 Privacy Information

Explain local-first behavior, exports, optional cloud, and sensitive data handling.

## 26.16 Medical Disclaimer

Display full bilingual disclaimer.

---

# 27. V. Common Components & States

## 27.1 Initial Loading

Use logo + subtle progress. Never show private cached data before unlock.

## 27.2 Skeleton Loading

Skeletons should mirror actual content layout.

## 27.3 Empty State

Pattern:
- Simple illustration/icon
- Clear title
- One sentence
- Primary action

English:
`No memories yet`
`Add your first memory and begin your child's story.`

বাংলা:
`এখনো কোনো স্মৃতি যোগ করা হয়নি`
`প্রথম স্মৃতিটি যোগ করে আপনার শিশুর গল্প শুরু করুন।`

## 27.4 No Search Results

Show query plus:
- Clear filters
- Try another search

## 27.5 Save in Progress

Use inline progress and prevent duplicate submit.

## 27.6 Save Success

Snackbar/banner:
`Memory saved.` / `স্মৃতি সংরক্ষণ হয়েছে।`

## 27.7 Save Failed

Preserve entered data.

Actions:
- Retry
- Cancel

## 27.8 Delete Confirmation

Destructive action clearly separated.

## 27.9 Delete Failed

Keep original item intact.

## 27.10 Unsaved Changes

Dialog:
`Discard unsaved changes?`

Actions:
- Keep Editing
- Discard

## 27.11 Permission Denied

Explain why permission is needed.

Actions:
- Open Settings
- Cancel

## 27.12 Camera Permission Denied

Copy:
`Camera access is needed only when you choose to take a photo.`

## 27.13 Photo Permission Denied

Prefer modern system photo picker where possible.

## 27.14 Notification Permission Denied

Actions:
- Continue without reminders
- Open Settings

## 27.15 Storage Almost Full

Show estimated remaining space and Storage Manager shortcut.

## 27.16 Database Migration

Text:
`Updating your journal...`
`Your memories are being prepared for the latest version.`

## 27.17 Backup Failed

Actions:
- Retry
- Save elsewhere

## 27.18 Restore Failed

Explain current data remains safe if rollback succeeded.

## 27.19 PDF Generation Failed

Actions:
- Retry
- Reduce photo quality
- Review storage

## 27.20 Generic Error

`Something went wrong.`

Actions:
- Retry
- Go Back

## 27.21 Date Picker

Support exact date, Today shortcut, localized month names.

## 27.22 Month/Year Picker

Used for approximate dates, timeline jump, review selection.

## 27.23 Child Selector Sheet

Reusable compact list.

## 27.24 Search & Filter Sheet

Reusable grouped filters with Clear / Apply.

## 27.25 Confirmation Bottom Sheet

Use for medium-risk actions.

## 27.26 Attachment Picker

Options:
- Camera
- Photos
- Files

## 27.27 Attachment Preview

Show:
- Thumbnail
- File name
- Type
- Remove

## 27.28 Full-screen Image Viewer

Support pinch zoom, swipe, close, optional share.

---

# 28. Form Design Rules

- Group related fields.
- Mark optional fields clearly.
- Avoid more than 6–8 fields per visual block.
- Use appropriate keyboards.
- Preserve unsaved data after recoverable errors.
- Use sticky bottom CTA for long forms.

---

# 29. Validation Rules

Prefer inline validation.

Examples:
- `Child name is required.`
- `Date of birth cannot be in the future.`
- `Weight must be greater than 0.`

Use concise natural Bengali translations.

---

# 30. Attachment Rules

Allow:
- Preview
- Reorder
- Remove
- Caption where relevant

If media is reused elsewhere, clarify whether user is removing only the link or deleting the source file.

---

# 31. Privacy-Sensitive UI Rules

Never show by default:
- Child name in lock-screen notification
- Medical diagnosis in notification preview
- Cached private details before unlock
- Sensitive app-switcher snapshots when privacy mode is enabled

---

# 32. Bilingual Copy Rules

Use natural language rather than literal translation.

| English | বাংলা |
|---|---|
| Add Memory | স্মৃতি যোগ করুন |
| Growth | বৃদ্ধি |
| First Word | প্রথম কথা |
| First Step | প্রথম পদক্ষেপ |
| Doctor Visit | ডাক্তার দেখানো |
| Health Summary | স্বাস্থ্য সারাংশ |
| Year in Review | বছরের স্মৃতিচারণ |
| Funny Moments | মজার মুহূর্ত |
| Achievements | অর্জন |
| Backup & Restore | ব্যাকআপ ও পুনরুদ্ধার |

User-generated content should remain unchanged.

---

# 33. Bengali UX Considerations

- Avoid overly formal Bengali.
- Keep button text short.
- Use generous line height.
- Avoid truncating Bengali conjuncts.
- Test Bengali numerals.
- Allow English school, medicine, and doctor names inside Bengali UI.

---

# 34. Responsive Behavior

For larger phones, keep a comfortable max content width.

For tablets later, consider master/detail for:
- Timeline
- Health
- Albums
- Settings

---

# 35. Accessibility Requirements

Every screen should support:
- Screen readers
- Dynamic font sizing
- Logical focus order
- Minimum touch targets
- Non-color status cues
- Accessible image labels

---

# 36. Animation Guidance

Use subtle animations:
- Card fade
- Expand/collapse
- Success check
- Album page transition

Avoid excessive bouncing, confetti for routine actions, and long blocking transitions.

---

# 37. Recommended High-Fidelity Design Order

## Phase 1
1. Splash
2. Language
3. Onboarding
4. Home
5. Bottom navigation
6. Child profile
7. Quick Add
8. Timeline

## Phase 2
9. Journal
10. Growth
11. Milestones
12. School

## Phase 3
13. Health
14. Photos
15. Achievements
16. Funny moments

## Phase 4
17. Albums
18. Year in Review
19. PDF flow

## Phase 5
20. Backup
21. Security
22. Settings
23. Common states

---

# 38. MVP Screen Priority

## P0 — Essential
Splash, Language, Onboarding, Child Profile, Home, Timeline, Add, Journal, Growth, Milestones, School, Vaccinations, Illness, Medicines, Doctor Visits, Photos, Achievements, Funny Moments, Albums, Year in Review, PDF, Settings, Backup, App Lock.

## P1 — Important
Calendar, Search, Allergies, Health Summary, Favorites, Birthdays, Quote Cards.

## P2 — Advanced
Interests, advanced custom albums, cloud backup, OCR, AI-assisted review.

---

# 39. Final UX Principle

The user should never feel like they are filling out a complicated database.

Every interaction should support one of three parent goals:

1. **Remember this moment.**
2. **Keep this important record safe.**
3. **Look back at my child's story.**

The signature experience is:

> **“Azwad — Age 5: Year in Review”**

The UI should make that experience effortless, private, and worth returning to year after year.
