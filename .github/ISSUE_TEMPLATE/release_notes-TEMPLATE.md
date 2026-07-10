<!--
   Copyright 2025 Coder, Kyle J. (github.com/KCoderVA)

   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
-->

<!--
    RELEASE NOTES TEMPLATE — EHRM Training & Booking App
    ------------------------------------------------------
    HOW TO USE:
      1. Fill in every {{PLACEHOLDER}} — search for "{{" to find them all.
      2. Set the numbered list in the Executive Summary to match the actual number of distinct change areas you are documenting below.
      3. Add/remove "### Change Area" sections to match your release. Each section should match one numbered item in the Executive Summary.
      4. Fill in the Component Baselines table; mark unchanged components with "(unchanged)" in the Current column.
      5. Delete comment blocks and "(delete if none)" sections before publishing.

    RELEASE NOTES TITLE FORMAT:
      vX.Y.Z Release Notes - EHRM Training & Booking App
    RELEASE NOTES FILE PATH:
      ./docs/release-notes/vX.Y.x/vX.Y.Z/vX.Y.Z_releaseNotes.md
-->

# v{{VERSION}} Release Notes - EHRM Training & Booking App

- **Release date**: {{YYYY-MM-DD}}
- **Release type**: {{Feature / Maintenance / Patch / Security}} — {{one-line description of what kind of release this is, e.g., "First major Canvas app functional update since v0.0.2"}}
- **Previous release**: v{{PREVIOUS_VERSION}} ({{YYYY-MM-DD}})
- **{{Canvas app / Power Automate / etc.}} component**: v{{COMPONENT_PREVIOUS_VERSION}} → **v{{VERSION}}** {{(aligned with project release versioning going forward)}}
- **Power Automate**: `AppUserList` v{{FLOW_VERSION}} {{(unchanged / updated to vX.Y.Z)}}

---

## Executive Summary

{{2–4 sentences: What is the most significant aspect of this release? What broad category of improvement does it represent — functional advancement, ALM/CI-CD infrastructure, documentation, security? Who does it impact and how? Conclude by noting the number of distinct improvement areas documented below.}}

{{N}} distinct improvement areas were implemented and are documented in full below:

1. **{{Area 1 name}}** — {{one-line description}}
2. **{{Area 2 name}}** — {{one-line description}}
3. **{{Area 3 name}}** — {{one-line description}}
<!-- Add/remove numbered items to match actual change area count. -->

---

## Changes

### Canvas App — {{Change Area 1 Title}} ({{Screen or file name}})

{{Opening sentence: describe the state before this change and why a change was needed. Give context for reviewers not following day-to-day development.}}

**How it works:** (or "What changed:", "New options added:", etc. — choose the best sub-heading)

{{Detailed description. Use tables for access tier / before-after comparisons. Use code blocks for formula excerpts. Use bullets for lists of new items.}}

```powerfx
// Formula excerpt (delete block if not applicable)
Set(varExample, "value");
```

{{If there are access tiers or named configurations:}}

| {{Tier / Setting / Option}} | {{Who / What it applies to}} | {{Behavior / Value}} |
|---|---|---|
| `{{TierName}}` | {{description}} | {{result}} |

**Additional {{area}} changes:** (delete sub-section if not needed)
- {{Specific control or property change — before → after}}
- {{Specific control or property change}}

---

### Canvas App — {{Change Area 2 Title}} ({{Screen or file name}})

{{Context paragraph: what was the prior behavior, and why was it insufficient?}}

**{{Sub-section heading — e.g., "Smart default start time:", "Automatic 1-hour event duration:", "New scheduling options:"}}**

{{Detailed description.}}

**{{Sub-section heading 2 (delete if not needed):}}**

{{Description.}}

---

### Canvas App — {{Change Area 3 Title}} ({{Screen or file name}})

{{Context paragraph.}}

{{Detailed description. Use before/after table if labels or values changed:}}

| Field | Before | After |
|---|---|---|
| {{Label name}} | {{old text or value}} | **{{new text or value}}** |

---

<!-- Repeat the ### Canvas App — [Area] pattern for each additional change area.
     For non-Canvas changes (Flow, SharePoint, ALM, CI/CD), change the prefix accordingly. -->

### Documentation & Screenshots

**`src/{{component}}/README.md`** — {{Describe what was updated: e.g., completely rewritten for vX.Y.Z; now includes narrative for all N improvement areas with formula excerpts, full screen inventory table (N screens), version history table, screenshots table, connector/platform diff tables.}}

**`assets/screenshots/`** — {{N}} screenshots captured {{YYYY-MM-DD}} from the live v{{VERSION}} app:
- {{Renamed from `v{{OLD_PREFIX}}_*` prefix → `v{{VERSION}}_*`.}}
- {{`oldScreenName` file renamed to `newScreenName` to match screen rename. (delete if no renames)}}

**`README.md`** (root), **`CHANGELOG.md`**, **`VERSION`**, **`docs/PROJECT_STATUS.md`** — All updated to reflect v{{VERSION}}.

---

## Upgrade Notes / Configuration Requirements

> {{Describe any environment actions an administrator must take before or after deploying this release. Examples: populate a SharePoint list column for all users, reset a connector connection, run a deployment script, update a permission assignment. Be specific about which list/column/value. If no action is required, replace this entire block with: "No environment action required for this release."}}

## Known Issues (delete section if none)

- {{Known issue 1: name the control, screen, or feature. Describe what is incomplete, what guard is in place (e.g., `Visible = false`, button disabled, feature flag off), and what the path to resolution is.}}
- {{Known issue 2: report any build-level warnings — e.g., `BindingErrorCount: N` in CanvasManifest. Recommend reviewing in the editor before next production deployment.}}

## Component Baselines

| Component | Previous | Current |
|---|---|---|
| Canvas app | v{{COMPONENT_PREVIOUS_VERSION}} | **v{{VERSION}}** |
| `AppUserList` Power Automate flow | v{{FLOW_PREVIOUS_VERSION}} | v{{FLOW_VERSION}} {{(unchanged)}} |
| SharePoint schema | *(baseline)* | *(unchanged)* |
<!-- Add rows for any other components that changed or are relevant to track (SQL SPs, Power BI, solution version, etc.). -->
