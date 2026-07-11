---
description: >
  Analyzes all pending workspace changes since the last commit, populates the
  current-version _releaseNotes.md draft with real content (replacing all
  {{PLACEHOLDER}} brackets with accurate findings). Use when: preparing a
  release, auto-filling release notes, generating release documentation from
  git changes, populating release notes template placeholders, documenting a
  GitHub release, writing release announcement content.
agent: agent
argument-hint: "Optional: extra context to include in the analysis (e.g. 'focus on Canvas app changes')"
---

# Enterprise Prepare Release Notes

You are acting as an expert release documentation agent for this software project.
Your job is to analyze every pending change in this workspace, then generate
accurate, verbose, and professional release notes — no invented details,
no vague summaries.

Complete every step **in order**. Do not skip steps. Do not stop early unless
the explicit stop condition in Step 2 is triggered.

---

## Step 1 — Identify the current version and locate the release notes artifact

1. Read the file `./VERSION` and extract the trimmed version string (e.g., `0.3.5`).
   Call this `CURRENT_VERSION`.
2. Construct the release notes artifact path:
   `./docs/release-notes/v{CURRENT_VERSION}_releaseNotes.md`
3. Read that file and hold its full contents in memory.
4. If the file does not exist, stop and report:
   `✗ Cannot find ./docs/release-notes/v{CURRENT_VERSION}_releaseNotes.md — run postEnterpriseCommitArchival.ps1 first to reset the live artifacts.`

---

## Step 2 — Detect whether the file needs to be populated

Scan the file contents for any placeholder bracket sequences: `{{` or `}}`.

- **If NO placeholders are found** → the developer has already manually filled in
  this file. Stop immediately and report:
  `✓ v{CURRENT_VERSION}_releaseNotes.md appears already populated (no {{}} brackets found). No action taken.`
- **If ANY placeholders are found** → continue to Step 3.

---

## Step 3 — Gather comprehensive workspace change information

Run **all** of the following terminal commands. Capture the full output of each inside the pwsh terminal integrated into this VS Code workspace session.
Do not skip any command, even if the previous output looks complete:

```
echo "starting analysis"
git status --short
git status --verbose
git diff HEAD
git diff --cached
git diff --stat HEAD
git log --oneline -5
```

Then perform a thorough direct analysis of the workspace:

- List every file that git reports as modified (M), added (A), deleted (D),
  renamed (R), or untracked (??) and explain what each change is
- For any modified or newly added source files (non-binary, under ~500 lines),
  read the file and note the specific changes visible in the diff — actual
  property names, values, control names, formula fragments, setting keys
- Read the current `./CHANGELOG.md` and compare its `[Unreleased]` section
  against the most recent released version entry to understand what the project
  expects for the upcoming release
- Read `./docs/PROJECT_STATUS.md` if it exists and note component versions,
  current release status, and roadmap items
- For any files under `./src/`, `./docs/`, `./.github/`, or `./config/`,
  identify every meaningful content change — not just filenames
- If a `./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md` file exists and
  has been populated (no `{{` brackets), read it as primary source material —
  it contains the detailed change inventory you should summarize and expand here
- If a `./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md` file exists and
  has been populated (no `{{` brackets), read it as supplementary context

Cross-reference all git diff output with your direct file analysis. Build a
complete, accurate inventory of every change since the last commit. Note:
- What was added (new files, new features, new content)
- What was changed (modified files, updated values, renamed files)
- What was removed (deleted files, removed functionality)
- The version transition (what VERSION was at the last commit → what it is now)
- Any known issues, incomplete implementations, or admin prerequisites
- Component baseline versions (Canvas app, Power Automate flows, SharePoint, etc.)

Determine the **release type** based on the nature of changes:
- `Feature` — new user-visible functionality or significant new source components
- `Maintenance / Patch` — infrastructure, tooling, CI/CD, documentation, scripts
- `Fix` — bug corrections with no new features
- `Security` — security-related changes

---

## Step 4 — Populate the `_releaseNotes.md` file with complete content

Using all findings from Step 3, rewrite the full content of
`./docs/release-notes/v{CURRENT_VERSION}_releaseNotes.md`.

Replace every `{{PLACEHOLDER}}` with accurate information. Preserve all
structural headings and formatting from the template — only the placeholder
text changes. Apply these standards for each section:

### Title line (line 1)

Format exactly as:
`# {REPO_NAME} — Release Notes (v{CURRENT_VERSION})`

Where `{REPO_NAME}` is the human-readable name of this project as it appears
in `./README.md` or `./docs/PROJECT_STATUS.md`.

### Metadata block

Populate each metadata line accurately:
- **Release date**: today's actual date in `YYYY-MM-DD` format
- **Release type**: the release type determined in Step 3, followed by a
  one-line description (e.g., `Patch — developer tooling and ALM automation`)
