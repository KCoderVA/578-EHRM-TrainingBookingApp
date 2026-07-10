<!--
   Copyright 2025 Coder, Kyle J. (github.com/KCoderVA)

   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
-->

<!--
  COMMIT MESSAGE TEMPLATE — EHRM Training & Booking App
  -------------------------------------------------------
  HOW TO USE:
    1. Copy everything between the "--- BEGIN COMMIT MESSAGE ---" and
       "--- END COMMIT MESSAGE ---" markers below.
    2. Paste it as the body of your git commit message (or into a
       COMMIT_MESSAGE_DRAFT_*.txt file under docs/local/ before committing).
    3. Fill in every {{PLACEHOLDER}} — search for "{{" to find them all.
    4. Delete any sections that do not apply to this release
       (e.g., "Screen removals" if nothing was removed).
    5. Delete these comment blocks before committing.

  CONVENTIONAL COMMIT TYPES (use one for the title prefix):
    feat      — new functionality added
    fix       — bug fix
    docs      — documentation-only changes
    refactor  — code restructuring with no functional change
    chore     — maintenance, dependency bumps, tooling, CI/CD
    style     — formatting, whitespace (no logic change)
    perf      — performance improvement
    test      — adding or updating tests
    build     — build system or ALM changes (pac export/unpack/pack)

    SCOPE EXAMPLES (use the most specific that applies):
        canvas-app |
        power-automate |
        sharepoint |
        devops |
        scripts |
        docs |
        alm |
        ci |
        repo |

    COMMIT MESSAGE TITLE FORMAT:
        {{COMMIT_TYPE}}({{SCOPE}}): v{{VERSION}} — {{brief, comma-separated headline of the 2–4 most important changes}}
    PULL REQUEST FILE PATH:
        ./docs/release-notes/vX.Y.x/vX.Y.Z/vX.Y.Z_commitMessage.md
-->

<!-- =================== BEGIN COMMIT MESSAGE ==================== -->

{{COMMIT_TYPE}}({{SCOPE}}): v{{VERSION}} — {{brief, comma-separated headline of the 2–4 most important changes}}

## Context

This commit {{prepares/delivers/fixes}} the **EHRM Training & Booking App** repository for the **v{{VERSION}}** {{feature/maintenance/patch/security}} release{{— a brief one-line elevator pitch of why this release matters}}. {{1–2 sentences on how the changes were made: e.g., hands-on development in the Power Apps canvas editor, pac export/unpack, documentation-only pass, CI/CD update.}} The updated {{artifact, e.g., `.msapp` package}} (`v{{VERSION}}_578EHRMTrainingApp.msapp`) was {{action, e.g., unpacked via `pac canvas unpack`}} and the resulting source files under `{{src/path/to/files/}}` now reflect the v{{VERSION}} state.

{{If a component version advances — otherwise delete this line:}}
The {{Component name}} component version advances from v{{PREVIOUS_COMPONENT_VERSION}} → v{{VERSION}}{{, now aligned with the project-wide SemVer release version.}}

---

## What changed — {{Component name}} ({{src/path/to/files/}})

### Screen additions (delete section if none)
- `{{Src/scrn_ExampleNew.fx.yaml}}` — **NEW** {{Screen display name ("Screen Title")}}; {{brief description of layout and purpose}}

### Screen removals (delete section if none)
- `{{Src/scrn_ExampleOld.fx.yaml}}` — **REMOVED**, replaced by `{{scrn_Replacement}}`
- `{{Other/Src/scrn_ExampleOld.pa.yaml}}` — **REMOVED** (companion pa.yaml)

### {{File or Feature Area 1}} (e.g., App.fx.yaml / OnStart)
- {{Bullet: describe the specific property, formula, or behavior that changed and why.}}
- {{Bullet: include before → after values where useful (e.g., height 94→37, width 240→333).}}

### {{File or Feature Area 2}} (e.g., Dashboard.fx.yaml)
- `{{Property.OnVisible}}` {{completely refactored / updated}}: {{describe what was added, removed, or changed}}
- `{{Control.Property}}` {{old value}} → {{new value}}
- Added `{{ControlName}}` {{control type}} controls

### {{File or Feature Area 3}} (e.g., chkWeekDays.fx.yaml)
- `{{Property.OnVisible}}` — added `{{formula excerpt}}`
- `{{Property}}` {{old value}} → {{new value}}
- Added `{{ControlName1}}`, `{{ControlName2}}` {{control type}} controls

### {{CanvasManifest.json / solution manifest / equivalent}} (delete section if not applicable)
- `{{Property}}` {{old value}} → {{new value}}; `{{Property2}}` {{old}} → {{new}}
- Screen order: `{{OldScreen}}` → `{{NewScreen}}`
- Removed connector actions: `{{ActionName1}}`, `{{ActionName2}}`
- Added connector actions: `{{ActionName3}}`, `{{ActionName4}}`

### {{Connections/Connections.json or equivalent}} (delete section if not applicable)
- Updated {{describe what changed, e.g., icon URLs for all connectors to new CDN endpoint}}

<!-- Add/remove ### sections above to cover each changed file or feature area. -->

---

## What changed — project documentation

### Updated files
- `VERSION` — {{PREVIOUS_VERSION}} → {{VERSION}}
- `README.md` — {{describe changes: e.g., version badge vX→vY; project release date; component version note}}
- `CHANGELOG.md` — added comprehensive [{{VERSION}}] entry (Added, Changed, Removed, Notes sections)
- `docs/PROJECT_STATUS.md` — {{describe what was updated: e.g., status summary, component versions, release history table, RBAC model section, roadmap}}
- `src/{{component}}/README.md` — {{describe scope of update: e.g., complete rewrite, partial update}}

### New files
- `docs/release-notes/v{{VERSION_MAJOR_MINOR}}.x/v{{VERSION}}/v{{VERSION}}_releaseNotes.md`
- `docs/release-notes/v{{VERSION_MAJOR_MINOR}}.x/v{{VERSION}}/v{{VERSION}}_commitMessage.md`
- `docs/release-notes/v{{VERSION_MAJOR_MINOR}}.x/v{{VERSION}}/v{{VERSION}}_pullRequest.md`
- `{{docs/local/optionalNewFile.md}}` — {{purpose}} (delete if none)

### Renamed files (delete section if none)
- `{{assets/screenshots/}}` — {{N}} screenshot files renamed from `v{{OLD_PREFIX}}_*` prefix → `v{{VERSION}}_*` ({{reason, e.g., screenshots were captured from vX.Y.Z; prefix was incorrect}})
- `{{old/path/oldName.ext}}` → `{{new/path/newName.ext}}` — {{reason}}

<!-- ==================== END COMMIT MESSAGE ===================== -->
