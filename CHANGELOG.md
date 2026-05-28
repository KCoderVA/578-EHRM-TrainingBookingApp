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
