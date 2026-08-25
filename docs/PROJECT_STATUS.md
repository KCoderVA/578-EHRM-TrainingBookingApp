# Project Status

This document describes the current public state of the EHRM Training & Booking App repository and what is included/excluded as of the latest release.

## Status summary (v1.0.12)

- **Release type (v1.0.12)**: Major / production go-live — the Canvas app advances **v0.12.2 → v1.0.12** (public). The app is live to ~100–150 hospital staff. Project version jumps `0.12.4 → 1.0.12` (the interim 0.12.4 was never shipped).
- **Highlights**: removed the hard-coded impersonation backdoor; RBAC hardened to default-to-`User`; single-student **proxy registration**; **Learning Labs Library** class/scenario picker; new **`CreateBackups`** flow + **Teams** reminders; national EHRM **Sandbox** reference lists; new **`SuperUserDashboard-Final`** Power BI report + **`tms/`** staging; binding errors `120 → 0`; two dead screens removed (`CreateMeeting`, `Screen3`).
- **Project release**: v1.0.12 (2026-08-25)
- **Component versions**:
  - Canvas app: **v1.0.12** (unpacked source under `src/powerApps/.unpacked/`; package at `src/powerApps/.msapp/v1.0.12_578EHRMTrainingApp.msapp`, tracked via `.gitignore` `!*.msapp`). See [src/powerApps/README.md](../src/powerApps/README.md) and [src/powerApps/v1.0.12_differenceAnalysis.md](../src/powerApps/v1.0.12_differenceAnalysis.md).
  - Power Automate: `AppUserList` (unchanged) + `SendReminders` (updated — email + Teams card) + **`CreateBackups`** *(new — email-triggered backup-reservation flow)*. See [src/powerAutomate/README.md](../src/powerAutomate/README.md) and [src/powerAutomate/v1.0.12_differenceAnalysis.md](../src/powerAutomate/v1.0.12_differenceAnalysis.md).
  - SharePoint: app lists + national EHRM **Sandbox** reference lists (`.url` shortcuts) + Learning Labs Library; `local/` data git-ignored. See [src/sharePoint/README.md](../src/sharePoint/README.md) and [src/sharePoint/v1.0.12_differenceAnalysis.md](../src/sharePoint/v1.0.12_differenceAnalysis.md).
  - Analytics: Power BI `Signup Tool` (`.pbit` tracked) + `SuperUserDashboard-Final` (WIP) + `tms/` staging. See [src/analytics/README.md](../src/analytics/README.md) and [src/analytics/v1.0.12_differenceAnalysis.md](../src/analytics/v1.0.12_differenceAnalysis.md).

## Release history

