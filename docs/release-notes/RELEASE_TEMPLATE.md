# Release Notes Template

Use this template for GitHub Releases for the **EHRM Training & Booking App**. Draft content should align with the root [CHANGELOG.md](../../CHANGELOG.md).

## Version

- Tag: `vX.Y.Z`
- Date: `YYYY-MM-DD`
- Release type: Feature / Maintenance / Fix / Security

## Summary

(1 paragraph: what changed, why it matters, who it impacts.)

## Highlights

- (3–6 bullets)

## Changes

### Added

### Changed

### Fixed

### Security

## Upgrade / ALM notes (maintainers)

- Export artifacts are stored locally under `dist/release/` (git-ignored).
- Unpack locations:
  - Canvas app → `src/powerApps/.unpacked/`
  - Solution zip → `config/solutions/EHRMTrainingBooking/`
- VS Code tasks: see [../../.vscode/tasks.json](../../.vscode/tasks.json)

## Assets (optional)

- Attach `EHRMTrainingBooking_Solution.zip` and/or `EHRMTrainingBookingApp.msapp` from `dist/release/`.

## Verification

- Link checks completed
- `pac` export/unpack commands run (if applicable)
- Sanitization review complete (no secrets/PII/environment IDs)
