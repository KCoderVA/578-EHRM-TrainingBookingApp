# Power Automate Flow: AppUserList

**Flow (component) version**: v0.1.1 (current)

## Purpose

This flow watches for new or updated entries in the access-control SharePoint list (local sanitized sample: `src/sharePoint/list/deskAccessControl/local/DeskAccessControl.csv`).

When a user’s email and access level are added/changed by an admin, the flow populates other list columns using Microsoft 365 (Azure AD) user profile data (ex: display name, manager). The Canvas app uses the SharePoint column `AccessLevel_Choice` to dynamically enable/disable app functionality and views.

## Artifacts in this folder

- `.zip/flowAppUserList_578EHRMTrainingApp.zip`
  - Packaged export artifact downloaded from Power Automate.
- `.json/v0.12.2_578EHRMTrainingApp_AppUserList.json`
  - JSON export (template-like) downloaded from Power Automate.
- `.unpacked/`
  - Unpacked source generated from the export (includes the flow `definition.json` under `.unpacked/Microsoft.Flow/flows/...`).

## What changed in v0.1.1 (re-export at project v0.12.3)

- Re-exported from Power Automate; connection/API/manifest maps refreshed (`apisMap.json`, `connectionsMap.json`, `manifest.json`, `definition.json`).
- The `.json` export was renamed with the `v0.12.2_` project-version prefix to match the repository's versioned-artifact naming convention.

## What changed in v0.1.0 (compared to archived v0.0.1)

- Updated/rebranded flow naming and user-facing message text to align to the “578 EHRM Training App” context (vs earlier baseline template naming).
- Improved failure handling / notifications (adds clearer automation-failure email/subject wording).
- Minor behavior tuning in the Teams notification branch (adds a brief delay step before posting in Teams).

## Provenance / archived baseline

- The original baseline/template version (v0.0.1) is retained by maintainers as a local-only snapshot under `archive/` (git-ignored) and is not present in the public repository.

## Important note (public repo)

The unpacked flow definition can include environment-specific identifiers and internal URLs/emails from the source environment. Review and sanitize as appropriate before publishing broadly.