| Version | Date | Type |
|---------|------|------|
| v1.0.12 | 2026-08-25 | Major / production go-live — Canvas app v0.12.2 → v1.0.12: removed impersonation backdoor, hardened RBAC (default-to-`User`), single-student proxy registration, Learning Labs Library class picker, printable Power BI screen, series-vs-single cancellation, bulk SuperUser autosync; removed dead `CreateMeeting`/`Screen3` (21 → 20 screens); binding errors 120 → 0; partial modern-control migration. New `CreateBackups` flow + Teams reminders; national EHRM Sandbox reference lists; new `SuperUserDashboard-Final` PBI report + `tms/` staging |
| v0.12.3 | 2026-08-20 | Patch (Power Automate) — added `SendReminders` ("Send Email Reminder") flow; re-exported `AppUserList`; no Canvas app changes |
| v0.12.2 | 2026-08-12 | Feature (go-live readiness) — Canvas app v0.9.26 → v0.12.2: added `ManageUsers` + `CreateMeeting`, removed `alt_ManageDesks`/`Screen1`/`Screen2`, expanded data-source/list bindings, improved `Confirm` fallback/backup patch strategy, aligned app/manifest/package version strings, and reduced binding errors (`329 → 120`) |
| v0.9.26 | 2026-08-04 | Feature — Canvas app v0.8.14 → v0.9.26: `Desk Reservations` schema expanded ~40 columns, Class/Session Picker persisted, submitter/student identity split, attendee people-picker (book-on-behalf), POCSUPERVISOR reworked, `Desks` list normalized; project version realigned `0.8.16 → 0.9.26` (superseding 0.8.17) |
| v0.8.16 | 2026-07-28 | Feature — Canvas app v0.8.14 imported: app-wide RBAC engine, impersonation, zero-touch onboarding, training Class/Session Picker, new `alt_ManageDesks` CRUD screen, Dashboard redesign; project version realigned to `0.8.x` |
| v0.3.8 | 2026-07-28 | Patch — `src/analytics/` component added, `src/sharePoint/` restructured, `.gitignore` local-folder hardening, documentation catch-up |
| v0.3.7 | 2026-07-17 | Patch — app branding image assets, `backupProject.ps1`, release artifact rotation, enterprise script relocation |
| v0.3.6 | 2026-07-14 | Patch — `.gitignore` security hardening, data/archive file type rules, documentation catch-up |
| v0.3.5 | 2026-07-10 | Patch — automated release workflow scripts (`enterpriseCommitGuide.ps1`, `postEnterpriseCommitArchival.ps1`), Copilot prompt agents |
| v0.3.4 | 2026-07-09 | Feature — Canvas app v0.3.4: RBAC, smart scheduling, calendar modernization, UX improvements |
| v0.3.2 | 2026-07-07 | Patch — GHES compatibility fixes for release and version-bump workflows |
| v0.3.1 | 2026-07-07 | Patch — added Power Apps web development helper script |
| v0.3.0 | 2026-07-07 | Feature — GitHub Actions/workflows overhaul, VERSION file, repo automation |
| v0.2.1 | 2026-07-07 | Documentation patch — updated PROJECT_STATUS.md to reflect current project state |
| v0.2.0 | 2026-07-07 | Repository hygiene — `.gitignore` rewrite, IDE cache cleanup, template file restoration, workspace config enrichment |
| v0.1.1 | 2026-05-28 | Documentation & alignment — added PROJECT_STATUS, ARCHITECTURE, ALM-RUNBOOK; updated community files |
| v0.1.0 | 2026-05-27 | Release templates + AppUserList flow update to v0.1.0 |
| v0.0.2 | 2026-01-02 | Canvas app source unpacked; SharePoint binding fixes; screen behavior improvements |
| v0.0.1 | 2025-12-31 | Initial baseline — unpacked Canvas app, Power Automate sources, SharePoint samples |

See the root [CHANGELOG.md](../CHANGELOG.md) and [docs/release-notes/](release-notes/) for full details.

## What is in this repository

- **Unpacked sources** (for code review/diffing) for the Power Apps Canvas app and Power Automate flows; also includes `src/solution.xml` (Power Platform solution manifest, corrected in v0.3.4 to reflect EHRM Training & Booking App identity and components).
- **Documentation & runbooks**: `config/architecture/ARCHITECTURE.md`, `config/runbooks/ALM-RUNBOOK.md` (local-only; git-ignored; folder relocated to `archive/src/config/` as of v0.3.8), component-level READMEs under `src/`, and release notes under `docs/release-notes/`.
- **VS Code workspace configuration**: task definitions for common PAC CLI operations (canvas pack/unpack, solution export/unpack), recommended extensions, editor settings.
- **Scripts & hooks**: PowerShell dev-profile bootstrap (`Ensure-DevProfile.ps1`), Power Apps web helper (`powerapps-web.ps1`), workspace backup (`backupProject.ps1`), pre-commit/pre-push hooks.
- **SharePoint list data & search config**: raw list exports under `src/sharePoint/list/<listName>/local/` (local-only) and a tracked search configuration export at `src/sharePoint/searchConfig/SearchConfiguration.xml`. See [src/sharePoint/README.md](../src/sharePoint/README.md).
- **Analytics**: an early-stage Power BI report template under `src/analytics/powerBI/.pbit/` and scaffolded SQL folders under `src/analytics/sql/`. See [src/analytics/README.md](../src/analytics/README.md).
- **GitHub community files**: PR template, issue templates (including `commit_message-TEMPLATE.md` added in v0.3.4), security policy, contributing guide, Copilot instructions.

