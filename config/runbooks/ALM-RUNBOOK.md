# ALM Runbook

This runbook captures the typical export → unpack → review loop for this repository.

## Prerequisites

- Power Platform CLI (`pac`) installed and available on your PATH.
- Access to the target Power Platform environment (Dev/Test/Prod as applicable).
- A working Power Platform Solution containing the Canvas app and flows (recommended).

## Local-only export artifacts

Export artifacts are intentionally stored locally and **not committed** to Git.

Recommended local paths:

- Solution (unmanaged) export: `dist/release/EHRMTrainingBooking_Solution.zip`
- Canvas app package export: `dist/release/EHRMTrainingBookingApp.msapp`

These locations are git-ignored by design (see `.gitignore`).

## Unpack to source-controlled folders

Unpack artifacts into canonical, reviewable source locations:

- Solution: unpack to `config/solutions/EHRMTrainingBooking/` with `--overwrite`
- Canvas app: unpack to `src/powerApps/.unpacked/` with `--force`

Tip: use the VS Code tasks in [.vscode/tasks.json](../../.vscode/tasks.json) for these `pac` operations.

## Review & sanitize

Unpacked Power Platform artifacts can contain environment-specific identifiers and internal values.

Before publishing changes broadly:

- Review unpacked artifacts for environment-specific IDs/URLs/emails.
- Keep local-only artifacts in `dist/`, `tmp/`, and `archive/` (git-ignored).
- Keep local environment configuration in `config/local/` (git-ignored).

## Pack (optional)

If you need to regenerate a Canvas `.msapp` from unpacked source:

- Pack Canvas app from `src/powerApps/.unpacked/` into your chosen local `.msapp` path.

## Commit + release (manual)

This repo uses a manual release workflow:

1. Update root [CHANGELOG.md](../../CHANGELOG.md)
2. Update release drafts under `docs/release-notes/`
3. Commit tracked sources (`src/`, `config/`, `docs/`, `.github/`, `.vscode/`)
4. Tag the release (ex: `v0.1.1`) and create a GitHub Release
5. (Optional) Attach export artifacts from local `dist/release/`
