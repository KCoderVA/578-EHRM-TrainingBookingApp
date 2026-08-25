# EHRM Training & Booking App (Station 578)

[![Release](https://img.shields.io/badge/release-v1.0.12-blue)](CHANGELOG.md)

This repository contains the **unpacked (source-controlled)** Microsoft Power Platform assets, documentation, and ALM helpers for the EHRM Training & Booking App used at Edward Hines Jr. VA Hospital (Station #578), VISN12.

## Current versions

- **Project release (repo)**: v1.0.12 (2026-08-25) — first production / go-live release line — see [CHANGELOG.md](CHANGELOG.md)
- **Canvas app (component)**: v1.0.12 *(public)* — v0.12.2 → v1.0.12: removed impersonation backdoor, hardened RBAC (default-to-`User`), single-student proxy registration, Learning Labs Library class picker, binding errors 120 → 0, partial modern-control migration; removed dead `CreateMeeting`/`Screen3` screens — see [src/powerApps/README.md](src/powerApps/README.md) and [src/powerApps/v1.0.12_differenceAnalysis.md](src/powerApps/v1.0.12_differenceAnalysis.md)
- **Power Automate (component)**: `AppUserList` (unchanged) + `SendReminders` (updated — email **+ Teams card**) + **`CreateBackups`** *(new — email-triggered backup-reservation flow)* — see [src/powerAutomate/README.md](src/powerAutomate/README.md)
- **SharePoint**: app lists + new national EHRM **Sandbox Resource Center** reference lists/library — see [src/sharePoint/README.md](src/sharePoint/README.md)
- **Analytics**: Power BI `Signup Tool` + new `SuperUserDashboard-Final` (WIP) + new `tms/` data staging — see [src/analytics/README.md](src/analytics/README.md)

## Repository layout

- [src/](src/) — unpacked, human-reviewable source artifacts
  - Canvas app: [src/powerApps/](src/powerApps/) (unpacked source lives under `.unpacked/`)
  - Power Automate: [src/powerAutomate/](src/powerAutomate/)
  - SharePoint lists/search config: [src/sharePoint/](src/sharePoint/)
  - Analytics (Power BI, SQL & TMS): [src/analytics/](src/analytics/)
  - Scripts/hooks: [src/scripts/](src/scripts/)
- `config/` — architecture notes, runbooks, environment templates, and tooling helpers *(git-ignored as of v0.3.6; local-only)*
- [docs/](docs/) — public project docs (status, release notes, security, contributors)
- [assets/](assets/) — images/branding used by docs

Local-only (git-ignored): `dist/`, `tmp/`, `archive/`, `config/`, and `docs/local/`. Data files (`.csv`, `.xlsx`, etc.) and compressed archives (`.7z`, `.gz`, etc.) are also broadly git-ignored — see [`.gitignore`](.gitignore).

## Quick start (maintainers)

Prerequisites:
- Power Platform CLI (`pac`)
- Access to the target Power Platform environment (to export Solution / Canvas app)
- VS Code (optional, but recommended — tasks are preconfigured)

Typical loop:
1. Export artifacts to `dist/release/` (local-only).
2. Unpack to source:
   - Canvas app → `src/powerApps/.unpacked/`
   - Solution zip → `config/solutions/EHRMTrainingBooking/` *(local-only; git-ignored as of v0.3.6)*
3. Review diffs and sanitize environment-specific values.
4. Update docs (README/changelog/release drafts).
5. Commit and tag the release.

VS Code tasks are defined in [.vscode/tasks.json](.vscode/tasks.json).

## Documentation

- Project status / release readiness: [docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md)
- Architecture overview: `config/architecture/ARCHITECTURE.md` *(local-only; git-ignored as of v0.3.6)*
- ALM runbook: `config/runbooks/ALM-RUNBOOK.md` *(local-only; git-ignored as of v0.3.6)*
- Release drafts and templates: [docs/release-notes/](docs/release-notes/)
- Security policy: [.github/SECURITY.md](.github/SECURITY.md)
- Contributors / provenance: [docs/CONTRIBUTORS.md](docs/CONTRIBUTORS.md)

## Public repo hygiene (important)

Unpacked Power Platform artifacts frequently contain environment-specific identifiers and org/internal values:

- tenant IDs, environment IDs
- SharePoint site URLs
- connector connection references
- email addresses and display names

Before publishing changes broadly, review/sanitize unpacked sources under `src/` and keep secrets/PII out of Git.
See the security policy: [.github/SECURITY.md](.github/SECURITY.md).

## Credits / provenance (baseline)

This project started from template artifacts that will be heavily modified:

- Canvas Power App baseline `.msapp` and sanitized SharePoint list samples were provided by a VA Health Informatics contributor (credited in [docs/CONTRIBUTORS.md](docs/CONTRIBUTORS.md)).
- The initial `AppUserList` Power Automate flow template was authored by the repository maintainer and adapted here as the first baseline flow.

## Contributing

- Guidelines: [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md)
- Code owners: [.github/CODEOWNERS](.github/CODEOWNERS)

## License

Licensed under the Apache License, Version 2.0 — see [LICENSE](LICENSE). All source files carry the Apache 2.0 header (`Copyright 2025-2026 Coder, Kyle J. (github.com/KCoderVA)`).