## What is intentionally NOT in this repository

- **Export artifacts** such as Solution `.zip` files and Canvas `.msapp` packages.
  - Solution `.zip` exports are stored locally under `dist/` and are git-ignored by design.
  - **Exception:** Canvas `.msapp` packages are force-tracked via `.gitignore` `!*.msapp`, so the current release package (`src/powerApps/.msapp/v0.12.2_578EHRMTrainingApp.msapp`) *is* committed to the repo alongside its unpacked source.
  - For releases, attach exports to a GitHub Release if you need distributable artifacts.
- **Compressed archive files** (`.zip`, `.7z`, `.gz`, `.rar`, `.tar`, etc.) — broadly git-ignored as of v0.3.6 to prevent large binary exports from entering the repo.
- **Spreadsheet and data list files** (`.csv`, `.xlsx`, `.xls`, `.ods`, `.tsv`, etc.) — broadly git-ignored as of v0.3.6 to prevent PII or sensitive VA data from being committed accidentally. Use `!path/to/file` negation entries in `.gitignore` to selectively expose sanitized public-facing files.
- **Any folder literally named `local/`** — broadly git-ignored as of v0.3.8 (e.g., `assets/local/`, `src/analytics/*/local/`, `src/sharePoint/list/*/local/`), in addition to the extension-based rules above.
- **Configuration, runbooks, and tooling** under `config/` — fully git-ignored as of v0.3.6. **Resolved as of v0.3.8**: the 3 files formerly tracked under `config/` (`ARCHITECTURE.md`, `ALM-RUNBOOK.md`, `alm.ps1`) have been untracked (`git rm --cached -r config/`) and the local folder relocated to `archive/src/config/`.
- **SharePoint sample data** under `src/sharePoint/` — **Resolved as of v0.3.8**: the sanitized CSVs formerly tracked at the old flat paths have been untracked (`git rm --cached -r src/sharePoint/`); only `src/sharePoint/searchConfig/SearchConfiguration.xml` is tracked today.
- **Local-only history snapshots** under `archive/` and local notes under `docs/local/` (git-ignored).
- **Secrets or environment-specific values** — use `config/local/` (git-ignored) and environment variables.
- **IDE caches** (`.vs/` folder removed in v0.2.0 and now git-ignored).

## Current data model (baseline)

The baseline artifacts are driven by SharePoint lists. As of v0.12.2 the reservation schema is materially more training-centric and operationally integrated:

- `Desk Reservations` *(v0.9.26 baseline expansion retained in v0.12.2; still the core persisted training-registration record)*
- `DeskAccessControl`
- `Desks` *(v0.9.26 normalization retained in v0.12.2)*
- `MasterScheduleList` *(bound and active in v0.12.2)*
- `SuperUserList` *(bound and active in v0.12.2)*
- `backupList_DeskReservations` *(bound and used for backup persistence in v0.12.2)*
- `Learning Lab Sessions` *(bound; scoped to `Facility = Hines` in v1.0.12)*
- `MasterScheduleList` *(renamed from the former `schedule/` staging folder)*
- National EHRM **Sandbox** reference lists *(read-only, new in v1.0.12: EHRM Roles, Scenario, Service Line, Learning Lab Sessions/Signups, Scenario Workflows, Learning Labs Library on `vacoehrmioeue/Sandbox`)*

