# Copilot Instructions (GitHub context)

## Purpose

Guide GitHub Copilot and Copilot Chat to help with ALM tasks, documentation, and code reviews.

## Focus Areas

- Read unpacked source in src/.
- Propose root-level CHANGELOG.md entries.
- Suggest semantic version tags and Release notes.
- Assist with pac commands for export/unpack/pack.
- Keep root clean; prefer src/config, src/tools, src/tests (exception: CHANGELOG.md, README.md).

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
- Do not introduce new top-level files unless necessary; prefer `src/config`, `src/tools`, `src/tests`.
- When moving content out of versioned subfolders into stable paths, ensure documentation updates reflect the new canonical location.
