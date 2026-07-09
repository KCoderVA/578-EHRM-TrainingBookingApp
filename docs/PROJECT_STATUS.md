# Project Status

This document describes the current public state of the EHRM Training & Booking App repository and what is included/excluded as of the latest release.

## Status summary (v0.3.2)

- **Release type**: Patch — GHES compatibility fixes for release and version-bump workflows
- **Project release**: v0.3.2 (2026-07-07)
- **Component baselines** (unchanged since v0.0.2 / v0.1.0):
  - Canvas app: v0.0.2 (source-controlled unpacked source under `src/powerApps/.unpacked/`)
  - Power Automate: `AppUserList` v0.1.0 (source-controlled unpacked source under `src/powerAutomate/AppUserList/.unpacked/`)
  - SharePoint samples: `src/sharePoint/` (sanitized CSVs)

## Release history

| Version | Date | Type |
|---------|------|------|
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

- **Unpacked sources** (for code review/diffing) for the Power Apps Canvas app and Power Automate flows.
- **Documentation & runbooks**: [ARCHITECTURE.md](../config/architecture/ARCHITECTURE.md), [ALM-RUNBOOK.md](../config/runbooks/ALM-RUNBOOK.md), component-level READMEs, release notes.
- **VS Code workspace configuration**: task definitions for common PAC CLI operations (canvas pack/unpack, solution export/unpack), recommended extensions, editor settings.
- **Scripts & hooks**: PowerShell dev-profile bootstrap (`Ensure-DevProfile.ps1`), pre-commit/pre-push hooks.
- **SharePoint sample data**: sanitized CSVs under `src/sharePoint/`.
- **GitHub community files**: PR template, issue templates, security policy, contributing guide, Copilot instructions.

## What is intentionally NOT in this repository

- **Export artifacts** such as Solution `.zip` files and Canvas `.msapp` packages.
  - These are stored locally under `dist/` and are git-ignored by design.
  - For releases, attach exports to a GitHub Release if you need distributable artifacts.
- **Local-only history snapshots** under `archive/` and local notes under `docs/local/` (git-ignored).
- **Secrets or environment-specific configuration**; use `config/local/` (git-ignored) and environment variables.
- **IDE caches** (`.vs/` folder removed in v0.2.0 and now git-ignored).

## Current data model (baseline)

The current baseline artifacts are driven by SharePoint lists with a desk/reservation-style schema:

- `Desk Reservations`
- `DeskAccessControl`
- `Desks`

The Canvas app screens (21 screens from Dashboard through PDFScreen) and the `AppUserList` flow behavior still reference this baseline terminology. Renaming/re-modeling to training-specific naming is an expected future change.

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

- Continue replacing baseline “desk reservation” terminology with training booking terms where appropriate.
- Add/expand component-level documentation as flows/app screens evolve.
- Develop user guides under `docs/userGuides/`.
- Evaluate additional Power Automate flows for the training scheduling workflow.
