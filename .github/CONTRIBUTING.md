# Contributing

Thanks for your interest in contributing to the **EHRM Training & Booking App**.

This repository contains **unpacked (source-controlled)** Microsoft Power Platform artifacts (Canvas app + Power Automate), along with documentation and ALM runbooks.

## Before you start

- Read the project overview in [README.md](../README.md).
- Review the security policy in [SECURITY.md](SECURITY.md).
- If you are unsure whether a change is appropriate for this repo, open an Issue first.

## Repository layout

- [src/](../src/) — unpacked Power Platform artifacts (Canvas app, flows, SharePoint samples, scripts)
- [config/](../config/) — architecture/runbooks + environment templates + helper tooling
- [docs/](../docs/) — public documentation (status, release drafts/templates, contributors)
- [assets/](../assets/) — branding/images used by docs

Local-only (git-ignored): `dist/`, `tmp/`, `archive/`, and `docs/local/`.

## Development workflow (Power Platform)

Because the Power Platform authoring experience is environment-backed, the repo workflow typically looks like:

1. Make changes in your Dev environment (preferably inside a Solution).
2. Export artifacts locally to `dist/release/` (git-ignored).
3. Unpack into reviewable source:
   - Canvas app → `src/powerApps/.unpacked/`
   - Solution zip → `config/solutions/EHRMTrainingBooking/`
4. Review diffs and sanitize environment-specific values.
5. Update documentation and release notes.
6. Open a Pull Request.

VS Code tasks for the export/unpack workflow are defined in [.vscode/tasks.json](../.vscode/tasks.json).

## What not to commit

Do **not** commit:

- Secrets, credentials, tokens, connection strings, or PII
- Export artifacts (`.msapp`, Solution `.zip`) — keep under `dist/` (git-ignored)
- Local notes/snapshots under `docs/local/` and `archive/` (git-ignored)
- Local environment configuration under `config/local/` (git-ignored)

## Versioning

- **Project release version** uses SemVer (`MAJOR.MINOR.PATCH`) and is tracked in [CHANGELOG.md](../CHANGELOG.md).
- **Component versions** (Canvas app, each flow) are tracked in the component README files under `src/`.

## Pull requests

- Use the PR template (see [PULL_REQUEST_TEMPLATE.md](PULL_REQUEST_TEMPLATE.md)).
- Include validation steps and note whether you ran `pac` export/unpack.
- Confirm you reviewed unpacked sources for environment-specific IDs/URLs/emails.
- Update [CHANGELOG.md](../CHANGELOG.md) and relevant docs when appropriate.

## Reporting security issues

Please do not open public issues for security vulnerabilities.
Use a GitHub Security Advisory (see [SECURITY.md](SECURITY.md)).
