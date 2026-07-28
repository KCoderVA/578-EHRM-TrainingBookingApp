# Power Apps (Canvas): EHRM Training & Booking App (Station #578)

**Canvas app version**: v0.3.4 (2026-07-09)
**App package**: `.msapp/v0.3.4_578EHRMTrainingApp.msapp`

## Provenance / credits (v0.0.1 baseline)

- The initial `.msapp` used as the starting point for this project (v0.0.1) was shared by **Hiram A. Zayas** (Hiram.Zayas@va.gov), Health Informatics Service, Battle Creek VA Medical Center.
- The connected SharePoint list sample data (sanitized) is stored locally under `src/sharePoint/`.

---

## What changed in v0.3.4 (current)

This release represents the most substantial functional overhaul of the Canvas app since the original baseline. Changes span seven core areas: role-based access control, intelligent scheduling, appointment management, reservation detail enhancements, calendar screen modernization, connector/API updates, and app-level version tracking.

### 1. Role-Based Access Control System (Dashboard)

The `Dashboard` screen's `OnVisible` formula was completely refactored from a simple binary admin/non-admin check into a full multi-tier role-based access control (RBAC) system driven by the `DeskAccessControl` SharePoint list's `AccessLevel_Text` column.

**Access levels and menu behavior:**

| Access Level      | Menu Shown                                    |
| ----------------- | --------------------------------------------- |
| `SuperUser`     | Full menu — all screens accessible           |
| `AppAdmin`      | Full menu — all screens accessible           |
| `Manager`       | Full menu — all screens accessible           |
| `ServiceChief`  | Full menu — all screens accessible           |
| `ProjectLeader` | Full menu — all screens accessible           |
| `User`          | Reduced menu — booking and self-service only |
| `View-only`     | Minimal menu — calendar/viewer screens only  |
| `AccessDenied`  | Empty menu — app effectively locked out      |

Upon `OnVisible`, the app now executes the following sequence:

1. Calls `Refresh(DeskAccessControl)` to ensure the latest permissions are loaded from SharePoint before any evaluation.
2. Clears and repopulates a `userAccessDemographics` collection with the current user's row.
3. Reads `AccessLevel_Text` into the `userAccessLevel_text` variable.
4. Conditionally builds `colMenu` based on the resolved access level — elevated roles get the full set, `User` gets a reduced set, `View-only` gets an even more restricted set, and `AccessDenied` results in a blank collection.

Previously, `isUserAdminSPList` was set by a single `LookUp` with no null-handling or role tiers. Now it is initialized to `false` first and then conditionally evaluated, eliminating race conditions with partially loaded SharePoint data.

**Additional Dashboard UI changes:**

- **`gallMyReservationsPreview` filter**: Simplified from `'Reserved By'.Email = currentUser.Email OR 'Created By'.Email = currentUser.Email` to only `'Reserved By'.Email = currentUser.Email`. Reservations now show only where the current user is the explicit "Reserved By" party, removing ambiguity for proxy-created bookings.
- **`Button5` (calendar navigation)**: Label changed from "Click to see calendar" → **"View calendars!"**. Dimensions updated (Height 94→37, Width 240→333, Y repositioned to 591).
- **`Label6` (reason display)**: Height increased (26→94px), `Overflow = Scroll`, `VerticalAlign = Top` — now supports multi-line reason text with a scrollable area.
- **Dashboard version display**: App displays the internal version number (tracked via `varGetRepo_ProjectVersion`) in the top-left corner of the Dashboard for quick operator reference.

---

### 2. Intelligent Scheduling Defaults & Enhanced Booking Logic (chkWeekDays)

The `chkWeekDays` (Select Date/Time) screen received its most significant update to date.

**Smart default start time (OnVisible):**

The `OnVisible` formula now auto-calculates and injects a default start time rounded **up** to the nearest 15-minute boundary from the current clock time:

```powerfx
UpdateContext({
    varDefaultTime: With(
        {
            CorrectedHour: Hour(DateAdd(Now(),
                RoundUp(Minute(Now())/15,0)*15 - Minute(Now()),
                TimeUnit.Minutes)),
            CorrectedMinute: Mod(RoundUp(Minute(Now()) / 15, 0) * 15, 60)
        },
        Time(CorrectedHour, CorrectedMinute, 0)
    )
});
```

Practical effect: opening the booking screen at 9:07 AM pre-selects 9:15 AM; opening at 9:16 AM pre-selects 9:30 AM.

**Continue button (`ContinueDatebtn`) enhancements:**

