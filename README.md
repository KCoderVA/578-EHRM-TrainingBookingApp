# EHRM Training & Booking App

This repository contains the source (unpacked) Microsoft Power Platform artifacts, documentation, and automation for the EHRM Training & Booking App used at Edward Hines Jr. VA Hospital (Station #578), VISN12, U.S. Department of Veterans Affairs.

## Key folders

- src/ — Unpacked, human-readable source for [Power Apps (Canvas)](src/powerApps/README.md), Power Automate flows, SharePoint list schemas/formatting, SQL, scripts.
- src/config/ — Environment templates and local-only settings (src/config/local/ is git-ignored).
- src/tools/ — Helper scripts and utilities (e.g., PAC helpers).
- src/tests/ — Test scaffolds (unit, script tests).
- docs/ — User guides, changelogs, developer notes, architecture, runbooks.

### Project changelog

- See the root-level changelog for release notes and history: [CHANGELOG.md](CHANGELOG.md)

### Contributing & Ownership

- Contribution guidelines: [.github/CONTRIBUTING.md](.github/CONTRIBUTING.md)
- Code ownership rules: [.github/CODEOWNERS](.github/CODEOWNERS)
- Contributors list: [CONTRIBUTORS.md](CONTRIBUTORS.md)

### Acknowledgments

- Special thanks to **Hiram A. Zayas** (Health Informatics Service, Battle Creek VA Medical Center) for sharing the initial template Canvas Power App `.msapp` and sanitized SharePoint list samples that established the project baseline (v0.0.1 on 2025-12-31).

### Security

- See the security policy: [SECURITY.md](SECURITY.md)
- dist/ — Exports/binaries used for import (kept local; not committed).
- archive/ — Calendar-versioned historical snapshots (optional, public).
- .github/workflows/ — CI automation for packing/validation.
- .vscode/ — Shared workspace settings and tasks.

## v0.0.1 template provenance (credits)

This project intentionally starts from a set of template artifacts that will be heavily modified.

- **Canvas Power App template (shared source)**: The baseline canvas app source for v0.0.1 came from **Hiram A. Zayas** (Hiram.Zayas@va.gov), Health Informatics Service, Battle Creek VA Medical Center. He shared the original `.msapp` so this project did not have to start from scratch. The `.msapp` was then unpacked into source using the Power Platform CLI.
- **SharePoint list sample data (sanitized)**: Hiram also shared sanitized CSV exports for the connected SharePoint lists, stored under `src/sharePoint/lists/`.
- **Power Automate template (authored here)**: The initial flow under `src/powerAutomate/AppUserList/` was created by Kyle.Coder@va.gov for a previous project and imported here as the first baseline flow for v0.0.1.

## Public-repo hygiene note

Unpacked Power Platform artifacts frequently contain environment-specific identifiers and organization/internal URLs.

Before publishing changes broadly, review the unpacked sources for values like tenant IDs, SharePoint site URLs, app play URLs, and email addresses, and replace them with environment parameters or placeholders as appropriate.

## Daily workflow (summary)

1. Make changes in Dev environment (web editor), inside a Solution when possible.
2. Export Solution (or .msapp) to dist/release.
3. Unpack to src/... (overwrite/clean so only latest source is present).
4. Use Copilot Agent to summarize changes, update docs, propose commit message.
5. Commit src/ and docs/, tag release (semantic version).
6. Create a GitHub Release and optionally attach the export.

## Versions (project + components)

- **Project-wide release version**: tracked in the root [CHANGELOG.md](CHANGELOG.md).
- **Component versions**: tracked in each component’s `README.md` (examples: [src/powerApps/README.md](src/powerApps/README.md), [src/powerAutomate/AppUserList/README.md](src/powerAutomate/AppUserList/README.md)).

## Current source locations (stable paths)

- Canvas app (current): `src/powerApps/` (see [src/powerApps/README.md](src/powerApps/README.md))
- Power Automate flows (current): `src/powerAutomate/` (see [src/powerAutomate/README.md](src/powerAutomate/README.md))

Historical versions are kept as frozen snapshots under `archive/src/`.