- **Previous release**: the tag and date of the most recent prior release
  (read from `./CHANGELOG.md` or `git log`)
- **Component versions**: for each component tracked in the project (Canvas app,
  Power Automate flows, SharePoint schema, etc.), state the version transition
  `vOLD → vNEW` if it changed, or `vX.Y.Z (unchanged)` if it did not
- Remove any component metadata lines for components that do not exist in this project

### Executive Summary

Write 3–5 sentences that answer:
- What is the most significant aspect of this release? What category of work
  does it represent?
- Who does it impact — end users, developers, administrators?
- What was the state before this release, and what is different now?
- How many distinct improvement areas are documented below?

Then list the numbered improvement areas:
```
N distinct improvement areas were implemented and are documented in full below:

1. **{Area 1 name}** — {one-line description}
2. **{Area 2 name}** — {one-line description}
...
```

Each area name should be a short (2–5 word) label. The one-line description
should be a complete sentence stating the specific improvement.

### Change area sections (one per numbered item in the Executive Summary)

For each area, write a `### {Component} — {Area Title} ({screen or file name})`
section that follows this structure:

**Opening paragraph**: Describe the state before this change and why a change
was needed. Give a reviewer unfamiliar with day-to-day development enough
context to understand the problem being solved.

**Sub-section heading** (e.g., `**How it works:**`, `**What changed:**`,
`**New options added:**`): Detailed description of the change. Use:
- Tables for before/after value comparisons or access tier listings
- Code blocks for formula or script excerpts (labeled with language)
- Bullet points for lists of new items, controls, or behaviors

Example table for before/after:
```
| Field | Before | After |
|---|---|---|
| Label text | "old text" | **"new text"** |
```

Additional sub-sections as needed (e.g., `**Additional changes:**` with bullets
for secondary changes within the same area).

**Delete any placeholder area sections** for which there were no matching changes.
**Add area sections** if the analysis revealed distinct change groups not
captured by the template's placeholder count.

### Documentation & Screenshots section

Document all documentation file changes:
- For each updated documentation file: what specifically was updated
- For new files: path and purpose
- For screenshot renames: explain the before→after rename and why
- For `README.md`, `CHANGELOG.md`, `VERSION`, `docs/PROJECT_STATUS.md`:
  always include these if any were modified, even if briefly

### Upgrade Notes / Configuration Requirements section

Write this section ONLY if there are genuine prerequisites an administrator
or deployer must satisfy before or after this release. Examples:
- SharePoint list column population required
- Connector connection reset required
- Environment variable values that must be set
- Script execution required before first use

If no action is required, replace the entire content with:
`No environment action required for this release.`

### Known Issues section

Include this section only if there are actual known issues. For each:
- Name the specific control, screen, file, or feature
- Describe the incomplete state and what guard is in place
- State the path to resolution or next step

If there are no known issues, remove this section entirely.

### Component Baselines table

List every relevant component and its version status:
```
| Component | Previous | Current |
|---|---|---|
| {Canvas app} | v{X.Y.Z} | **v{CURRENT_VERSION}** (or unchanged) |
| {Flow name} Power Automate flow | v{X.Y.Z} | v{X.Y.Z} (unchanged) |
| SharePoint schema | *(baseline)* | *(unchanged)* |
```

Add rows for any additional tracked components (SQL, Power BI, scripts, etc.).
Mark unchanged components explicitly with "(unchanged)".

### Quality rules (enforced — do not violate)

- Every statement is a concrete, verifiable fact evidenced in the git diff or
  workspace analysis
- No vague language: "various improvements," "several updates," "misc changes"
- No invented details: only document changes visible in the analysis
- The Executive Summary must be accurate — the numbered count must match the
  number of `###` change area sections below it
- Release notes should be comprehensive enough that a stakeholder who has not
  followed development can understand the full scope and impact of the release

**Save** the completed content by overwriting
`./docs/release-notes/v{CURRENT_VERSION}_releaseNotes.md`.

---

## Final report

Once all steps are complete, print this summary:

```
══ Enterprise Prepare Release Notes — Complete ══

Version:        v{CURRENT_VERSION}
Release type:   {Feature / Maintenance / Patch / Security}
Change areas:   {N} distinct improvement areas documented
Release date:   {YYYY-MM-DD}

Files modified:
  ✓  ./docs/release-notes/v{CURRENT_VERSION}_releaseNotes.md  (populated)

Warnings (if any):
  ⚠  {list any files that could not be fully analyzed, or sections left with
      placeholder text because no matching changes were found}

Next steps:
  1. Review ./docs/release-notes/v{CURRENT_VERSION}_releaseNotes.md and edit as needed
  2. When the commit/PR cycle completes, attach this file content to the
     GitHub Release created by release.yml, or use it as the release body
  3. Run enterpriseCommitGuide.ps1 to commit, push, create PR, merge, and sync
══════════════════════════════════════════
```