- **Automatic 1-hour duration**: `varEventEndTime` is calculated as start time + 60 minutes, pre-populating the End Time field.
- **Importance level**: `varImportance` captured from `ddImportance` dropdown using `Lower()` for normalized casing.
- **Recurrence pattern**: `varRecurrence` set to `"weekly"` for "Every weekday" selection, or derived from `ddRecurrenceFrequency` dropdown for other options.
- **Reminder setting**: `varReminder` captured from `ddReminder` dropdown.
- **Weekday filtering**: When "Daily" + "Every weekday" is selected, Saturdays and Sundays are automatically excluded from the recurrence weekday collection using `Filter(Gallery6.AllItems, Value <> "Sunday" And Value <> "Saturday")`.
- **Conflict detection**: Before proceeding, the formula executes `ClearCollect(colBookedDesks, Filter('Desk Reservations', ...))` to surface existing bookings on the selected date in a "Existing reservations already booked on the selected date" section visible at the bottom of the screen.

**Calendar picker expansion**: `DaysAheadRestriction` increased from **180 days** to **230 days**, allowing scheduling further in advance.

**New scheduling UI controls:**

- **Importance dropdown** (`ddImportance`): Normal / High / Low
- **Reminder dropdown** (`ddReminder`): 15-minute intervals
- **Event Recurrence dropdown** (`ddRecurrenceFrequency`): None / Daily / Weekly
- **"Existing reservations" gallery**: Shows all conflicting bookings on the selected date in real time

---

### 3. Appointment List Enhancements (MyAppts / My Reservations)

**`gallPast` (Previous tab) — expanded filter logic:**

Past reservations now include items where `Active_choice` is blank or explicitly `"false"`, in addition to the existing date-based filter:

```powerfx
Filter(
    'Desk Reservations',
    ('Reserved By'.Email = currentUser.Email)
    && Or(
        'Check Out From' <= Today(),
        IsBlank(Active_choice.Value),
        Active_choice.Value = "false"
    )
)
```

This ensures deactivated/cancelled reservations appear in the Previous tab regardless of their date, giving a complete historical view of all non-active bookings.

**`gallUpcoming` (Upcoming tab) — new explicit action buttons:**

| Control                        | Color                          | Action                                                                                           |
| ------------------------------ | ------------------------------ | ------------------------------------------------------------------------------------------------ |
| `Button3_4` — "View This"   | Green`RGBA(152, 208, 70, 1)` | Sets`varSelectedReservation` → navigates to `Reservation` screen                            |
| `Button3_9` — "Cancel This" | Red`RGBA(184, 0, 0, 1)`      | Sets`varConfirmCancel` + `varReservationToCancel` context → shows cancellation confirmation |
| `Icon2_3` — OpenInNewWindow | Icon                           | Companion detail navigation to`Reservation` screen                                             |

The **"CANCEL"** button in the upcoming gallery row now triggers a **"Confirm Cancellation?"** dialog overlay (with NEVERMIND / CONFIRM buttons) before executing any destructive action, preventing accidental cancellations.

---

### 4. Reservation Details Screen Improvements (Reservation)

The `Reservation` screen received a comprehensive relabeling and field clarity pass:

| Control                      | Old Text                                           | New Text                                            |
| ---------------------------- | -------------------------------------------------- | --------------------------------------------------- |
| `lblMyAppointments_3`      | "Reservation"                                      | **"Reservation Details"**                     |
| `lblNameDesk_1`            | "EHRM Virtual Instructor Led Training (VILT) Room" | **"EHRM Training Description"**               |
| `lblNameDesk_1.FontWeight` | Semibold                                           | **Bold**                                      |
| `lblFloorDesk_1`           | *(floor label)*                                  | **"Location (Desk/Room/Building/Division):"** |
| `lblMapDesk_1`             | *(map label)*                                    | **"Start Date/Time"**                         |
| `lblDescrDesk_1`           | *(description label)*                            | **"Additional Comments/Notes:"**              |

A new back-navigation button (`btnBackDeskEdit_1`) was added labeled **"Cancel This Reservation"**, and the primary action button (`btnUpdate_1`) was also updated for clarity. The `Reservation` screen now clearly shows:

- Reserved On / Reserved By
- From / To date-time range
- Building/Room location
- Scrollable Description field

---

### 5. Booking Confirmation Flow (Confirm Screen)

`Container2` on the Confirm screen now uses a **6-column × 6-row layout grid** for better responsive positioning of confirmation details.

`Gallery3_1` template size was increased from 22px → **175px** to properly accommodate multi-line confirmation entries.

`TextCanvas7_4` now renders a combined multi-line summary:

```powerfx
="Selected Training: " & varMeetCat & Char(10) & "Selected Location: " & varSelectedDesk.CombinedLocationDetails_multilinePlainText
```

This gives the user a clear "everything look good?" summary showing both the training category selected and the full room/desk location before final submission.

---

### 6. Calendar Screens — Grid Layout Modernization

Three calendar-related screens were upgraded to Power Apps' modern **grid-based layout system**:

