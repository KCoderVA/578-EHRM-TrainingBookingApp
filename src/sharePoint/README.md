# SharePoint — Lists, Libraries & Reference Data

This folder documents the SharePoint back-end for the EHRM Training & Booking App. The solution spans
**two SharePoint environments**:

1. **The app's own lists** (read/write) on
   `…/sites/HinesInformatics&AdvancedAnalytics/578_EHRM_TrainingApp` — where the canvas app and the flows
   store bookings, access control, and inventory.
2. **National EHRM reference data** (read-only) on `…/sites/vacoehrmioeue/Sandbox` — the program's
   "Sandbox Resource Center" lists and the **Learning Labs Library**, which supply the scenario / role /
   session / service-line reference data surfaced in the app's pickers and the Power BI reports.

> **Current release:** `v1.0.12`. See [`v1.0.12_differenceAnalysis.md`](v1.0.12_differenceAnalysis.md).

## Structure (current — reorganized at v1.0.12)

```
src/sharePoint/
├── list/
│   ├── deskAccessControl/local/          — app list: RBAC (git-ignored data)
│   ├── deskReservations/local/           — app list: booking records
│   ├── desks/local/                       — app list: bookable asset inventory
│   ├── masterScheduleList/local/          — app list: master schedule (replaces old schedule/)
│   ├── superUserList/local/               — app list: Super User roster
│   ├── backupList_DeskReservations/local/ — app list: email-sourced backup reservations
│   └── nationalEHRM/sandbox/              — national reference lists (see table)
│       ├── ehrmRoles/                     — *.url shortcut (tracked) + local/ CSV+IQY
│       ├── ehrmScenarios/
│       ├── ehrmServiceLines/
│       ├── learningLabLibrary/
│       ├── learningLabSessions/
│       ├── learningLabSignups/
│       └── scenarioWorkflows/
├── library/nationalEHRM/sandbox/learningLabLibrary/local/  — document-library export (git-ignored)
├── events/nationalEHRM/sandbox/calendarInvites/local/      — calendar-invite export (git-ignored)
└── searchConfig/                          — (SharePoint search config export)
```

Everything under a `local/` subfolder is **git-ignored by design** (by extension — `.csv`/`.xlsx`/`.iqy`/
`.zip` — and by folder name). The only **tracked/public** files in this component are this README, the
per-list `*.url` view shortcuts, and (when present) `searchConfig/SearchConfiguration.xml`.

## The app's own lists (read/write) — site `578_EHRM_TrainingApp`

| List | Folder | Role |
|---|---|---|
| `DeskAccessControl` | `list/deskAccessControl/` | Drives canvas-app RBAC (`AccessLevel_Text` / `AccessLevel_Choice`); enriched by the `AppUserList` flow. |
| `Desk Reservations` | `list/deskReservations/` | Primary booking/registration records (submitter/student/reservation/trainer/reminder families). |
| `Desks` | `list/desks/` | Bookable asset inventory (Desk/Room/Floor/Building; typed columns). |
| `MasterScheduleList` | `list/masterScheduleList/` | Master training schedule (replaces the former `schedule/` folder). |
| `SuperUserList` | `list/superUserList/` | Super User roster; bulk-synced into `DeskAccessControl` by the app. |
| `backupList_DeskReservations` | `list/backupList_DeskReservations/` | Redundant reservation records written by the `CreateBackups` flow from confirmation emails. |

## National EHRM reference lists (read-only) — site `vacoehrmioeue/Sandbox`

Each folder holds a tracked `*.url` shortcut to the live list view plus a git-ignored `local/` CSV/IQY
snapshot of its schema + data.

| List | Folder | SharePoint list |
|---|---|---|
| EHRM Roles | `nationalEHRM/sandbox/ehrmRoles/` | `Lists/EHRM Roles` |
| Scenario | `nationalEHRM/sandbox/ehrmScenarios/` | `Lists/Scenario` |
| Service Line (Sandbox) | `nationalEHRM/sandbox/ehrmServiceLines/` | `Lists/SPserviceLine` |
| Learning Lab Sessions | `nationalEHRM/sandbox/learningLabSessions/` | `Lists/Learning Lab Sessions` |
| Learning Lab Signups | `nationalEHRM/sandbox/learningLabSignups/` | `Lists/Learning Lab Signups` (filtered `Facility = Hines`) |
| Scenario Workflows | `nationalEHRM/sandbox/scenarioWorkflows/` | `Lists/Scenario  Workflows` |
| Learning Labs **Library** | `library/…/learningLabLibrary/` | Document library (read-only; class/scenario materials) |

## Recreating the lists in your environment
The `local/` CSV exports embed the full SharePoint `ListSchema` (`schemaXmlList` field definitions) — use
them as the column reference to recreate each list in your own site, then re-point the canvas app and flow
data sources to your GUIDs. The `*.url` shortcuts show the source list views on the national tenant.

## Note on environment-specific values
`*.url` shortcuts and any `searchConfig` export contain VA site URLs and view GUIDs; the `local/` exports
may contain real VA scheduling/roster data. Review/sanitize per [`.github/SECURITY.md`](../../.github/SECURITY.md)
before publishing broadly. **Never** commit `local/` data.
