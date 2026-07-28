<!--
   Copyright 2025 Coder, Kyle J. (github.com/KCoderVA)

   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
-->

## S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp\.github\copilot-instructions.md

# Copilot Instructions (GitHub context)

## Purpose

  - This is a **Power Platform** project with multiple components (Canvas App, Power Automate Flows, SharePoint Lists, Power BI, SQL scripts, etc.).
  -  **Project Name:** `578 EHRM Training & Booking App`
  -  **Local Workspace Path:** `S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp\`
  -  **Generated:** December 31, 2025
  -  **Project Migration to `https://va.ghe.com/software/578-EHRM-TrainingSchedulerApp` enterprise repo:** July 7, 2026

## Developer/Programmer Preferences

  - **Directory Names**: camelCase with simple or abbreviated names (e.g., `powerApps`, `powerAutomate`, `sharePoint`, `powerBI`, `sql`, or `scripts`)
  - **File Names**: camelCase with semantic versioning prefixes seperated by underscore (e.g., `v0.2.1_commitMessage.md` `v0.3.2_myFileName.ext`), EXCEPT FOR key project documentation artifacts that require all capitalized file names (e.g., `README.md`, `CHANGELOG.md`, `VERSION`, `PROJECT_STATUS.md`).
  - **Power Apps Names**: PascalCase with hyphens (`578-EHRM-Training-App`)
  - **Power Apps Variables**: camelCase
  - **Power Apps Controls & Objects**: Descriptive prefixes (btnSubmit, lblTitle, galItems)
  - **Power Automate Action Naming**: Descriptive names with business context (not "Compose 1", "Condition 2")
  - **Error Handling**: Try-catch patterns with parallel failure branches
  - **Performance**: Use parallel branches for independent operations
  - **Documentation**: Comments explaining business logic, especially in complex expressions
  - **SharePoint Lists Names**: PascalCase
  - **SharePoint Column Names**: PascalCase with descriptive names seperated by underscore to the column type (e.g., `TrainingDate_Date`, `UserEmail_Text`, `IsApproved_Boolean`)
  - **Software License Header**:  All source files must include the Apache 2.0 license header at the top of the file, which specifis the copyright date and author name (e.g., "Copyright 2025-07-02 Coder, Kyle J. (github.com/KCoderVA)").

## Repository Management Principles

  - **Versioning Control**: Check and update SemVer for project-wide releases and component-level versions in file names.
  - **CHANGELOG.md Requirements**: Update `CHANGELOG.md` so that the most recent changes are always at the top of the file and move all previous text down, so that `CHANGELOG.md` artifact continues to grow in size and serves as a chronological historical reference for all project changes to date.
  - **Commit Message Requirements**: Use the `commit_message-TEMPLATE.md` template for all commits, including a brief summary of the changes and any relevant context or references.
  - **Pull Request Requirements**: Use the `pull_request-TEMPLATE.md` template for all PRs, including a summary of the changes, a list of affected areas, and any relevant context or references.
  - **Release Notes Requirements**: Use the `release_notes-TEMPLATE.md` template for all releases, including a summary of the changes, a list of affected areas, and any relevant context or references.
  - **Tagging Requirements**: Tag each release with the corresponding SemVer (e.g., `v0.3.2`) and include a brief description of the changes in the tag message.
  - **Branching Strategy**: Use a consistent branching strategy (e.g., `main` for production, `develop` for development, feature branches for new features, hotfix branches for urgent fixes) and ensure that all branches are properly named and documented.