| Screen                      | Container Updated | Grid           |
| --------------------------- | ----------------- | -------------- |
| `scrn_WeeklyCal`          | `Container1`    | 6 col × 6 row |
| `scrn_MoCalendar`         | `Container7`    | 6 col × 6 row |
| `scrn_DailyCal` *(new)* | `Container1_1`  | 6 col × 6 row |

**`scrn_DailyCal` — New screen replacing `scrn_WeeklyCal_1`:**

The old `scrn_WeeklyCal_1` was removed and replaced by `scrn_DailyCal`. This new "Daily Calendar List" screen displays a filterable list of all training room reservations for the current day under the heading **"Daily Training Room List"**, with columns for ID#, Desk Reservation Info, and POC Comments. It is built on the modern container grid layout for responsive scaling.

All navigation references updated:

```powerfx
// OLD (scrn_MoCalendar "Daily" button):
OnSelect: =Navigate(scrn_WeeklyCal_1)

// NEW:
OnSelect: =Navigate(scrn_DailyCal)
```

The Monthly Calendar screen now shows **"Weekly"** and **"Daily"** toggle buttons. The Weekly Calendar shows **"Monthly"** and **"Daily"** toggles. All three calendar views are interconnected with consistent navigation.

---

### 7. App-Level Version Tracking (App.fx.yaml)

The `App.OnStart` formula — previously empty — now initializes a global project version variable at startup:

```powerfx
Set(
    varGetRepo_ProjectVersion,
    "0.3.4"
    // (commented placeholders for future GitHub API / Power Apps API dynamic version queries)
);
```

This variable is displayed in the top-left corner of the Dashboard screen for quick version identification by operators and support staff.

---

### 8. Connector & Platform Updates

**New O365 Users actions added:**

- `MyProfileV2` — retrieves the current user's full M365 profile
- `ManagerV2` — retrieves the current user's manager record
- `UserProfileV2` — retrieves any specified user's profile by UPN

**Legacy Outlook actions removed:**

- `V4CalendarGetItems` (deprecated)
- `CalendarGetTables_V2` (superseded)

**Connector icon CDN migration:**
All three connectors (Office 365 Outlook, Office 365 Users, SharePoint) now reference icon URLs on the US Government cloud CDN (`gov.static.powerapps.us`).

**Platform format version upgrade:**

| Property             | v0.0.2 (old) | v0.3.4 (new) |
| -------------------- | ------------ | ------------ |
| `FormatVersion`    | 0.24         | 0.30         |
| `DocVersion`       | 1.347        | 1.349        |
| `MinVersionToLoad` | 1.331        | 1.349        |
| `AppDescription`   | *(empty)*  | "v0.3.3"     |

**New `AppPreviewFlagsMap` flags enabled:**

| Flag                             | Old               | New            |
| -------------------------------- | ----------------- | -------------- |
| `commentgeneratedformulasv2`   | false             | **true** |
| `enablecreateaformula`         | false             | **true** |
| `enablesaveloadcleardataonweb` | false             | **true** |
| `disablem365copilot`           | *(not present)* | false          |
| `showm365copilot`              | *(not present)* | false          |

---

## Version history (component)

| Version          | Date                 | Summary                                                                                                                                                                                                                                                                                                                           |
| ---------------- | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **v0.3.4** | **2026-07-09** | **Role-based access control (8 tiers), smart scheduling defaults, conflict detection, cancellation confirmation dialog, Daily Calendar screen replacement (scrn_DailyCal), grid layout modernization, explicit action buttons on MyAppts, Reservation detail relabeling, app version variable, connector/platform updates** |
| v0.0.2           | 2026-01-02           | SharePoint binding fixes, screen behavior improvements (Dashboard, MyAppts, POCSUPERVISOR, chkWeekDays)                                                                                                                                                                                                                           |
| v0.0.1           | 2025-12-31           | Initial baseline shared starter app                                                                                                                                                                                                                                                                                               |

---

## Screenshots (v0.3.4)

Screenshots captured 2026-07-09 from the live v0.3.4 app. Stored under [`assets/screenshots/`](../../assets/screenshots/).