The Canvas app now contains **20 screens** in v1.0.12 (added the printable Power BI `Screen1`; removed the dead Microsoft-template screens `CreateMeeting` and `Screen3`). Some naming still reflects legacy desk/room terminology, but the app is now a training-centric, production system with integrated user management, proxy registration, and national EHRM reference-data dependencies.

### Canvas app access control model (v0.12.2)

The RBAC logic (introduced in v0.8.14 and matured through v1.0.12) is resolved once per session in `App.OnStart` and enforced across navigation/screen access. Access is driven by `DeskAccessControl.AccessLevel_Text`. Valid levels include `ProjectLeader`, `Manager`, `ServiceChief`, `AppAdmin`, `SuperUser`, `User`, `View-Only`, and `AccessDenied`. As of v1.0.12 the **hard-coded impersonation backdoor was removed** (the app uses the real signed-in identity; a controlled proxy path lets a POC register a student). The engine now **intentionally** sets a safe `"User"` baseline for anyone with network access and self-provisions a new access row (6-month window) — resolving the former new-user `AccessDenied` race.

### Connectors & data sources

- **Connectors**: Office 365 Outlook, Office 365 Users, SharePoint *(connector set unchanged; actions expanded in v0.12.2)*
- **Data sources**: SharePoint lists (`Desk Reservations`, `DeskAccessControl`, `Desks`, `MasterScheduleList`, `SuperUserList`, `backupList_DeskReservations`, `Learning Lab Sessions`), Outlook actions, O365 Users search/profile/photo actions.

## Release readiness checklist

Before tagging/publishing a release:

1. Ensure `git status` is clean and no ignored/local-only files are staged.
2. Verify `.gitignore` patterns are not accidentally hiding tracked files (lesson from `*_temp*` matching `_TEMPLATE` in v0.2.0).
3. Scan unpacked sources under `src/` for:
   - tenant/environment IDs
   - internal URLs
   - email addresses
   - secrets/tokens
4. Confirm sample SharePoint CSVs are sanitized (no PII).
5. Update the root [CHANGELOG.md](../CHANGELOG.md) and the release drafts under [docs/release-notes/](release-notes/).
6. Export updated `.msapp` / Solution zip to `dist/release/` if you plan to attach assets.

## Next steps / roadmap (high level)

- Populate `DeskAccessControl` list with correct `AccessLevel_Text` values for all intended users, and decide the unknown-user default (currently `User`, ideally `AccessDenied`) to fully activate the RBAC system.
- **Build/validate trainer-approval and reminder Power Automate flows** — the reminder flow (`SendReminders`) was **added in v0.12.3**; validate its end-to-end wiring to the reservation/schedule lifecycle. The trainer-approval flow is still pending.
- **Burn down remaining App Checker findings** — `BindingErrorCount` improved to `120` in v0.12.2 but should be reduced further before broad production load.
- ~~Finish reconciling version strings~~ — **done in v0.12.2** (`varRepoVersion`, package label, and manifest description are now aligned at `0.12.2`).
- ~~Persist the Class/Session Picker selections~~ — **done in v0.9.26** (retained in v0.12.2).
- Complete the cancellation workflow — `Button3_9` ("Cancel This") in `MyAppts` is stubbed; the actual `Patch`/delete logic to mark a reservation as cancelled in SharePoint needs to be wired up.
- Continue replacing baseline "desk reservation" terminology with training-booking-centric labels throughout all screens and SharePoint columns.
- Evaluate adding SharePoint column `Active_choice` population on booking creation so the past/active filter works consistently from day one.
- Consider adding a user-facing in-app notification or email confirmation on successful booking cancellation.
- See [`docs/local/futureEnhancementIdeas.md`](local/futureEnhancementIdeas.md) for the full future improvement backlog.
- Add/expand component-level documentation as flows/app screens evolve.
- Develop user guides under `docs/userGuides/`.
- Evaluate additional Power Automate flows for the training scheduling workflow.
