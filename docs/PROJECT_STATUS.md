# Project Status

This document describes the current public state of the EHRM Training & Booking App repository and what is included/excluded for release `v0.1.1`.

## Status summary (v0.1.1)

- **Release type**: documentation + repository readiness (no Power Platform logic changes intended)
- **Project release**: v0.1.1 (2026-05-28)
- **Component baselines**:
  - Canvas app: v0.0.2 (source-controlled unpacked source under `src/powerApps/.unpacked/`)
  - Power Automate: `AppUserList` v0.1.0 (source-controlled unpacked source under `src/powerAutomate/AppUserList/.unpacked/`)
  - SharePoint samples: `src/sharePoint/` (sanitized CSVs)

## What is in this repository

- Unpacked sources (for code review/diffing) for the Power Apps Canvas app and Power Automate flows.
- Documentation and runbooks for the export/unpack workflow.
- VS Code task definitions for common Power Platform CLI operations.

## What is intentionally NOT in this repository

- Export artifacts such as Solution `.zip` files and Canvas `.msapp` packages.
  - These are stored locally under `dist/` and are git-ignored by design.
  - For releases, attach exports to a GitHub Release if you need distributable artifacts.
- Local-only history snapshots under `archive/` and local notes under `docs/local/` (git-ignored).
- Secrets or environment-specific configuration; use `config/local/` (git-ignored) and environment variables.

## Current data model (baseline)

The current baseline artifacts are driven by SharePoint lists with a desk/reservation-style schema:

- `Desk Reservations`
- `DeskAccessControl`
- `Desks`

The Canvas app screens and flow behavior still include this baseline terminology. Renaming/re-modeling to training-specific naming is an expected future change.

## Release readiness checklist

Before tagging/publishing a release:

1. Ensure `git status` is clean and no ignored/local-only files are staged.
2. Scan unpacked sources under `src/` for:
   - tenant/environment IDs
   - internal URLs
   - email addresses
   - secrets/tokens
3. Confirm sample SharePoint CSVs are sanitized (no PII).
4. Update the root [CHANGELOG.md](../CHANGELOG.md) and the release drafts under [docs/release-notes/](release-notes/).
5. Export updated `.msapp` / Solution zip to `dist/release/` if you plan to attach assets.

## Next steps / roadmap (high level)

- Continue replacing baseline “desk reservation” terminology with training booking terms where appropriate.
- Add/expand component-level documentation as flows/app screens evolve.
