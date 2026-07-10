<!--
   Copyright 2025 Coder, Kyle J. (github.com/KCoderVA)

   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
-->

<!--
    PULL REQUEST TEMPLATE — EHRM Training & Booking App
    -----------------------------------------------------
    HOW TO USE:
        1. Fill in every {{PLACEHOLDER}} — search for "{{" to find them all.
        2. Add/remove rows in the "Changes at a glance" table to match what changed.
        3. Add/remove numbered sections under the "detailed breakdown" to match the number of distinct change areas in this release.
        4. Complete the "Verification checklist" — add or remove items to match what is actually verifiable for this release.
        5. Delete these comment blocks and any sections marked "(delete if none)" before publishing the PR.

    PULL REQUEST TITLE FORMAT:
        PR vX.Y.Z - Component/Area: brief headline of changes
    PULL REQUEST FILE PATH:
        ./docs/release-notes/vX.Y.x/vX.Y.Z/vX.Y.Z_pullRequest.md
-->

# PR: v{{VERSION}} — {{Component/area}}: {{brief, comma-separated headline of the 2–4 most important changes}}

## Summary

This PR delivers the **v{{VERSION}}** {{feature/maintenance/patch/security}} release{{— a brief one-line elevator pitch of why this release matters}}. {{1–2 sentences on how the changes were made: e.g., the Canvas app was updated hands-on in the Power Apps editor, re-exported as `v{{VERSION}}_578EHRMTrainingApp.msapp`, and unpacked into `src/powerApps/.unpacked/` via `pac canvas unpack`.}} All project documentation has been updated end-to-end to reflect the new version.

{{If a component version advances — otherwise delete this line:}}
The {{Component name}} component version advances from **v{{PREVIOUS_COMPONENT_VERSION}} → v{{VERSION}}**{{, now permanently aligned with the project-wide SemVer release version.}}

---

## Changes at a glance

| Area | What changed |
|------|--------------|
| `src/{{component}}/.unpacked/` (or equivalent) | {{Full source update — see breakdown below / specific description}} |
| `src/{{component}}/.msapp/` (or equivalent) | {{New package: `v{{VERSION}}_578EHRMTrainingApp.msapp` (local-only, git-ignored)}} |
| `src/{{component}}/README.md` | {{Complete rewrite / partial update}} for v{{VERSION}} |
| `assets/screenshots/` | {{N}} screenshots renamed `v{{OLD_PREFIX}}_*` → `v{{VERSION}}_*`{{; `oldScreenName` → `newScreenName`}} |
| `VERSION` | {{PREVIOUS_VERSION}} → {{VERSION}} |
| `README.md` | {{Badge + version references updated / describe changes}} |
| `CHANGELOG.md` | [{{VERSION}}] entry added |
| `docs/PROJECT_STATUS.md` | {{describe what was updated: status summary, RBAC model, release history, roadmap}} |
| `docs/release-notes/v{{VERSION_MAJOR_MINOR}}.x/v{{VERSION}}/` | New release artifact folder (release notes, commit message, PR) |
| `{{docs/local/optionalNewFile.md}}` | {{purpose — delete row if none}} |

---

## {{Component name}} changes — detailed breakdown

### 1. {{Major Change Area 1 — short descriptive title}}

{{Narrative description of what changed, why, and how. Include any relevant technical details, formula excerpts, or before/after comparisons. Describe the user-visible behavior change for functional areas.}}

{{If an admin or environment action is required before deployment, add this callout:}}
> **Admin action required before deploying:** {{Describe exactly what must be done in the environment — e.g., populate a SharePoint column, reset a connection, run a script — before this release is safe for production.}}

### 2. {{Major Change Area 2 — short descriptive title}}

{{Narrative description. Use sub-bullets for lists of new controls/options/behaviors. Use a before/after table if values changed significantly.}}

- {{Sub-item: describe specific behavior or control}}
- {{Sub-item: describe specific behavior or control}}

### 3. {{Major Change Area 3 — short descriptive title}}

{{Narrative description.}}

### 4. {{Major Change Area 4 — short descriptive title (delete if fewer areas)}}

{{Narrative description.}}

<!-- Add/remove numbered sections above to match the number of distinct change areas.
     Aim for 1 section per logical grouping, not per file. -->

---

## Known issues / follow-up items (delete section if none)

- **{{Control or feature name — incomplete}}:** {{Describe what is partially implemented, what guard is in place (e.g., `Visible = false`, disabled button), and what future work is needed to complete it.}}
- **{{Error count or validation warning}}:** {{Describe the error (e.g., BindingErrorCount: N), its likely cause, and recommended next step before production deployment.}}
- **{{Data/config prerequisite}}:** {{Describe any SharePoint list columns, permission assignments, or environment settings that must be in place before users can use the new functionality.}}

---

## Verification checklist

- [ ] `VERSION` file reads `{{VERSION}}`
- [ ] `README.md` badge shows v{{VERSION}}; {{component}} version shows v{{VERSION}}
- [ ] `CHANGELOG.md` has a `[{{VERSION}}]` entry with Added, Changed, Removed{{, Notes}} sections
- [ ] `src/{{component}}/README.md` reflects v{{VERSION}} with updated {{screen count / flow count / etc.}}, version history, screenshots table
- [ ] `docs/PROJECT_STATUS.md` shows v{{VERSION}} status summary and updated release history row
- [ ] {{Specific new artifact check — e.g., `src/powerApps/.unpacked/Src/scrn_NewScreen.fx.yaml` exists}}
- [ ] {{Specific removed artifact check — e.g., `src/powerApps/.unpacked/Src/scrn_OldScreen.fx.yaml` does NOT exist}}
- [ ] `assets/screenshots/` — all {{N}} files have `v{{VERSION}}_` prefix{{; `newScreenName` file present, `oldScreenName` absent}}
- [ ] `docs/release-notes/v{{VERSION_MAJOR_MINOR}}.x/v{{VERSION}}/` folder contains all 3 artifact files
- [ ] {{Any other new files expected — e.g., `docs/local/newFile.md` exists}}
- [ ] No `.msapp` files accidentally staged (git-ignored by design)
- [ ] No PII, GUIDs, tenant IDs, or internal URLs visible in staged `src/` diffs
- [ ] `git status` is clean before tagging
