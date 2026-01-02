# Changelog

All notable changes to the EHRM Training & Booking App project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- (Future changes will be tracked here before being released)

### Changed
- (Future modifications will be tracked here)

### Fixed
- (Future bug fixes will be tracked here)

---

## [0.0.1] - 2025-12-31

### Added - Initial Project Baseline

#### Repository Structure & Configuration
- Initialized Git repository with main branch
- Created comprehensive folder hierarchy under `src/` for Power Platform artifacts
- Established `docs/` structure for architecture, changelogs, developer notes, runbooks, and user guides
- Created `archive/` for historical snapshots and initial request documentation
- Configured `.vscode/` workspace settings and tasks for Power Platform CLI operations
- Set up `.github/` folder with copilot instructions for ALM guidance

#### Power Apps (Canvas)
- Imported baseline canvas app template (v0.0.1) shared by **Hiram A. Zayas** (Hiram.Zayas@va.gov), Health Informatics Service, Battle Creek VA Medical Center
- Stored original `.msapp` package at `src/powerApps/.msapp/v0.0.1_578TrainingSchedulerApp.msapp`
- Unpacked canvas app source to `src/powerApps/.unpacked/` using Power Platform CLI
  - 21 screens including Dashboard, MyAppts, DeskSelect, Confirm, ManageDesks, Reservation, and others
  - Connectors: Office 365 Outlook, Office 365 Users, SharePoint
  - Data sources: Desk Reservations, DeskAccessControl, Desks (SharePoint lists)
- Created `src/powerApps/README.md` documenting app structure, screens, and provenance

#### Power Automate
- Imported baseline flow template `AppUserList` (originally authored by Kyle.Coder@va.gov for previous project)
- Stored flow package at `src/powerAutomate/AppUserList/importedTemplate/.zip/578TeleHealthSched_AppUserList.zip`
- Unpacked flow source to `src/powerAutomate/AppUserList/importedTemplate/.unpacked/`
- Flow purpose: Auto-populate user demographics from Active Directory when new users added to access control SharePoint list
- Created `src/powerAutomate/README.md` and `src/powerAutomate/AppUserList/README.md` documenting flow behavior and authorship

#### SharePoint Lists (Sample Data)
- Imported sanitized CSV sample data (PII/sensitive data removed) for three SharePoint lists:
  - `src/sharePoint/lists/Desk Reservations/Desk Reservations.csv`
  - `src/sharePoint/lists/DeskAccessControl/DeskAccessControl.csv`
  - `src/sharePoint/lists/Desks/Desks.csv`
- Sample data shared by Hiram A. Zayas to support local development and testing

#### Documentation
- Created root `README.md` with project overview, folder structure, daily ALM workflow, and template provenance credits
- Created `docs/changeLogs/CHANGELOG.md` (this file) following Keep a Changelog format
- Created `docs/architecture/ARCHITECTURE.md` for system design documentation
- Created `docs/runbooks/ALM-RUNBOOK.md` for application lifecycle management procedures
- Created `docs/developerNotes/AGENTS.md` for development guidance
- Created `.github/copilot-instructions.md` to guide GitHub Copilot for ALM tasks, documentation, and code reviews

#### Development Infrastructure
- Created `src/config/` structure with subdirectories for environment configs (dev/test/prod), local settings, templates, and tests
- Created `src/tools/pac/alm.ps1` for Power Platform CLI helper scripts
- Created `src/scripts/` structure with subdirectories for PowerShell, Python, JavaScript, and Git hooks
- Created `src/tests/` structure with subdirectories for unit tests and test scripts
- Established placeholder directories for future SQL queries, stored procedures, and web resources (CSS/HTML/JS)

#### VS Code Tasks (Power Platform CLI)
- Task: "Canvas: Unpack .msapp to src" - unpacks canvas app from dist/release to src/powerApps
- Task: "Canvas: Pack src to .msapp" - packs canvas app source to dist/release
- Task: "Solution: Export (unmanaged) to dist" - exports Power Platform solution from environment
- Task: "Solution: Unpack zip to src" - unpacks solution to src/solutions folder

#### Archive
- Preserved initial project request documentation in `archive/initialRequest/`
- Archived early workspace setup prompt and template files
- Created `archive/docs/local/` for historical documentation snapshots

### Notes
- This version establishes the complete initial baseline for the EHRM Training & Booking App
- All imported template artifacts (PowerApps, Power Automate, SharePoint lists) will be heavily modified in future versions
- Environment-specific identifiers (tenant IDs, SharePoint URLs, emails) exist in unpacked sources and should be reviewed before broad public distribution
