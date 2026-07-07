## S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp\.github\copilot-instructions.md

# Copilot Instructions (GitHub context)

## Purpose

Guide GitHub Copilot and Copilot Chat to help with ALM tasks, documentation, and code reviews.

See also: `copilot-snippets.md` for reusable prompt/playbook snippets.

## Focus Areas

- Read unpacked source in src/.
- Assist with pac commands for export/unpack/pack.
- Keep root tidy; prefer `src/` (unpacked artifacts), `config/` (runbooks/templates/tools), `docs/` (documentation), `archive/` (local backup copies), and `tmp/` (temporary local developer-only files).

## PowerShell Terminal Rule (Required)

**Status**: Temporary workaround for VS Code Copilot Chat issue
**Issue**: `run_in_terminal` tool prepends `^U` character to first command in newly-created terminals
**Affects**: Only Copilot Chat terminal launches (not manual terminal launches)
**Workaround**: AI agent MUST run a harmless initialization command first before executing any actual command
**Delete When**: Issue is resolved upstream in VS Code or Copilot Chat infrastructure

### CRITICAL: Agent Behavior Requirement

⚠️ **This is NOT automatic.** Copilot Chat will read this file, but the behavior must be explicitly implemented by the agent.
When using `run_in_terminal` to launch commands in a **new terminal**, the agent MUST:
1. **ALWAYS** execute a harmless initialization command FIRST
2. **THEN** execute the actual command in a subsequent `run_in_terminal` call
Harmless initialization command:

```powershell
Write-Host "init" | Out-Null
```
Then proceed with your actual command in a subsequent `run_in_terminal` call.

#### Example Agent Behavior using Powershell integrated terminal patterns

**CORRECT** (uses workaround):
```
First call:  run_in_terminal command="Write-Host 'init' | Out-Null" ...
Second call: run_in_terminal command="git clone ..." ...
```

**AVOID** (will fail with ^U prefix):
```
run_in_terminal command="git clone ..." ...  # First command in new terminal = fails
```
### Generalized PowerShell Terminal Guidance for Copilot/LLM
- Prefer running commands inside the existing integrated PowerShell session (avoid spawning new `pwsh -NoProfile ...` shells).
- This VS Code workspace's integrated PowerShell terminal uses the already customized and configured `PowerShell 7 (Shimmed)` terminal profile (located locally at file path "C:\Users\VHAHINCoderK1\OneDrive - Department of Veterans Affairs\Documents\PowerShell\Microsoft.PowerShell_profile.ps1".
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

## Releases, Tags, and Release Notes

- For **major or minor** project-wide updates, prepare:
  - A recommended git tag name (e.g., `vX.Y.Z`).
  - A concise set of release notes (can be derived from `CHANGELOG.md`).

- If asked to execute tagging/release steps:
  - Provide the exact `git tag` / `git push --tags` commands and/or the repo steps needed.
  - Do not publish a GitHub Release without explicit confirmation (agents should draft the release text and instructions).


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
