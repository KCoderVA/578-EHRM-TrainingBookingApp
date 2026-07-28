# Project Status

This document describes the current public state of the EHRM Training & Booking App repository and what is included/excluded as of the latest release.

## Status summary (v0.8.16)

- **Release type**: Feature — first major Canvas app functional advance imported into source control since v0.3.4. The Canvas app component advances **v0.3.4 → v0.8.14** (app-wide RBAC engine, impersonation, zero-touch onboarding, training Class/Session Picker, new `alt_ManageDesks` CRUD screen, Dashboard redesign). The project-wide version jumps `0.3.8 → 0.8.16` to align the repo release line with the Canvas app's `0.8.x` series. **No SharePoint schema or connector changes** at the app-manifest level.
- **Project release**: v0.8.16 (2026-07-28)
- **Component versions**:
  - Canvas app: **v0.8.14** (source-controlled unpacked source under `src/powerApps/.unpacked/`; package at `src/powerApps/.msapp/v0.8.14_578EHRMTrainingApp.msapp`, tracked via `.gitignore` `!*.msapp`). See [src/powerApps/README.md](../src/powerApps/README.md) and the full diff in [src/powerApps/v0.8.14_recentChangesSummary.md](../src/powerApps/v0.8.14_recentChangesSummary.md).
  - Power Automate: `AppUserList` v0.1.0 (source-controlled unpacked source under `src/powerAutomate/AppUserList/.unpacked/`)
  - SharePoint: `src/sharePoint/list/<listName>/local/` (raw exports, local-only) + `src/sharePoint/searchConfig/SearchConfiguration.xml` (tracked) — see [src/sharePoint/README.md](../src/sharePoint/README.md)
  - Analytics: `src/analytics/powerBI/` (Power BI `.pbit` template tracked) + `src/analytics/sql/` (scaffolded, currently empty) — see [src/analytics/README.md](../src/analytics/README.md)

## Release history

| Version | Date | Type |
|---------|------|------|
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
  - **Exception:** Canvas `.msapp` packages are force-tracked via `.gitignore` `!*.msapp`, so the current release package (`src/powerApps/.msapp/v0.8.14_578EHRMTrainingApp.msapp`) *is* committed to the repo alongside its unpacked source.
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

The current baseline artifacts are driven by SharePoint lists with a desk/reservation-style schema:

- `Desk Reservations`
- `DeskAccessControl`
- `Desks`
- `Schedule` *(new in v0.3.8 — scaffold only; no list schema exported yet)*

The Canvas app now contains 22 screens (v0.8.14 added `alt_ManageDesks`, a modern responsive CRUD console for the `Desks` list; v0.3.4 had previously replaced `scrn_WeeklyCal_1` with `scrn_DailyCal`). The screen and list naming still reflects the original desk/room reservation terminology in some areas. The new `Schedule` list scaffold is an early step toward renaming/re-modeling fields and labels to fully training-centric terminology, an expected future change.

### Canvas app access control model (v0.8.14)

As of v0.8.14 the RBAC logic was re-architected out of `Dashboard.OnVisible` and into `App.OnStart`, so access is resolved once per session and enforced consistently across every screen. Access is driven by the `DeskAccessControl` SharePoint list's `AccessLevel_Text` column. Valid access levels are: `SuperUser`, `AppAdmin`, `Manager`, `ServiceChief`, `ProjectLeader`, `User`, `View-only`, `AccessDenied`. The engine also **auto-provisions** first-launch users (default `"User"` level, with Entra ID / timestamps / manager email) and supports **admin impersonation** ("act as another user") for support and booking-on-behalf-of. Each intended user's row in `DeskAccessControl` should have `AccessLevel_Text` populated for correct role enforcement. **Open gap:** unknown users still default to `User` rather than `AccessDenied`.

### Connectors & data sources

- **Connectors**: Office 365 Outlook, Office 365 Users, SharePoint
- **Data sources**: SharePoint lists (Desk Reservations, DeskAccessControl, Desks), Outlook actions, O365 Users search

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

- Populate `DeskAccessControl` list with correct `AccessLevel_Text` values for all intended users, and decide the unknown-user default (currently `User`, ideally `AccessDenied`) to fully activate the v0.8.14 RBAC system.
- **Persist the Class/Session Picker selections** — in v0.8.14 the `varPopUp_ClassPicker_*` values (scenario/role/session/location) are displayed on Confirm but not yet written in the SUBMIT `Patch`; wire them into the SharePoint record so they can drive attendance reporting.
- **Reconcile app-internal version strings** — msapp label `v0.8.14`, `App.OnStart` `varRepoVersion "0.8.12"`, hardcoded Dashboard stamp, and `VERSION` `0.8.16` should be unified.
- Complete the cancellation workflow — `Button3_9` ("Cancel This") in `MyAppts` is stubbed; the actual `Patch`/delete logic to mark a reservation as cancelled in SharePoint needs to be wired up.
- Continue replacing baseline "desk reservation" terminology with training-booking-centric labels throughout all screens and SharePoint columns.
- Evaluate adding SharePoint column `Active_choice` population on booking creation so the past/active filter works consistently from day one.
- Consider adding a user-facing in-app notification or email confirmation on successful booking cancellation.
- See [`docs/local/futureEnhancementIdeas.md`](local/futureEnhancementIdeas.md) for the full future improvement backlog.
- Add/expand component-level documentation as flows/app screens evolve.
- Develop user guides under `docs/userGuides/`.
- Evaluate additional Power Automate flows for the training scheduling workflow.
