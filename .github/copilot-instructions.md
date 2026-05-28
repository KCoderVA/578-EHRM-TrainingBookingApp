# Copilot Instructions (GitHub context)

## Purpose

Guide GitHub Copilot and Copilot Chat to help with ALM tasks, documentation, and code reviews.

See also: `copilot-snippets.md` for reusable prompt/playbook snippets.

## Focus Areas

- Read unpacked source in src/.
- Assist with pac commands for export/unpack/pack.
- Keep root tidy; prefer `src/` (unpacked artifacts), `config/` (runbooks/templates/tools), and `docs/` (documentation).

<!--
DISABLED (2026-05-28): repo-management guidance temporarily deactivated.

- Propose root-level CHANGELOG.md entries.
- Suggest semantic version tags and Release notes.
-->

## PowerShell Terminal Rule (Required)

- Prefer running commands inside the existing integrated PowerShell session (avoid spawning new `pwsh -NoProfile ...` shells).
- This repo configures a `PowerShell 7 (Shimmed)` terminal profile and an automation profile in `.vscode/settings.json` and the workspace `.code-workspace` file.
  - Both should run PowerShell 7 *without* `-NoProfile` and should explicitly dot-source `$PROFILE` (so functions/aliases/modules are available).
- Important: VS Code’s `shellIntegration.ps1` (under the VS Code install folder) is **not** your PowerShell profile. Do not treat it as the source of your dev environment.
  - Put your customizations in your normal PowerShell profile (`$PROFILE`) and/or a dedicated dev bootstrap script you control.
- If a session ever starts without your expected profile behavior, run `src/scripts/pwsh/Ensure-DevProfile.ps1` once per terminal session before running `pac`.
- Treat anything under `docs/local/`, `tmp/`, `dist/`, and `archive/` as local-only unless explicitly stated otherwise.

## Versioning Policy (Hybrid)

- Use a **project-wide release version** (SemVer) for the overall deployable bundle (typically the Power Platform Solution / repository release): `MAJOR.MINOR.PATCH`.
  - **MAJOR**: breaking changes (e.g., SharePoint schema/list/columns changes that break existing data/automation, incompatible connector contracts, breaking SQL/SP changes, incompatible app/flow behavior).
  - **MINOR**: new functionality that is backwards compatible.
  - **PATCH**: bug fixes / small tweaks that are backwards compatible.

- Also maintain **component-level versions** (SemVer) when useful (Canvas App, each Flow, SharePoint assets, SQL scripts/SPs, Power BI artifacts).
  - Component versions belong in the component’s `README.md` (and optionally in tags), not necessarily in the folder path.

## Folder Structure Expectations

- Prefer **stable “current” paths under `src/`** (no version-number buffer folders) for the active/public-facing source.
  - Example: keep current Flow export directly in `src/powerAutomate/AppUserList/`.
  - Only use version-number subfolders in `src/` when multiple versions must exist side-by-side for a real support/deployment reason.

- Prefer **archival snapshots under `archive/src/`** using version-number folders.
  - Example: `archive/src/powerAutomate/AppUserList/v0.0.1/` is the long-term frozen copy.

> Archive policy: `archive/` is intentionally **always** git-ignored and is used for local-only, long-term retention. Keep public-facing source outside `archive/` as a single newest “master” copy.

## Documentation Rules (Required)

- Every major subcomponent folder under `src/` should include (or keep) its own `README.md` documenting:
  - What the component is and what it does.
  - How it is built/exported/unpacked/packed (Power Platform ALM commands where relevant).
  - Current component version and a brief component-level change history.

- When a component changes, update its local `README.md` in the same PR/change set.

- When any changes are made that affect the repo as a whole, update:
  - Root `README.md` (overview, current “latest” versions, how to work with the repo).
  - Root `CHANGELOG.md` (add a clear entry describing changes).

<!--
DISABLED (2026-05-28): repo-management guidance temporarily deactivated.

## Releases, Tags, and Release Notes

- For **major or minor** project-wide updates, prepare:
  - A recommended git tag name (e.g., `vX.Y.Z`).
  - A concise set of release notes (can be derived from `CHANGELOG.md`).

- If asked to execute tagging/release steps:
  - Provide the exact `git tag` / `git push --tags` commands and/or the repo steps needed.
  - Do not publish a GitHub Release without explicit confirmation (agents should draft the release text and instructions).
-->

## Change Management Conventions

- Keep `src/` representing the **current** state; keep previous versions in `archive/`.
- Do not introduce new top-level files unless necessary; prefer `config/`, `docs/`, and `src/`.
- When moving content out of versioned subfolders into stable paths, ensure documentation updates reflect the new canonical location.

## Archive Naming & Structure Preferences (Required)

`archive/` is local-only, git-ignored, and used to preserve prior versions **before** updating tracked/public-facing files.

When archiving something, follow these rules:

- **Always preserve the original relative path** under an archive “bucket” so it’s easy to restore.
- Use **ISO dates** (`YYYY-MM-DD`) and optionally a time suffix (`HHmm`) when multiple snapshots happen in one day.
- Prefer **SemVer labels** when the archived copy corresponds to a release version.
- Include a short **notes file** (markdown or txt) when helpful, describing _why_ it was archived and what replaced it.

Recommended patterns:

- **Superseded duplicates / reorganizations** (moving competing docs/paths):
  - `archive/superseded/YYYY-MM-DD/<original-relative-path>`
  - Example: `archive/superseded/2026-02-03/.github/SECURITY.md`

- **Pre-change snapshots** (before modifying a file/folder that stays tracked):
  - `archive/snapshots/YYYY-MM-DD/<original-relative-path>`
  - Example: `archive/snapshots/2026-02-03/src/powerApps/README.md`

- **Release snapshots** (when archiving a known released state):
  - `archive/releases/vX.Y.Z/<original-relative-path>`
  - Example: `archive/releases/v0.1.0/src/powerAutomate/AppUserList/`

Notes file suggestion (optional but recommended):

- `archive/.../<same-folder>/_ARCHIVE_NOTES.md` with:
  - date, reason, what replaced it, and any environment/sanitization reminders
