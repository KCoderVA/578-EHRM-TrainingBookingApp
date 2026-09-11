# Power Apps — Canvas App (`578-EHRM-Training-App`)

The **578 EHRM Training App** is a responsive, mobile-first Power Apps **canvas app** that lets
staff at a VA hospital self-register (or be registered by a POC/supervisor) for **EHRM "Learning Lab"
training sessions** and reserve the physical/virtual desks used to run them. It is the primary
user-facing component of this solution and orchestrates the SharePoint lists, Power Automate flows, and
Power BI reporting documented elsewhere in this repository.

> **Current release:** `v1.1.20` (public) — see the `v1.0.12 → v1.1.20` analysis set:
> [`v1.1.20_diffAnalysis.md`](v1.1.20_diffAnalysis.md) (technical),
> [`v1.1.20_changeSummary.md`](v1.1.20_changeSummary.md) (functional),
> [`v1.1.20_knownIssues.md`](v1.1.20_knownIssues.md), and
> [`v1.1.20_recommendations.md`](v1.1.20_recommendations.md). The prior
> [`v1.0.12_differenceAnalysis.md`](v1.0.12_differenceAnalysis.md) (`v0.12.2 → v1.0.12`) is retained as history.
> The packaged export lives in [`.msapp/`](.msapp/).
>
> ℹ️ **Version note:** the app is internally consistent at `v1.1.20` — `varRepoVersion`, manifest
> `AppDescription`, the `.zip` bundle, and the tracked `.msapp` package (`v1.1.20_578EHRMTrainingApp.msapp`)
> all read `1.1.20`.

---

## What it does

- **Role-based home dashboard** — the menu and available screens are built at `App.OnStart` from the
  signed-in user's access level (`AppAdmin`, `Manager`, `ServiceChief`, `ProjectLeader`, `SuperUser`,
  `User`, `View-Only`, `AccessDenied`).
- **Self-service & proxy registration** — a user can register themselves, or a POC/supervisor can
  register a student *on their behalf* (the app safely re-targets the SharePoint writes and Outlook
  invite to the selected student).
- **Class / scenario picker** — reads the national EHRM **Learning Labs Library** (read-only SharePoint
  document library) to present training scenarios, descriptions, and links to the source materials.
- **Recurrence engine** — books a series of sessions across selected weekdays, writing one
  `Desk Reservations` row per occurrence and grouping them with a shared recurrence ID.
- **Calendar views** — custom **day / week / month** calendars with drill-in to reservation detail and
  a printable PDF view.
- **Outlook integration** — posts a calendar invite (`Office365Outlook.V4CalendarPostItem`) and a
  confirmation email on booking commit.
- **Desk / asset management** — admins manage bookable Desks/Rooms/Floors/Buildings.
- **User & access management** — admins manage `DeskAccessControl` and bulk-sync Super Users.

---

## Architecture & dependencies

The canvas app talks to **two** SharePoint environments plus Microsoft 365 connectors:

| Dependency | Purpose | Access |
|---|---|---|
| SharePoint site `…/HinesInformatics&AdvancedAnalytics/578_EHRM_TrainingApp` | The app's own lists: `Desk Reservations`, `DeskAccessControl`, `Desks`, `MasterScheduleList`, `SuperUserList`, `backupList_DeskReservations` | Read/Write |
| SharePoint site `…/vacoehrmioeue/Sandbox` | National EHRM reference data — **`Learning Labs Library`** document library (scenario/class picker) and `Learning Lab Sessions` | Read-only |
| `Office365Users` connector | Signed-in identity, user profile, manager lookup, people search | Read |
| `Office365Outlook` connector | Calendar invite + confirmation email on booking | Write |
| Power BI (GOV cloud embed) | Embedded dashboard on the printable `Screen1` | Read |

> The canvas app does **not** call any Power Automate cloud flow directly. The companion flows in
> [`../powerAutomate/`](../powerAutomate/) run independently and are linked by data/email (for example,
> the `CreateBackups` flow triggers off the confirmation email this app sends).

See [`../sharePoint/README.md`](../sharePoint/README.md) for the list schemas and
[`../powerAutomate/README.md`](../powerAutomate/README.md) for the flows.

---

## Folder contents

