# EHRM Training & Booking App

This repository contains the source (unpacked) Microsoft Power Platform artifacts, documentation, and automation for the EHRM Training & Booking App used at Edward Hines Jr. VA Hospital (Station #578), VISN12, U.S. Department of Veterans Affairs.

## Key folders
- src/ — Unpacked, human-readable source for Power Apps (Canvas), Power Automate flows, SharePoint list schemas/formatting, SQL, scripts.
- src/config/ — Environment templates and local-only settings (src/config/local/ is git-ignored).
- src/tools/ — Helper scripts and utilities (e.g., PAC helpers).
- src/tests/ — Test scaffolds (unit, script tests).
- docs/ — User guides, changelogs, developer notes, architecture, runbooks.
- dist/ — Exports/binaries used for import (kept local; not committed).
- archive/ — Calendar-versioned historical snapshots (optional, public).
- .github/workflows/ — CI automation for packing/validation.
- .vscode/ — Shared workspace settings and tasks.

## Daily workflow (summary)
1. Make changes in Dev environment (web editor), inside a Solution when possible.
2. Export Solution (or .msapp) to dist/release.
3. Unpack to src/... (overwrite/clean so only latest source is present).
4. Use Copilot Agent to summarize changes, update docs, propose commit message.
5. Commit src/ and docs/, tag release (semantic version).
6. Create a GitHub Release and optionally attach the export.