| Screen                                  | File                                    |
| --------------------------------------- | --------------------------------------- |
| Dashboard                               | `v0.3.4_screen1_Dashboard.png`        |
| POCSUPERVISOR (Create Reservation)      | `v0.3.4_screen2_POCSUPERVISOR.png`    |
| chkWeekDays (Select Date/Time)          | `v0.3.4_screen3_chkWeekDays.png`      |
| DeskSelect (Select a Location)          | `v0.3.4_screen4_DeskSelect.png`       |
| Confirm (Room Terms & Conditions)       | `v0.3.4_screen5a_Confirm.png`         |
| Confirm (Setup/Cleanup Acknowledgement) | `v0.3.4_screen5b_Confirm.png`         |
| Confirm (Everything look good?)         | `v0.3.4_screen5c_Confirm.png`         |
| Success                                 | `v0.3.4_screen6_Success.png`          |
| MyAppts / My Reservations               | `v0.3.4_screen7a_MyAppts.png`         |
| MyAppts — Cancellation dialog          | `v0.3.4_screen7b_MyAppts.png`         |
| ManageDesks — Active list              | `v0.3.4_screen8a_ManageDesks.png`     |
| ManageDesks — Inactive list            | `v0.3.4_screen8b_ManageDesks.png`     |
| NewEditDesk (Edit Desk form)            | `v0.3.4_screen9_NewEditDesk.png`      |
| Reservation Details                     | `v0.3.4_screen10_Reservation.png`     |
| Release Notes (in-app)                  | `v0.3.4_screen11_ReleaseNotes.png`    |
| scrn_WeeklyCal (Weekly Calendar)        | `v0.3.4_screen12_scrn_WeeklyCal.png`  |
| scrn_DailyCal (Daily Calendar List)     | `v0.3.4_screen13_scrn_DailyCal.png`   |
| scrn_MoCalendar (Monthly Calendar)      | `v0.3.4_screen13_scrn_MoCalendar.png` |
| NewDesk (Add New Desk form)             | `v0.3.4_screen14_NewDesk.png`         |

---

## 1. App Overview

- **App Type**: Phone layout (landscape orientation)
- **Connectors**: Office 365 Outlook, Office 365 Users, SharePoint
- **Data Sources**:
  - **SharePoint**: Desk Reservations, DeskAccessControl, Desks
  - **Office 365 Outlook**: CalendarGetTables, V3CalendarPostItem, V2CalendarPostItem, FindMeetingTimes, GetRoomLists, GetRooms, GetRoomsInRoomList
  - **Office 365 Users**: SearchUser, MyProfileV2, ManagerV2, UserProfileV2

## 2. Screens (v0.3.4 — 21 screens)

| #  | Screen Name         | Purpose                                                                                                        |
| -- | ------------------- | -------------------------------------------------------------------------------------------------------------- |
| 1  | `Dashboard`       | Welcome, upcoming reservations preview, role-based menu                                                        |
| 2  | `MyAppts`         | My Reservations — Upcoming / Previous tabs with CANCEL action                                                 |
| 3  | `POCSUPERVISOR`   | Create a new reservation — employee, supervisor, training type selection                                      |
| 4  | `chkWeekDays`     | Select Date(s)/Time — calendar, time pickers, recurrence, conflict checker                                    |
| 5  | `DeskSelect`      | Select a Location — filterable room/desk picker with feature indicators                                       |
| 6  | `Confirm`         | Multi-step confirmation flow (Terms → Acknowledgement → Review)                                              |
| 7  | `Success`         | Booking confirmed — "You're booked!"                                                                          |
| 8  | `ManageDesks`     | Admin: Active/Inactive desk list with DELETE/EDIT/DEACTIVATE actions                                           |
| 9  | `NewDesk`         | Admin: Add a new desk/room record                                                                              |
| 10 | `NewEditDesk`     | Admin: Edit an existing desk/room record                                                                       |
| 11 | `Reservation`     | Reservation Details view for a selected booking                                                                |
| 12 | `SuccessDeskMod`  | Desk modification success confirmation                                                                         |
| 13 | `ReleaseNotes`    | In-app release notes (new features and bug fixes)                                                              |
| 14 | `Screen3`         | *(utility screen)*                                                                                           |
| 15 | `scrn_MoCalendar` | Monthly Calendar — full month grid view with booking entries                                                  |
| 16 | `scrn_WeeklyCal`  | Weekly Calendar — 7-day grid with booking entries                                                             |
| 17 | `scrn_DailyCal`   | **NEW** Daily Calendar List — daily training room reservation list view *(replaces scrn_WeeklyCal_1)* |
| 18 | `DebuggingScreen` | Developer debugging utilities                                                                                  |
| 19 | `Screen1`         | *(utility screen)*                                                                                           |
| 20 | `PDFScreen`       | PDF export/preview                                                                                             |
| 21 | `Screen2`         | *(utility screen)*                                                                                           |

> **Note**: `scrn_WeeklyCal_1` was removed and replaced by `scrn_DailyCal` in v0.3.4.

## 3. ALM workflow (pack/unpack)

Use the VS Code tasks in this repo, or run Power Platform CLI directly:

- **Unpack**: `pac canvas unpack --msapp "<path-to-msapp>" --source "<path-to-unpacked>" --force`
- **Pack**: `pac canvas pack --msapp "<path-to-msapp>" --sources "<path-to-unpacked>"`

VS Code tasks are preconfigured in [`.vscode/tasks.json`](../../.vscode/tasks.json).