```
src/powerApps/
├── .msapp/        — packaged canvas app (import this into Power Apps Studio)
├── .unpacked/     — pac-unpacked source; newer pac emits a dual layout:
│                     layoutDefault/    (classic .fx.yaml, DataSources, pkgs, CanvasManifest.json)
│                     layoutSourceCode/ (source-code layout + *.msapr bundle)
├── .zip/          — legacy/full export bundle (git-ignored *.zip)
├── .local/        — developer-only scratch (git-ignored): formula snapshots, proposed content, notes
├── README.md
├── v1.1.20_diffAnalysis.md        — technical diff (v1.0.12 → v1.1.20)
├── v1.1.20_changeSummary.md       — functional summary
├── v1.1.20_knownIssues.md         — bugs, risks, follow-ups
├── v1.1.20_recommendations.md     — roadmap for next versions
└── v1.0.12_differenceAnalysis.md  — prior cycle (v0.12.2 → v1.0.12), historical
```

Screen logic lives in `.unpacked/layoutDefault/Src/*.fx.yaml`; shared components (nav `Tabs`/`Tabs_3`,
`Calendar`, `Preloader`) in `.unpacked/layoutDefault/Src/Components/`; data-source bindings in
`.unpacked/layoutDefault/DataSources/`.

---

## Importing this app into your own VA hospital environment

1. **Prerequisites**
   - A Power Platform environment in the **US Gov (GCC High/DoD)** cloud with Power Apps + Power Automate.
   - SharePoint Online sites for the app's lists (recreate the schemas from
     [`../sharePoint/`](../sharePoint/)).
   - Connections for **SharePoint**, **Office 365 Users**, and **Office 365 Outlook**.
2. **Recreate the SharePoint lists** (`Desk Reservations`, `DeskAccessControl`, `Desks`,
   `MasterScheduleList`, `SuperUserList`, `backupList_DeskReservations`) using the column definitions in
   [`../sharePoint/`](../sharePoint/).
3. **Import the app** — in Power Apps Studio, *Apps → Import canvas app* and select the `.msapp` in
   [`.msapp/`](.msapp/) (or import the managed solution from [`../solution.xml`](../solution.xml)).
4. **Re-point the data sources** — update every SharePoint data source to *your* site collection and
   list GUIDs. Search `.unpacked/` for `dvagov.sharepoint.com/sites/…` and the tenant/environment GUIDs
   and replace them with your own (see the environment table in the root
   [`README.md`](../../README.md)).
5. **Set access levels** — add yourself to `DeskAccessControl` with `AccessLevel_Text = "AppAdmin"`, then
   manage other users from the in-app **Users** screen.
6. **Deploy the companion flows** from [`../powerAutomate/`](../powerAutomate/) and (optionally) the Power
   BI reports from [`../analytics/powerBI/`](../analytics/powerBI/).

> ⚠️ **Sanitize before reuse.** The unpacked source contains this hospital's site URLs, tenant/environment
> GUIDs, and some VA email addresses in developer comments. Replace all environment-specific values with
> your own before publishing or deploying.

---

## Role-based access (RBAC) summary

`App.OnStart` resolves the signed-in user against `DeskAccessControl`, defaulting **everyone with network
access to `User`** and self-provisioning a new access row (6-month window) when none exists. The
`colMenu` collection is then built with a `Switch(true, …)` so the navigation always renders even while
data loads.

| Role | Home | My Items | Manage Desks | Manage Users | Help | New (register) |
|---|:--:|:--:|:--:|:--:|:--:|:--:|
| `AppAdmin` / `Manager` / `ServiceChief` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `ProjectLeader` | ✅ | ✅ | ✅ | — | ✅ | ✅ |
| `User` / `SuperUser` | ✅ | ✅ | — | — | ✅ | ✅ |
| `View-Only` | ✅ | ✅ | — | — | ✅ | — |
| `AccessDenied` | ✅ | — | — | — | ✅ | — |

---

## Version history (component)

| Component version | Project release | Highlights |
|---|---|---|
| **v1.1.20** | v1.1.20 | Booking-commit refactor on `Confirm` (orchestrator + verification timer + both-lists fallback cascade); rebuilt Help screen (end-user Quick-Start guide + admin changelog); class picker re-pointed to Hines-scoped collections with new `sessionActive_text` active-session filter; `btnOutlook_*`/`btnPatch_*`/`timer_*` control renames. Follow-ups: `BindingErrorCount` `0 → 24` on the `Success` screen (KI-02, next patch); Teams connector is an intentional placeholder (KI-03) — see [`v1.1.20_knownIssues.md`](v1.1.20_knownIssues.md). |
| v1.0.12 | v1.0.12 | Removed impersonation backdoor; RBAC default-to-`User`; single-student proxy registration; Learning Labs Library picker; binding errors 120 → 0; removed dead `CreateMeeting`/`Screen3`. See [`v1.0.12_differenceAnalysis.md`](v1.0.12_differenceAnalysis.md). |

## License

Apache 2.0 — see the root [`LICENSE`](../../LICENSE). Author: Kyle J. Coder, Edward Hines Jr. VA Hospital
(VISN 12).
