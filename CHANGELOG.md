# Changelog

All notable changes to the **EHRM Training & Booking App** repository are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and the project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html) for the **project-wide release version** (`MAJOR.MINOR.PATCH`).

Component versions (Canvas app, each flow, SharePoint assets, etc.) are tracked in each component README under [src/](src/).

## [Unreleased]

### Added
- (Add changes here before the next release.)

### Changed
- (Add changes here before the next release.)

### Fixed
- (Add fixes here before the next release.)

---

## [0.9.26] - 2026-08-04

> **Version realignment:** the project-wide version jumps `0.8.16` → `0.9.26` to re-align the repository release line with the Canvas app's independently-advancing version (now **v0.9.26**), continuing the alignment strategy begun at `0.8.16`. This **supersedes the never-completed `0.8.17`** cycle — its blank `docs/release-notes/v0.8.17_*` stubs were renamed and filled in as `v0.9.26_*`, and no `[0.8.17]` release was ever published.
>
> **This release DOES change the SharePoint schema** (contrast with `[0.8.16]`, which had none): the `Desk Reservations` list gained ~40 columns and the `Desks` list was normalized. See below and `src/powerApps/v0.9.26_recentChangesSummary.md` §7.

### Added

- **Canvas app v0.9.26 unpacked source** — the updated Canvas app was exported and unpacked into `src/powerApps/.unpacked/` (package `src/powerApps/.msapp/v0.9.26_578EHRMTrainingApp.msapp`, tracked via `.gitignore` `!*.msapp`, replacing the prior v0.8.14 package). Where v0.8.14 was about *access*, v0.9.26 is about *data* — every booking is now a complete, persisted training record:
  - **`Desk Reservations` SharePoint list schema expanded by ~40 columns**, grouped into **submitter** (who created the request), **student/attendee** (who the training is for, incl. manager email), **reservation** (scenario / role / session start-end / decomposed location), **narrative bodies** (agreement / description / comments / invite body), **trainer approval** (received → approved → recorded-in-Excel lifecycle), and **automated-reminder** tracking (1 week / 72 h / 1 h pre-class + 24 h post-create, for student and trainer). This is the backbone of the release.
  - **Class/Session Picker is now persisted** — the **Confirm** SUBMIT `Patch` writes the full scenario/role/session/location plus separate submitter and student identities into the new columns (previously displayed but never saved).
  - **Booking on behalf of others** — POCSUPERVISOR gained an attendee people-picker (`var_Attendees`); the app records the **submitter** (real signed-in user) and the **student** (chosen attendee) as distinct fields, and generates a structured `Title` (`<attendee> – <category> - <scenario> (<role>)`).
  - **POCSUPERVISOR reworked (`+63 KB`)** — semantic picker control names (`dropdown_ScenarioPicker`/`RolePicker`/`DateTimePicker`/`LocationPicker`), a live HTML selection summary, a scenario-materials deep-link, and an admin `RESET` button.
  - **Reservation Details enriched** — surfaces scenario/role/session/submitter and a *"Contact the EHRM Trainers about this item (#ID)"* action.
  - **Two modern control templates** (`modernText`, `modernTextInput`) registered and used in the reworked forms.
  - Full file-by-file structural/behavioral diff with per-change rationale: **`src/powerApps/v0.9.26_recentChangesSummary.md`** (renamed from `v0.8.14_recentChangesSummary.md`).
- **`docs/release-notes/v0.9.26_commitMessage.md`**, **`v0.9.26_pullRequest.md`**, **`v0.9.26_releaseNotes.md`** — authored release artifacts for this release (renamed from the blank `v0.8.17_*` stubs).

### Changed

- **`VERSION`** — 0.8.17 → 0.9.26 (see version-realignment note above).
- **`README.md`** — release badge v0.8.16 → v0.9.26; Canvas app component version v0.8.14 → v0.9.26 with a training-record description.
- **`src/powerApps/README.md`** — updated header to v0.9.26, added a "What changed in v0.9.26 (current)" narrative, demoted the v0.8.14 section to "previous", added a v0.9.26 component version-history row, and refreshed the data-sources / screenshots notes.
- **`docs/PROJECT_STATUS.md`** — status summary, component versions, release history table, data model, and roadmap updated for v0.9.26 / Canvas app v0.9.26.
- **`src/solution.xml`** — Power Platform solution `Version` 0.3.4 → 0.9.26; description refreshed to current v0.9.26 features.
- **`src/sharePoint/README.md`** — documented the `Desk Reservations` schema expansion and the `Desks` normalization.
- **`assets/images/` reorganized** — loose image files consolidated into categorized subfolders (`graphics/`, `icons/`, `logos/`, `objects/`, `screenshots/`); the in-app screenshots moved from `assets/screenshots/` → `assets/images/screenshots/appGuide/` (the `src/powerApps/README.md` screenshot links were repointed accordingly).
- **`Desks` SharePoint list normalized** — legacy untyped/duplicate columns removed in favor of typed `*_choice` / `*_text` / `*_boolean` columns; `DeskSelect` / `ManageDesks` / `NewDesk` re-bound to the cleaned schema.
- **`App.OnStart`** — `varRepoVersion` corrected `0.8.12` → `0.9.26`; `varIsImpersonating` detection logic corrected (was inverted).

### Removed