## **🏗️ Core Project/Workspace Components:**
  - **Power Apps Canvas App** (`src\powerApps\`) - Responsive mobile-first UI
  - **Power Automate Flows** (`src\powerAutomate\`) - Automated request approval routing, dynamic user access population, and AI safety chatbot integration
  - **SharePoint Lists** (`src\sharePoint\`) - Secure data storage with privacy controls and comprehensive audit trails
  - **Analytics** (`src\analytics\powerBI\`, `src\analytics\sql\`) - Power BI leadership dashboards/reports and SQL database scripts, stored procedures, and data integrity checks
  - **Developer Tools\Scripts** (`src\scripts\`) - PowerShell and other scripts for ALM, CI/CD, and environment management
  - **Power Platform Solution** (`src\solution.xml`) - Managed solution package with publisher prefix "vah" (VA Healthcare)

## Focus Areas

  - Read unpacked source in src/.
  - Assist with pac commands for export/unpack/pack.
  - Keep root tidy; prefer `src/` (unpacked artifacts), `config/` (runbooks/templates/tools), `docs/` (documentation), `archive/` (local backup copies), `assets/` (images, screenshots, icons, videos), and `.github/` (repo management, actions/workflows, documentation templates).

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
    2. **THEN** execute the actual command in a subsequent `run_in_terminal` call Harmless initialization command:
      ```powershell
      Write-Host "init" | Out-Null
      ```
    3. Then proceed with your actual command in a subsequent `run_in_terminal` call.

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

  - Use a **project-wide release version** (SemVer) for the overall deployable bundle (typically the Power Platform Solution / repository release): `MAJOR.MINOR.PATCH`:
    - **MAJOR**: breaking changes (e.g., SharePoint schema/list/columns changes that break existing data/automation, incompatible connector contracts, breaking SQL/SP changes, incompatible app/flow behavior).
    - **MINOR**: new functionality that is backwards compatible.
    - **PATCH**: bug fixes / small tweaks that are backwards compatible.
  - ALWAYS check and iterate on the version number in both `VERSION` and `CHANGELOG.md` before ALL commits, PR, and releases.
  - ALWAYS check and update the `.README.md` and `.CHANGELOG.md` and `docs/PROJECT_STATUS.md` to reflect the current version and any new changes.
  - Also maintain **component-level versions** (SemVer) in file names prefixes when useful (Canvas App, each Flow, SharePoint assets, SQL scripts/SPs, Power BI artifacts) identifying the project's current SemVer at the time of the each particular file's creation/modification, such as `MAJOR.MINOR.PATCH_{{file-name}}.{{file-type}}`.
    - Component versions belong in the component’s `README.md` (and optionally in tags), not necessarily in the folder path.
  - When any file/artifact needs to be updated or modified, create a duplicate archive version of the original file/artifact with the older **component-level version** file name prefix into the `archive/` folder (recreat the same subdirectory structure inside `archive/` that the original file exited in before copying) BEFORE making any changes to the tracked/public-facing live version of the newly updated file/artifact.

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
  - When a component changes, update its local component-specific `README.md` in the same PR/change set.
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

  - `archive/` is local-only, git-ignored, and used to preserve prior versions **before** updating tracked/public-facing files.
  - When archiving something, follow these rules:
    - **Always preserve the original relative path** under an archive “bucket” so it’s easy to restore.
    - Use **ISO dates** (`YYYY-MM-DD`) and optionally a time suffix (`HHmm`) when multiple snapshots happen in one day.
    - Prefer **SemVer labels** when the archived copy corresponds to a release version.
    - Include a short **notes file** (markdown or txt) when helpful, describing _why_ it was archived and what replaced it.

  - Recommended archive patterns:
    - **Superseded duplicates / reorganizations** (moving competing docs/paths):
      - `archive/superseded/YYYY-MM-DD/<original-relative-path>`
      - Example: `archive/superseded/2026-02-03/.github/SECURITY.md`
    - **Pre-change snapshots** (before modifying a file/folder that stays tracked):
      - `archive/snapshots/YYYY-MM-DD/<original-relative-path>`
      - Example: `archive/snapshots/2026-02-03/src/powerApps/README.md`
    - **Release snapshots** (when archiving a known released state):
      - `archive/releases/vX.Y.Z/<original-relative-path>`
      - Example: `archive/releases/v0.1.0/src/powerAutomate/AppUserList/`
    - Notes file suggestion (optional but recommended):
      - `archive/.../<same-folder>/_ARCHIVE_NOTES.md` with:
        - date, reason, what replaced it, and any environment/sanitization reminders

## U.S Department of Veterans Affairs "USGov" Power Platform Environment Reference

    | Parameter                | Value                                                                  |
    | ------------------------ | ---------------------------------------------------------------------- |
    | Environment ID           | e95f1b23-abaf-45ee-821d-b7ab251ab3bf                                   |
    | Tenant ID                | e95f1b23-abaf-45ee-821d-b7ab251ab3bf                                   |
    | Organization Unique Name | org34322538                                                            |
    | Organization Friendly    | Department of Veterans Affairs (default)                               |
    | Cloud                    | UsGov                                                                  |
    | Authority                | https://login.microsoftonline.com/e95f1b23-abaf-45ee-821d-b7ab251ab3bf |
    | User                     | Kyle.Coder@va.gov                                                      |
