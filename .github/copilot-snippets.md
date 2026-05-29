# Copilot Snippets (Prompts & Playbooks)

This file is a reusable prompt/snippet library for GitHub Copilot Chat (Agent mode) in this repository.

## Archive-before-change (single file)

**Prompt**

Before editing any tracked file outside `archive/`, do the following:

1. Copy the current version into `archive/snapshots/YYYY-MM-DD/<original-relative-path>`.
2. If there are duplicates/competing copies, move superseded copies into `archive/superseded/YYYY-MM-DD/<original-relative-path>`.
3. Then apply the minimal tracked change to the canonical file.
4. Update links/docs that referenced the old path.

Constraints:

- Never delete anything; move to `archive/`.
- Never commit anything under `archive/`.

## Consolidate competing docs (policy files)

**Prompt**

Scan for competing community health/policy docs (root vs `.github` vs `docs/`), including:

- `SECURITY.md`, `CHANGELOG.md`, `README.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SUPPORT.md`, `LICENSE`

For each group:

- Choose the canonical location GitHub expects (usually root or `.github/`).
- Merge content into the canonical file using modern best practices.
- Move redundant copies into `archive/superseded/YYYY-MM-DD/<original-relative-path>`.
- Update any references to moved files.

## Power Platform ALM refresh (Solution + Canvas)

**Prompt**

Help me run an ALM refresh cycle:

1. Export Solution to `dist/release/`.
2. Unpack Solution to `src/config/solutions/<SolutionName>/`.
3. Unpack/pack Canvas app as needed (unpacked source lives under `src/powerApps/.unpacked/`).

Then:

- Summarize key diffs under `src/`.
- Update component README versions (where applicable).
- Remind me to archive the prior state under `archive/snapshots/YYYY-MM-DD/` before edits if I haven’t already.

<!-- DISABLED (2026-05-28): repo-management guidance temporarily deactivated.
- Add an entry under **[Unreleased]** in root `CHANGELOG.md`.
-->

<!--
DISABLED (2026-05-28): repo-management guidance temporarily deactivated.

## Changelog entry (Keep a Changelog)

**Prompt**

Based on the changes in this PR/workspace, draft a concise entry under **[Unreleased]** in root `CHANGELOG.md` using Keep a Changelog headings:

- Added / Changed / Fixed / Deprecated / Removed / Security

Keep bullets action-oriented and scoped (Power Apps / Flow / SharePoint / tooling).
-->

<!--
DISABLED (2026-05-28): repo-management guidance temporarily deactivated.

## Release prep

**Prompt**

Prepare release notes for version `vX.Y.Z`:

- Summarize changes from `CHANGELOG.md`
- Suggest a SemVer bump rationale
- Provide `git tag` commands (but do not publish a Release without confirmation)
-->