- **3 legacy `Desk Reservations` columns** — `DeskFloor`, `Floor`, `Reason for desk reservation` (superseded by the new decomposed-location and narrative-body columns).
- **Prior Canvas artifacts superseded** — the v0.8.14 `.msapp` package and `src/powerApps/v0.8.14_recentChangesSummary.md` were replaced (the v0.8.14 change summary was retained locally under `archive/`).
- **Abandoned `v0.8.17_*` release-note stubs** — renamed/refilled as `v0.9.26_*`.
- **6 unused desk-specific sample images** — the `mapBldg110` / `mapFloor6` / `mapDesk3` / `RoomGA141` maps and the `Desk3` / `RoomGA141` photos (no references remain outside the app's own internal asset copies).
- **`docs/release-notes/v0.8.16_*`** — prior release notes rotated out of `docs/release-notes/` (retained under `archive/`).

### Fixed

- **Class/Session Picker persistence gap** — the `varPopUp_ClassPicker_*` / `var_reservation*` values are now written to SharePoint in the Confirm SUBMIT `Patch` (was follow-up §9 item 1 of the v0.8.14 summary).
- **In-app version stamp** — `App.OnStart` `varRepoVersion` now reads `0.9.26`, so the Dashboard version badge is accurate.
- **Impersonation detection** — `varIsImpersonating` now evaluates `varRealEmail <> varTargetEmail` (the v0.8.14 expression was inverted).

### Notes

- **Known follow-ups (see `src/powerApps/v0.9.26_recentChangesSummary.md` §9):**
  - `BindingErrorCount` rose **49 → 329** — validate in the Power Apps App Checker before production deployment (likely references to the removed columns plus the modern Text/TextInput control migration).
  - The **trainer** and **reminder** columns are inserted **blank** by the app — they are the schema contract for companion **Power Automate** approval/reminder flows that still need to be built/deployed (`src/powerAutomate/`). `OutlookEventID`/`OutlookSeriesID` are likewise deferred to a flow.
  - Residual version drift: the manifest `AppDescription` reads `v0.9.17` while the `.msapp`/`varRepoVersion` read `0.9.26`.
- **Open security gap (carried forward):** new/unknown users are still auto-granted the `User` access level rather than `AccessDenied`. Populating `DeskAccessControl.AccessLevel_Text` for all intended users, and deciding the unknown-user default, remains a required admin action.

---

## [0.8.16] - 2026-07-28

> **Version alignment:** With this release the project-wide version jumps from `0.3.8` to `0.8.16` to bring the repository release line onto the Canvas app's independently-advancing `0.8.x` version series. The Canvas app component advances **v0.3.4 → v0.8.14** (the app-internal version strings still show minor drift — `App.OnStart` sets `varRepoVersion "0.8.12"` and the Dashboard timer shows the prior stamp — tracked as a follow-up). This supersedes the note in the `[0.3.8]` entry below, which stated the Canvas app "remains v0.3.4" and that the v0.8.14 app had "not yet been exported/unpacked."

### Added

- **Canvas app v0.8.14 unpacked source** — the substantially updated Canvas app was exported and unpacked into `src/powerApps/.unpacked/` (package `src/powerApps/.msapp/v0.8.14_578EHRMTrainingApp.msapp`, tracked via `.gitignore` `!*.msapp`, replacing the prior v0.3.4 package). This is the largest functional advance since the baseline:
  - **App-wide role-based access control (RBAC) engine** — `App.OnStart` grew from a 1-line version stub into a full RBAC + auto-provisioning + impersonation engine. Eight access tiers (`AccessDenied` → `View-only` → `User` → `SuperUser` → `Manager` → `ServiceChief` → `ProjectLeader` → `AppAdmin`) are read live per-user from `DeskAccessControl` and wired into the navigation menu (`colMenu`, moved out of `Dashboard.OnVisible`), Dashboard messaging, calendar `DisplayMode`/`Items` filters, and admin-only controls.
  - **Impersonation ("act as another user")** — admins get a hidden Dashboard combobox that re-renders the entire app as any selected user (support/troubleshooting and booking on behalf of others); the real signed-in identity is captured separately and auto-provisioning never writes while impersonating.
  - **Zero-touch user onboarding** — first-launch users with no `DeskAccessControl` row are auto-provisioned at the default `"User"` level (Entra ID, timestamps, manager email via `Office365Users.Manager`).
  - **Training Class/Session Picker** — new `ctn_PopUp_ClassPicker` popup on `POCSUPERVISOR` (Scenario → Role → Date/Time session → Location), with a deep-link into the SharePoint Learning Lab Workbook library and selections echoed on the Confirm screen.
  - **New `alt_ManageDesks` screen** — modern responsive CRUD console for the `Desks` list, staged alongside legacy `ManageDesks` ahead of a planned cutover (22 screens total).
  - **Dashboard redesign** — dark-navy theme, mascot banner, role-aware welcome / "ACCESS DENIED" / "VIEW ONLY" messaging, author/version timer.
  - **Assets & components** — image assets grew from 6 → 38; new `Tabs_altColor` component.
  - Full file-by-file structural/behavioral diff with per-screen rationale: **`src/powerApps/v0.8.14_recentChangesSummary.md`** (new).
- **`docs/release-notes/v0.8.16_commitMessage.md`**, **`v0.8.16_pullRequest.md`**, **`v0.8.16_releaseNotes.md`** — populated release artifacts for this release.

### Changed

- **`VERSION`** — 0.3.8 → 0.8.16.
- **`README.md`** — release badge v0.3.8 → v0.8.16; Canvas app component version v0.3.4 → v0.8.14.
- **`src/powerApps/README.md`** — updated header to v0.8.14, added a "What changed in v0.8.14 (current)" narrative, demoted the v0.3.4 section to "previous", added a v0.8.14 component version-history row, and updated the screen inventory (21 → 22 screens; added `alt_ManageDesks`).
- **`docs/PROJECT_STATUS.md`** — status summary, component versions, release history table, data model, and RBAC section updated for v0.8.16 / Canvas app v0.8.14.

### Notes

- **Data sources and connections are unchanged** — no SharePoint schema or connector changes at the app-manifest level.
- **Open security gap (carried forward from `[0.3.8]`):** new/unknown users are still auto-granted the `User` access level rather than `AccessDenied`. Populating `DeskAccessControl.AccessLevel_Text` for all intended users, and deciding the unknown-user default, remains a required admin action.
- **Known follow-ups:** the Class/Session Picker values are displayed on Confirm but not yet persisted in the SUBMIT `Patch`; app-internal version strings show minor drift (msapp `v0.8.14`, `varRepoVersion "0.8.12"`, hardcoded Dashboard stamp, `VERSION` `0.8.16`) to be reconciled. See `src/powerApps/v0.8.14_recentChangesSummary.md` §9.

---

## [0.3.8] - 2026-07-28

### Added

- **`src/analytics/`** — New repository component for reporting/data-analysis, replacing the previously-aspirational (never populated) flat `src/powerBI/` and `src/sql/` placeholders described in `copilot-instructions.md`:
  - **`src/analytics/powerBI/.pbit/Signup Tool.pbit`** — First tracked Power BI report template (sign-up/attendance analytics).
  - **`src/analytics/powerBI/.pbix/`**, **`src/analytics/powerBI/local/`**, **`src/analytics/sql/procedures/`**, **`src/analytics/sql/queries/`**, **`src/analytics/sql/local/`** — Scaffolded subfolders (currently empty; local-only where applicable).
  - **`src/analytics/README.md`** — New component README documenting the Power BI / SQL structure and current (early-stage) status.
- **`src/sharePoint/`** — Restructured SharePoint component (see "Changed" below for what it replaces):
  - **`src/sharePoint/list/{deskAccessControl,deskReservations,desks}/local/`** — Raw list export data (CSV/XLSX), local-only/git-ignored.
  - **`src/sharePoint/list/schedule/`** — New 4th list scaffold (no schema exported yet; staged from `SULL_Jesse_Brown_Schedule_7.10.26 - Integrated.xlsx`) in support of the ongoing "desk reservation" → "training booking" terminology migration.
  - **`src/sharePoint/searchConfig/SearchConfiguration.xml`** — New tracked SharePoint search configuration export.
  - **`src/sharePoint/README.md`** — New component README documenting the `list/<listName>/local/` structure, list status table, and provenance of the prior flat layout.
- **`assets/images/Spinner.gif`** — New loading-spinner UI asset.
- **`assets/images/mascot_banner_croppedHighRes.png`** — Higher-resolution variant of the existing cropped mascot banner (`mascot_banner_cropped.png`).
- **`assets/local/`** — New local-only staging area (git-ignored) for raw screen recordings, e.g. a ~106 MB app walkthrough video (`video/SU LL Sign up APP EHRMIO.webm`).
- **`docs/release-notes/v0.3.8_commitMessage.md`**, **`v0.3.8_pullRequest.md`**, **`v0.3.8_releaseNotes.md`** — Fresh v0.3.8 release artifact stubs (populated for this release).

### Changed

- **`VERSION`** — 0.3.7 → 0.3.8
- **`README.md`** — Release badge updated v0.3.7 → v0.3.8; release date updated to 2026-07-28; "Repository layout" section updated to reference `src/analytics/` and clarify `src/sharePoint/` now covers lists + search config.
- **`.gitignore`** — Repository hygiene follow-up:
  - Added **§11 `**/local/`** — a generic rule ignoring any folder literally named `local` anywhere in the repo (covers `assets/local/`, `src/analytics/{powerBI,sql}/local/`, `src/sharePoint/list/*/local/`, and any future local-only folder), closing the gap that previously left files like the `.webm` recording above completely untracked by any rule.
  - Updated the stale §3 (`config/`) and §10 (data files) comments — both previously noted "N files remain tracked pending `git rm --cached`"; confirmed via `git ls-files` that this cleanup was already completed (0 tracked files under `config/` or `src/sharePoint/` at HEAD), so the notes now describe the resolved state instead of a pending action.
  - Updated the §10 negation example path from the old flat `src/sharePoint/Desks/Desks.csv` to the new `src/sharePoint/list/desks/local/Desks.csv`.
  - `Last updated` bumped to 2026-07-28.
- **`src/sharePoint/`** — Superseded the flat per-list sample layout (`Desk Reservations/`, `DeskAccessControl/`, `Desks/`) with the `list/<listName>/local/` + `searchConfig/` structure described above. The prior layout was already archived locally to `archive/src/sharePoint/` and was never tracked in git under its new paths (the previously-tracked sanitized CSVs at the old paths had already been untracked in a prior cleanup pass).
- **`src/powerAutomate/AppUserList/README.md`** — Updated the `DeskAccessControl.csv` sample path reference from the old `src/sharePoint/DeskAccessControl/DeskAccessControl.csv` to the new `src/sharePoint/list/deskAccessControl/local/DeskAccessControl.csv`.
- **`src/powerApps/README.md`** — Markdown table formatting normalized (column widths/spacing only; no content change).
- **`docs/PROJECT_STATUS.md`** — Comprehensive refresh (had not been updated since v0.3.6, despite two intervening releases): status summary and release history table brought current through v0.3.8; repository contents/exclusions sections corrected to match the resolved `.gitignore` tracking state and new `src/analytics/` + `src/sharePoint/` structure; data model section updated to mention the new `Schedule` list scaffold.
- **`.github/copilot-instructions.md`** — "Core Project/Workspace Components" list updated: the separate aspirational `Power BI (src\powerBI\)` and `SQL (src\sql\)` bullets are consolidated into a single `Analytics (src\analytics\powerBI\, src\analytics\sql\)` line reflecting the structure actually adopted.
- **`config/`** — Local-only architecture/runbook/tooling folder relocated to `archive/src/config/` per the project's archive conventions (folder is fully git-ignored; this is a local filesystem change only, not a tracked-content change).

### Removed

- **`docs/release-notes/v0.3.7_commitMessage.md`** — Rotated out of the live `docs/release-notes/` folder as part of the v0.3.7 → v0.3.8 artifact cycle.
- **`docs/release-notes/v0.3.7_pullRequest.md`** — Rotated out (same cycle).
- **`docs/release-notes/v0.3.7_releaseNotes.md`** — Rotated out (same cycle).

### Notes

- Release type: **Maintenance/Patch** — repository restructuring (SharePoint + new Analytics component), asset additions, and documentation catch-up; no functional changes to Canvas app or Power Automate.
- Canvas app baseline remains v0.3.4 (unchanged). A substantially updated Canvas app (targeted v0.8.14 in the Power Apps web editor) is in progress but has not yet been exported/unpacked into `src/powerApps/`; it will be evaluated and documented in a future release once available.
- `AppUserList` flow baseline remains v0.1.0 (unchanged).
- Resolves the "pending tracking cleanup" item first raised in the v0.3.6 entry and tracked in `docs/release-notes/v0.3.7_priorityWorklist.md` §5.1: `config/` and `src/sharePoint/*.csv` are now confirmed fully untracked from git (no `git rm --cached` action remains outstanding).
- Addresses `v0.3.7_priorityWorklist.md` §5.2 ("Core Components" claim reconciliation) via Path A (making Power BI/SQL real, under a consolidated `src/analytics/` grouping) rather than the alternative of demoting them to a "planned" list.
- **Security gap still open** (carried forward from v0.3.7, tracked in `v0.3.7_priorityWorklist.md` §1.1): New unknown users are still auto-granted `User` access instead of `AccessDenied` in the Canvas app RBAC default. No Canvas app changes are included in v0.3.8; this remains targeted for the next Canvas app update.

---

## [0.3.7] - 2026-07-17

### Added

- **`assets/images/`** — 21 new app branding and UI image files committed to version control for the first time, covering the full visual asset library:
  - Site theme / header: `23715-Hines-Site-Theme-DASH-cheetah_14x9-SCREEN.png`
  - People/staff banner: `banner_genericPeople.png`
  - UI button graphics: `button_getSupport.png`, `button_upcoming60Days.png`, `button_upcoming90Days.png`
  - Feature/role icons: `icon_bullhorn.png`, `icon_computerReports.png`, `icon_heartHands.jpg`, `icon_silhouetteAlert.png`, `icon_silhouetteChecklist.png`, `icon_silhouetteCrowd.png`, `icon_silhouetteExecutives.png`, `icon_silhouetteExecutivesCheckmark.png`, `icon_silhouetteReports.png`
  - Super-user role image: `image_genericSuperUser.png`
  - Mascot variants: `mascot_banner_cropped.png`, `mascot_banner_highRes.png`, `mascot_iconHorizontal_peachBackground.png`, `mascot_iconRound_transparent.png`, `mascot_iconVertical_whiteBackground.png`, `mascot_icon_lowRes.png`
- **`src/scripts/pwsh/backupProject.ps1`** — New PowerShell 7 script that creates a timestamped `.zip` archive of the entire workspace to `archive/backup/` (git-ignored). Compresses to `$env:TEMP` first, runs 7-Zip integrity validation (`7z t`), then moves to the permanent location and re-validates. Auto-detects the project root whether invoked from `src/scripts/pwsh/` or the workspace root.
- **`docs/release-notes/v0.3.7_commitMessage.md`** — Fresh v0.3.7 commit message artifact (populated for this release).
- **`docs/release-notes/v0.3.7_pullRequest.md`** — Fresh v0.3.7 PR description artifact (populated for this release).
- **`docs/release-notes/v0.3.7_releaseNotes.md`** — Fresh v0.3.7 release notes artifact (populated for this release).
- **`docs/release-notes/v0.3.7_priorityWorklist.md`** — Comprehensive developer planning document listing all Canvas app security fixes, feature improvements, and repository health items planned for v0.3.7 and near-term. Generated during the 2026-07-14 project deep-dive (Sections 1–6: RBAC security, UX, training schedule, admin features, repo health, and deferred v0.4.x backlog).

### Changed

- **`VERSION`** — 0.3.6 → 0.3.7
- **`README.md`** — Release badge updated v0.3.6 → v0.3.7; release date updated to 2026-07-17.
- **`CHANGELOG.md`** — [0.3.7] entry added (this entry).

### Removed

- **`src/scripts/pwsh/enterpriseCommitGuide.ps1`** — Removed from tracked source and relocated locally to `docs/release-notes/releaseTemplates/` (git-ignored). These release-cycle orchestration scripts are better co-located with the release artifact templates they operate on; they were incorrectly placed in `src/scripts/pwsh/` when first added in v0.3.5.
- **`src/scripts/pwsh/postEnterpriseCommitArchival.ps1`** — Same rationale and relocation as `enterpriseCommitGuide.ps1` above.
- **`docs/release-notes/v0.3.6_commitMessage.md`** — Rotated out of the live `docs/release-notes/` folder as part of the v0.3.6 → v0.3.7 artifact cycle.
- **`docs/release-notes/v0.3.6_pullRequest.md`** — Rotated out (same cycle).
- **`docs/release-notes/v0.3.6_releaseNotes.md`** — Rotated out (same cycle).

### Notes

- Release type: Maintenance/Patch — repository asset additions, developer tooling, and ALM housekeeping; no functional changes to Canvas app, Power Automate, or SharePoint.
- Canvas app baseline remains v0.3.4 (unchanged).
- `AppUserList` flow baseline remains v0.1.0 (unchanged).
- **Security gap still open** (tracked in `v0.3.7_priorityWorklist.md` §1.1): New unknown users are auto-granted `User` access instead of `AccessDenied` in the Canvas app RBAC default. Fix requires a Canvas app editor change, re-export, and unpack — targeted for the next Canvas app update.
- **Pending tracking cleanup** (carried forward from v0.3.6): 3 `config/` files and 10 `src/sharePoint/*.csv` files remain in the git index until `git rm --cached` is explicitly run. See worklist item 5.1 in `v0.3.7_priorityWorklist.md`.

---

### Added

- **`docs/release-notes/v0.3.6_commitMessage.md`** — Fresh template stub created by the post-v0.3.5 artifact rotation (`postEnterpriseCommitArchival.ps1`); ready for population before the release commit.
- **`docs/release-notes/v0.3.6_pullRequest.md`** — Fresh template stub (same post-v0.3.5 rotation).
- **`docs/release-notes/v0.3.6_releaseNotes.md`** — Fresh template stub (same post-v0.3.5 rotation).

### Changed

- **`.gitignore`** — Comprehensive overhaul for security hardening and repo hygiene (2026-07-14):
  - Added `/config/` — now fully ignores the entire root-level `config/` directory; previously only `config/local/` and `config/logs/` were excluded. The 3 files currently tracked under `config/` (`ARCHITECTURE.md`, `ALM-RUNBOOK.md`, `alm.ps1`) remain in the git index until explicitly untracked with `git rm --cached -r config/`.
  - Added `/.git/` — explicit entry for documentation clarity (Git always protects this directory internally; entry is redundant but intentional).
  - Added full suite of compressed archive format rules: `**/*.7z`, `**/*.gz`, `**/*.bz2`, `**/*.tar`, `**/*.tgz`, `**/*.tar.gz`, `**/*.tar.bz2`, `**/*.rar` (previously only `*.zip` was covered).
  - Added spreadsheet and data list file type rules: `**/*.csv`, `**/*.tsv`, `**/*.xlsx`, `**/*.xls`, `**/*.xlsm`, `**/*.xlsb`, `**/*.ods` — prevents PII or sensitive VA data files from being committed accidentally. The 10 sanitized CSVs currently tracked under `src/sharePoint/` remain in the git index until explicitly untracked.
  - Fixed `/docs/release-notes/releaseTemplates/` — added root-anchoring `/` prefix for consistency with all other directory rules (rule was already working but was not root-anchored).
  - Removed redundant `config/local/` and `config/logs/` entries — now superseded by the broader `/config/` rule.
  - Updated `Last updated` date to 2026-07-14; refreshed section numbering (now §1–§10) and added instructional inline comments to §9 and §10 guiding use of `!` negation for per-file exceptions.
- **`VERSION`** — 0.3.5 → 0.3.6 (automated by `postEnterpriseCommitArchival.ps1` post-v0.3.5 release rotation).

### Removed

- **`docs/release-notes/v0.3.5_commitMessage.md`** — Rotated out of the live `docs/release-notes/` folder by `postEnterpriseCommitArchival.ps1` as part of the v0.3.5 → v0.3.6 artifact cycle.
- **`docs/release-notes/v0.3.5_pullRequest.md`** — Rotated out of the live `docs/release-notes/` folder (same post-release rotation).
- **`docs/release-notes/v0.3.5_releaseNotes.md`** — Rotated out of the live `docs/release-notes/` folder (same post-release rotation).

### Notes

- Release type: Patch — repository hygiene and `.gitignore` security hardening; no functional changes to Canvas app, Power Automate, or SharePoint.
- Canvas app baseline remains v0.3.4 (unchanged).
- `AppUserList` flow baseline remains v0.1.0 (unchanged).
- **Pending tracking cleanup** (requires explicit `git rm --cached` before or alongside this release commit):
  - `config/` — 3 files currently tracked (`config/architecture/ARCHITECTURE.md`, `config/runbooks/ALM-RUNBOOK.md`, `config/tools/pac/alm.ps1`) will remain in the remote repo until `git rm --cached -r config/` is run.
  - `src/sharePoint/` — 10 sanitized CSV files currently tracked will remain in the remote repo until individually removed or until a decision is made on which (if any) to retain as public-facing samples. Use `git rm --cached -r src/sharePoint/` or `!path/to/file.csv` negation entries for retained files.

---

## [0.3.5] - 2026-07-10

### Added

- **`src/scripts/pwsh/enterpriseCommitGuide.ps1`** — New enterprise-grade PowerShell 7 script that fully automates the release branch/commit/push/PR/checks/merge/sync cycle for VA GHES environments. Validates prerequisites (VERSION + all three release artifact `.md` files), creates a `pr/release-vX.Y.Z` branch, commits all staged changes using the first line of `_commitMessage.md` as the title, opens a draft PR with `gh pr create --body-file`, watches CI checks with `gh pr checks --watch`, marks ready, merges, and re-syncs the local `main` branch. Supersedes the manual `docs/local/v6_manualRepoManagement.md` workflow guide.
- **`src/scripts/pwsh/postEnterpriseCommitArchival.ps1`** — New PowerShell 7 script that performs the three-step post-release artifact rotation: (1) archives current live `docs/release-notes/v*_commitMessage.md`, `v*_pullRequest.md`, and `v*_releaseNotes.md` files to `.\archive\docs\release-notes\` (with timestamp suffix on name collision); (2) renames the live files by swapping the old version prefix with the next version from `.\VERSION`; (3) overwrites renamed files with fresh template content from `.\docs\release-notes\releaseTemplates\`, leaving them ready for the next release cycle.
- **`.github/prompts/`** — Four new Copilot Chat prompt files (`.prompt.md` format) that act as AI-driven release documentation agents. Each reads the current `VERSION`, runs `git status/diff/log` commands, analyzes all pending workspace changes, and populates `{{PLACEHOLDER}}` fields in the targeted release artifact documents. Scopes:
  - `enterprisePrepareAll.prompt.md` — all three release artifacts (`_commitMessage.md`, `_pullRequest.md`, `_releaseNotes.md`) plus a `CHANGELOG.md` entry in a single pass
  - `enterprisePrepareCommit.prompt.md` — commit message artifact + CHANGELOG entry
  - `enterprisePreparePR.prompt.md` — pull request artifact only
  - `enterprisePrepareRelease.prompt.md` — release notes artifact only

### Changed

- **`VERSION`** — 0.3.4 → 0.3.5
- **`CHANGELOG.md`** — [0.3.5] entry added (this file)

### Removed

- **`docs/release-notes/v0.3.4_commitMessage.md`** — removed from live folder as part of v0.3.4→v0.3.5 artifact rotation; previously committed with the v0.3.4 release
- **`docs/release-notes/v0.3.4_pullRequest.md`** — removed from live folder (same rotation)
- **`docs/release-notes/v0.3.4_releaseNotes.md`** — removed from live folder (same rotation)

### Notes

- Release type: Patch — developer tooling and ALM infrastructure only; no functional Canvas app, Power Automate, or SharePoint changes
- Canvas app baseline remains v0.3.4 (unchanged)
- `AppUserList` flow baseline remains v0.1.0 (unchanged)

---

## [0.3.4] - 2026-07-09

### Added

- **Canvas app `scrn_DailyCal` screen** — New "Daily Calendar List" screen replacing the deprecated `scrn_WeeklyCal_1`. Displays a filterable daily training room reservation list ("Daily Training Room List") with ID#, Desk Reservation Info, and POC Comments columns. Built on the modern Power Apps container grid layout (6 col × 6 row).
- **Canvas app role-based access control (RBAC)** — `Dashboard.OnVisible` now resolves the current user's `AccessLevel_Text` from the `DeskAccessControl` SharePoint list and builds `colMenu` conditionally across 8 access tiers: `SuperUser`, `AppAdmin`, `Manager`, `ServiceChief`, `ProjectLeader`, `User`, `View-only`, `AccessDenied`. Users with `AccessDenied` receive an empty menu.
- **Canvas app `userAccessDemographics` collection** — Populated on Dashboard load with the current user's full access control record for downstream use.
- **Canvas app `App.OnStart` version variable** — `Set(varGetRepo_ProjectVersion, "0.3.4")` added to `App.OnStart` (previously empty), initializing a global version string displayed in the Dashboard top-left corner.
- **Canvas app smart scheduling default time** — `chkWeekDays.OnVisible` now calculates and injects a default start time rounded up to the nearest 15-minute boundary from current clock time.
- **Canvas app booking conflict detector** — `chkWeekDays` surfaces all existing reservations on the selected date in a live "Existing reservations already booked" gallery, visible before the user continues.
- **Canvas app `MyAppts` — explicit action buttons** — Added "View This" (green) and "Cancel This" (red) buttons inside the `gallUpcoming` gallery template, replacing icon-only navigation.
- **Canvas app cancellation confirmation dialog** — `MyAppts` shows a modal "Confirm Cancellation?" overlay (NEVERMIND / CONFIRM) before any reservation cancellation executes.
- **Canvas app scheduling dropdowns** — New `ddImportance` (Normal/High/Low), `ddReminder` (minute intervals), and `ddRecurrenceFrequency` (None/Daily/Weekly) controls on `chkWeekDays` for richer booking options.
- **Canvas app O365 Users connector actions** — Added `MyProfileV2`, `ManagerV2`, `UserProfileV2` to the connector manifest.
- **Screenshots (v0.3.4)** — 19 app screenshots captured 2026-07-09 and stored under `assets/screenshots/` (renamed from `v0.2.7_*` to `v0.3.4_*`; `scrn_WeeklyCal1` renamed to `scrn_DailyCal`).
- **`.github/ISSUE_TEMPLATE/commit_message-TEMPLATE.md`** — New commit message template modeled on the v0.3.4 commit style; Conventional Commits format with type/scope/version title line, Context section, per-file-area change bullets, documentation sub-sections for updated/new/renamed files, and an inline type and scope reference guide.

### Changed

- **Canvas app `Dashboard` — gallery filter** — `gallMyReservationsPreview` filter simplified to `'Reserved By'.Email` only (removed the OR `'Created By'.Email` condition).
- **Canvas app `Dashboard` — calendar button** — `Button5` text "Click to see calendar" → "View calendars!"; height 94→37, width 240→333.
- **Canvas app `Dashboard` — reason label** — `Label6` height 26→94px, `Overflow = Scroll`, `VerticalAlign = Top` to support multi-line text.
- **Canvas app `chkWeekDays` — advance booking window** — `DaysAheadRestriction` 180 → **230 days**.
- **Canvas app `chkWeekDays` — auto 1-hour duration** — `ContinueDatebtn.OnSelect` pre-calculates `varEventEndTime = varEventStartTime + 60 minutes`.
- **Canvas app `MyAppts` — past reservations filter** — `gallPast` filter expanded to include items where `Active_choice.Value` is blank or `"false"`.
- **Canvas app `Reservation` screen labels** — Comprehensive relabeling: title → "Reservation Details"; name label → "EHRM Training Description" (Bold); floor label → "Location (Desk/Room/Building/Division):"; map label → "Start Date/Time"; description label → "Additional Comments/Notes:".
- **Canvas app `Confirm` screen** — `Container2` upgraded to 6×6 layout grid; `Gallery3_1` template size 22→175px; `TextCanvas7_4` renders combined training category + location.
- **Canvas app `scrn_WeeklyCal` + `scrn_MoCalendar`** — Containers updated to 6×6 grid layout.
- **Canvas app `scrn_MoCalendar` — Daily button** — `OnSelect` updated from `Navigate(scrn_WeeklyCal_1)` → `Navigate(scrn_DailyCal)`.
- **Canvas app platform format** — `FormatVersion` 0.24→0.30, `DocVersion` 1.347→1.349, `MinVersionToLoad` 1.331→1.349. Preview flags `commentgeneratedformulasv2`, `enablecreateaformula`, `enablesaveloadcleardataonweb` all toggled `false`→`true`.
- **`src/powerApps/README.md`** — Complete rewrite for v0.3.4: full screen inventory table (21 screens), all 8 change areas documented, screenshots table, connector/platform diff tables, component version history.
- **`README.md`** (root) — Version badge v0.3.2→v0.3.4; project release 2026-07-07→2026-07-09; Canvas app v0.0.2→v0.3.4.
- **`VERSION`** — 0.3.2→0.3.4.
- **`docs/PROJECT_STATUS.md`** — Status summary and release history updated for v0.3.4.
- **`assets/screenshots/`** — All 19 files renamed from `v0.2.7_*` to `v0.3.4_*` prefix.
- **`src/solution.xml`** — Completely corrected from an unrelated Employee Recognition project placeholder to the correct EHRM Training & Booking App content: `UniqueName` → `EHRMTrainingBooking`; `LocalizedName` → "578 EHRM Training & Booking App"; `Version` → 0.3.4; Canvas app schema → `vah_EHRMTrainingBookingApp`; Power Automate flow → `vah_AppUserList`; connections → SharePoint, Outlook, O365Users (Teams and Approvals removed); environment variables → `vah_SharePointSiteUrl`, `vah_NotificationEmailFrom`, `vah_BookingHorizonDays`.
- **`.github/ISSUE_TEMPLATE/pull_request-TEMPLATE.md`** — Substantially rewritten from a generic GitHub checkbox-style template to match the v0.3.4 PR narrative style: Summary paragraph, "Changes at a glance" table, numbered detailed breakdown sections, Known Issues block, and artifact-level verification checklist.
- **`.github/ISSUE_TEMPLATE/release_notes-TEMPLATE.md`** — Substantially updated from a generic Added/Changed/Fixed structure to match the v0.3.4 detailed release notes style: metadata block, Executive Summary with numbered change area list, per-area narrative sections with before/after tables and formula code blocks, Upgrade Notes callout, Known Issues block, and Component Baselines table.

### Removed

- **Canvas app `scrn_WeeklyCal_1` screen** — Removed and replaced by `scrn_DailyCal`.
- **Canvas app legacy Outlook actions** — `V4CalendarGetItems` and `CalendarGetTables_V2` removed from connector manifest (deprecated).

### Notes

- Release type: **Feature** — First major Canvas app functional update since v0.0.2.
- Canvas app component version: v0.0.2 → **v0.3.4** (now aligned with project release versioning).
- `AppUserList` flow baseline remains v0.1.0 (unchanged).
- SharePoint schema unchanged — new RBAC requires `DeskAccessControl` list's `AccessLevel_Text` column to be populated per-user for full role enforcement.

---

## [0.3.2] - 2026-07-07

### Fixed

- **`release.yml`** — added `GH_HOST` and `--repo` flags for GHES compatibility (would have failed with 401 on first tag push).
- **`version-bump.yml`** — added `GH_HOST` and `--repo` flags for GHES compatibility (would have failed with 401 on first version bump).
- **`pr-auto-setup.yml`** — disabled Copilot review job (not available on GHES; was producing a misleading red X on every PR).

### Notes

- Release type: Patch
- Canvas app baseline remains v0.0.2
- `AppUserList` flow baseline remains v0.1.0

---

## [0.3.1] - 2026-07-07

### Added

- **`src/scripts/pwsh/powerapps-web.ps1`** — Power Apps web development workflow helper script with commands for packaging (.msapp), opening the Power Apps portal, opening source in VS Code, and showing development status.

### Notes

- Release type: Patch
- Canvas app baseline remains v0.0.2
- `AppUserList` flow baseline remains v0.1.0

---

## [0.3.0] - 2026-07-07

### Added

- **`VERSION` file** — single source of truth for the project-wide SemVer number, read by all workflows and scripts.
- **`.github/labeler.yml`** — label-to-path mapping config for the Labeler workflow (moved from `.github/workflows/` to the correct location).
- **New workflow: `pr-auto-setup.yml`** — auto-assigns PRs, posts contextual review checklist, requests Copilot code review.
- **New workflow: `version-bump.yml`** — manual-trigger workflow that scaffolds a new version: updates VERSION, README, CHANGELOG, PROJECT_STATUS, creates release notes templates, and opens a draft PR.
- **New workflow: `repo-lint.yml`** — validates repo structure (required files, component READMEs, VERSION/badge sync, JSON integrity, file placement).
- **New workflow: `pr-security-scan.yml`** — scans PRs for GUIDs, SharePoint URLs, VA emails, secrets, and SSN-like patterns in source files and CSVs.
- **New workflow: `release.yml`** — auto-creates GitHub Releases when a `v*` tag is pushed, using pre-written release notes.
- v0.3.0 release drafts: [docs/release-notes/v0.3.x/v0.3.0/](docs/release-notes/v0.3.x/v0.3.0/)

### Changed

- **GitHub Actions/workflows fully overhauled** — removed 2 unused workflows (`greetings.yml`, `summary.yml`), re-enabled and enhanced all remaining workflows with proper triggers, updated action versions, and path corrections.
- **`label.yml`** — upgraded `actions/labeler` from v4 to v5, added proper `pull_request_target` event types.
- **`powerplatform-ci.yml`** — added Canvas app JSON validation (all files, not just manifest), added Power Automate flow JSON validation, fixed solution path from `src/solutions/` to `config/solutions/`, added `pull_request` trigger, added path filters.
- **`stale.yml`** — tuned for solo developer: 90-day stale window (was 30), 30-day close (was 14), weekly schedule (was daily), exempt `in-progress`/`pinned`/`blocked` labels, upgraded `actions/stale` from v5 to v9.
- **`.github/labeler.yml`** — added `scripts`, `release` labels; split `repo-hygiene` from `scripts`.
- **All workflow files** — added comprehensive commented-out educational documentation headers and inline annotations.
- **`PULL_REQUEST_TEMPLATE.md`** — moved from `.github/ISSUE_TEMPLATE/` to `.github/` (correct location for GitHub to auto-populate PR descriptions).

### Removed

- **`greetings.yml`** — first-interaction greeting (no value for solo developer; `actions/first-interaction@v1` is archived).
- **`summary.yml`** — AI issue summarization (requires GitHub Models; summarizes your own issues back to you).

### Fixed

- **`.github/labeler.yml`** location — moved from `.github/workflows/` to `.github/` where `actions/labeler@v5` expects it.
- **`.github/PULL_REQUEST_TEMPLATE.md`** location — moved from `.github/ISSUE_TEMPLATE/` to `.github/` where GitHub expects it.
- **`powerplatform-ci.yml`** solution path — changed `src/solutions/EHRMTrainingBooking` to `config/solutions/EHRMTrainingBooking` matching actual repo layout.

### Notes

- Release type: Feature
- This release adds significant CI/CD automation but makes no functional changes to the Canvas app or Power Automate flows.
  - Canvas app baseline remains v0.0.2 (see [src/powerApps/README.md](src/powerApps/README.md))
  - `AppUserList` flow baseline remains v0.1.0 (see [src/powerAutomate/AppUserList/README.md](src/powerAutomate/AppUserList/README.md))

---

## [0.2.1] - 2026-07-07

### Changed

- **`docs/PROJECT_STATUS.md`** — comprehensive update to reflect current project state:
  - Updated status summary from v0.1.1 to v0.2.1 with release history table covering all releases.
  - Expanded repository contents and exclusions documentation.
  - Enriched data model section with screen count and connectors/data sources.
  - Added `.gitignore` verification step to release readiness checklist.
  - Extended roadmap with user guide and additional flow goals.
- **`README.md`** — updated version badge and current version to v0.2.1.

### Added

- v0.2.1 release drafts: [docs/release-notes/v0.2.x/v0.2.1/](docs/release-notes/v0.2.x/v0.2.1/)

### Notes

- Documentation-only patch release; no functional changes to the Canvas app or Power Automate flows.
  - Canvas app baseline remains v0.0.2 (see [src/powerApps/README.md](src/powerApps/README.md))
  - `AppUserList` flow baseline remains v0.1.0 (see [src/powerAutomate/AppUserList/README.md](src/powerAutomate/AppUserList/README.md))

---

## [0.2.0] - 2026-07-07

### Added

- PR template: [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md) — now tracked (was previously excluded by an overly broad `*_temp*` gitignore pattern).
- Release notes template: [docs/release-notes/RELEASE_TEMPLATE.md](docs/release-notes/RELEASE_TEMPLATE.md) — now tracked (same root cause).
- v0.2.0 release drafts: [docs/release-notes/v0.2.x/v0.2.0/](docs/release-notes/v0.2.x/v0.2.0/)

### Changed

- **`.gitignore` rewrite** — restructured and corrected:
  - Removed overly broad `*_temp*` / `*temp_*` patterns that were incorrectly hiding `*_TEMPLATE*` files.
  - Removed `.gitattributes` and `.editorconfig` from ignore list (these are team-shared configs and should be tracked).
  - Consolidated redundant rules (`/archive/` + `/archive/**` → `/archive/`; `**/*.bak` + `*.bak` → `**/*.bak`).
  - Added missing common patterns: `~$*` (Office temp-lock files), `**/*.log`, `*.swp`, `*.swo`, `*.tmp`.
- **`.vs/` folder removed from tracking** (9 files) — Visual Studio IDE cache, index, and SQLite files are machine-specific and should never be in a public repository.
- **`tmp/` folder removed from tracking** (8 files) — temporary scratch/probe files are developer-only local artifacts.
- **`.github/copilot-instructions.md`** — updated Copilot agent guidance:
  - Added explicit PowerShell terminal `^U` workaround documentation for new-terminal initialization.
  - Re-enabled previously disabled "Releases, Tags, and Release Notes" guidance section.
  - Updated folder structure references to include `archive/` and `tmp/` conventions.
- **`.vscode/578-EHRM-TrainingSchedulerApp.code-workspace`** — enriched workspace configuration:
  - Added workspace folder display name.
  - Added editor settings (`trimTrailingWhitespace`, `insertFinalNewline`, `formatOnSave`).
  - Added `files.exclude` visibility rules for `.cache` and `dist`.
  - Added GitHub authentication settings.
  - Added recommended extensions list (Copilot, PowerShell, Power Platform, etc.).
  - Embedded PAC CLI task definitions directly in the workspace file.

### Fixed

- `.github/PULL_REQUEST_TEMPLATE.md` and `docs/release-notes/RELEASE_TEMPLATE.md` are now visible on the public repository (previously hidden by the `*_temp*` gitignore bug).
- `.vs/` IDE cache files no longer pollute the public repository history.
- `tmp/` scratch files no longer appear in the public repository.

### Notes

- This release is focused on repository hygiene, developer tooling, and gitignore correctness; no functional changes to the Canvas app or Power Automate flows.
  - Canvas app baseline remains v0.0.2 (see [src/powerApps/README.md](src/powerApps/README.md))
  - `AppUserList` flow baseline remains v0.1.0 (see [src/powerAutomate/AppUserList/README.md](src/powerAutomate/AppUserList/README.md))

---

## [0.1.1] - 2026-05-28

### Added

- Release readiness and public-facing documentation:
  - [docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md)
  - v0.1.1 release drafts: [docs/release-notes/v0.1.x/v0.1.1/](docs/release-notes/v0.1.x/v0.1.1/)
- Canonical runbook documentation under [config/](config/):
  - [config/architecture/ARCHITECTURE.md](config/architecture/ARCHITECTURE.md)
  - [config/runbooks/ALM-RUNBOOK.md](config/runbooks/ALM-RUNBOOK.md)

### Changed

- Updated public “start here” docs and links:
  - [README.md](README.md)
  - Release notes template: [docs/release-notes/RELEASE_TEMPLATE.md](docs/release-notes/RELEASE_TEMPLATE.md)
- Updated GitHub community health files for public use:
  - Security policy: [.github/SECURITY.md](.github/SECURITY.md)
  - Contributing guide: [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md)
  - PR template: [.github/PULL_REQUEST_TEMPLATE.md](.github/PULL_REQUEST_TEMPLATE.md)
  - Issue templates: [.github/ISSUE_TEMPLATE/](.github/ISSUE_TEMPLATE/)
- Updated PAC task paths to match current canonical unpack locations:
  - [.vscode/tasks.json](.vscode/tasks.json)

### Fixed

- Removed stale placeholder references (unrelated project/version text) from v0.1.1 release drafts and templates.
- Corrected documentation links after reorganizing canonical doc locations.

### Notes

- This release is focused on documentation + repository alignment; no functional changes are intended to the Canvas app or `AppUserList` flow.
  - Canvas app baseline remains v0.0.2 (see [src/powerApps/README.md](src/powerApps/README.md))
  - `AppUserList` flow baseline remains v0.1.0 (see [src/powerAutomate/AppUserList/README.md](src/powerAutomate/AppUserList/README.md))

---

## [0.1.0] - 2026-05-27

### Added

- Release draft templates under [docs/release-notes/](docs/release-notes/).

### Changed

- Power Automate: `AppUserList` flow updated to v0.1.0 (see [src/powerAutomate/AppUserList/README.md](src/powerAutomate/AppUserList/README.md)).

### Fixed

- Broken documentation links and stale path references.
- Invalid JSON in VS Code workspace config.

---

## [0.0.2] - 2026-01-02

### Added

- Canvas app v0.0.2 unpacked source under `src/powerApps/.unpacked/` (pack/unpack artifact is a local `.msapp`, git-ignored).

### Changed

- SharePoint list bindings and screen behavior improvements (see [src/powerApps/README.md](src/powerApps/README.md)).

### Validation

- Manual smoke test: submit reservation requests and verify persistence in SharePoint.

---

## [0.0.1] - 2025-12-31

### Added

- Initial repository baseline:
  - Unpacked Canvas app source under `src/powerApps/.unpacked/`
  - Unpacked Power Automate sources under `src/powerAutomate/`
  - Sanitized SharePoint sample CSVs under `src/sharePoint/`
- VS Code task scaffolding for common Power Platform CLI (`pac`) operations.

### Notes

- Unpacked artifacts may include environment-specific IDs/URLs/emails; sanitize before broad sharing.
