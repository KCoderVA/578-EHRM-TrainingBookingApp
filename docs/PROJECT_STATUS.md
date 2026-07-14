# Project Status

This document describes the current public state of the EHRM Training & Booking App repository and what is included/excluded as of the latest release.

## Status summary (v0.3.6)

- **Release type**: Patch — `.gitignore` security hardening and repository hygiene; comprehensive data file type and compressed archive ignore rules; documentation catch-up through v0.3.5 and v0.3.6
- **Project release**: v0.3.6 (2026-07-14)
- **Component versions**:
  - Canvas app: **v0.3.4** (source-controlled unpacked source under `src/powerApps/.unpacked/`; package at `src/powerApps/.msapp/v0.3.4_578EHRMTrainingApp.msapp`)
  - Power Automate: `AppUserList` v0.1.0 (source-controlled unpacked source under `src/powerAutomate/AppUserList/.unpacked/`)
  - SharePoint samples: `src/sharePoint/` (sanitized CSVs — schema unchanged)

## Release history

| Version | Date | Type |
|---------|------|------|
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
- **Documentation & runbooks**: `config/architecture/ARCHITECTURE.md`, `config/runbooks/ALM-RUNBOOK.md` (local-only; git-ignored as of v0.3.6), component-level READMEs under `src/`, and release notes under `docs/release-notes/`.
- **VS Code workspace configuration**: task definitions for common PAC CLI operations (canvas pack/unpack, solution export/unpack), recommended extensions, editor settings.
- **Scripts & hooks**: PowerShell dev-profile bootstrap (`Ensure-DevProfile.ps1`), pre-commit/pre-push hooks.
- **SharePoint sample data**: sanitized CSVs under `src/sharePoint/`.
- **GitHub community files**: PR template, issue templates (including `commit_message-TEMPLATE.md` added in v0.3.4), security policy, contributing guide, Copilot instructions.

## What is intentionally NOT in this repository

- **Export artifacts** such as Solution `.zip` files and Canvas `.msapp` packages.
  - These are stored locally under `dist/` and are git-ignored by design.
  - For releases, attach exports to a GitHub Release if you need distributable artifacts.
- **Compressed archive files** (`.zip`, `.7z`, `.gz`, `.rar`, `.tar`, etc.) — broadly git-ignored as of v0.3.6 to prevent large binary exports from entering the repo.
- **Spreadsheet and data list files** (`.csv`, `.xlsx`, `.xls`, `.ods`, `.tsv`, etc.) — broadly git-ignored as of v0.3.6 to prevent PII or sensitive VA data from being committed accidentally. Use `!path/to/file` negation entries in `.gitignore` to selectively expose sanitized public-facing files.
- **Configuration, runbooks, and tooling** under `config/` — fully git-ignored as of v0.3.6 (previously only `config/local/` was excluded). The 3 currently-tracked files (`ARCHITECTURE.md`, `ALM-RUNBOOK.md`, `alm.ps1`) remain in the remote repo pending a follow-up `git rm --cached -r config/`.
- **Local-only history snapshots** under `archive/` and local notes under `docs/local/` (git-ignored).
- **Secrets or environment-specific values** — use `config/local/` (git-ignored) and environment variables.
- **IDE caches** (`.vs/` folder removed in v0.2.0 and now git-ignored).

## Current data model (baseline)

The current baseline artifacts are driven by SharePoint lists with a desk/reservation-style schema:

- `Desk Reservations`
- `DeskAccessControl`
- `Desks`

The Canvas app now contains 21 screens (v0.3.4 replaced `scrn_WeeklyCal_1` with `scrn_DailyCal`). The screen and list naming still reflects the original desk/room reservation terminology in some areas. Renaming/re-modeling fields and labels to fully training-centric terminology is an expected future change.

### Canvas app access control model (v0.3.4)

As of v0.3.4, the Canvas app enforces role-based access control driven by the `DeskAccessControl` SharePoint list's `AccessLevel_Text` column. Valid access levels are: `SuperUser`, `AppAdmin`, `Manager`, `ServiceChief`, `ProjectLeader`, `User`, `View-only`, `AccessDenied`. Each user's row in `DeskAccessControl` must have this column populated for full role enforcement.

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

- Populate `DeskAccessControl` list with correct `AccessLevel_Text` values for all intended users to activate the v0.3.4 RBAC system.
- Complete the cancellation workflow — `Button3_9` ("Cancel This") in `MyAppts` is stubbed; the actual `Patch`/delete logic to mark a reservation as cancelled in SharePoint needs to be wired up.
- Continue replacing baseline "desk reservation" terminology with training-booking-centric labels throughout all screens and SharePoint columns.
- Evaluate adding SharePoint column `Active_choice` population on booking creation so the past/active filter works consistently from day one.
- Consider adding a user-facing in-app notification or email confirmation on successful booking cancellation.
- See [`docs/local/futureEnhancementIdeas.md`](local/futureEnhancementIdeas.md) for the full future improvement backlog.
- Add/expand component-level documentation as flows/app screens evolve.
- Develop user guides under `docs/userGuides/`.
- Evaluate additional Power Automate flows for the training scheduling workflow.
