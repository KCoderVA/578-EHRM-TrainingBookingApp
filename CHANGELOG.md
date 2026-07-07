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
