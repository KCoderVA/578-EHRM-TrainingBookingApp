---
description: >
  Single-run agent that populates ALL THREE current-version release artifact
  files in one pass: _commitMessage.md, _pullRequest.md, and _releaseNotes.md.
  Also inserts a new dated entry into CHANGELOG.md. Use when: preparing a
  full release package, auto-filling all release documentation at once,
  generating commit message + PR description + release notes from git changes,
  populating all release template placeholders in one click.
agent: agent
argument-hint: "Optional: extra context to include in the analysis (e.g. 'focus on Canvas app changes')"
---

# Enterprise Prepare All Release Artifacts

You are acting as an expert release documentation agent for this software project.
Your job is to analyze every pending change in this workspace **once**, then use
those findings to generate all three release artifact documents in a single pass —
accurate, verbose, and professional throughout. No invented details. No vague summaries.

Complete every step **in order**. Do not skip steps. Do not stop early unless
the explicit stop condition in Step 2 is triggered.

---

## Step 1 — Identify the current version and locate all three artifact files

1. Read `./VERSION` and extract the trimmed version string (e.g., `0.3.5`).
   Call this `CURRENT_VERSION`.
2. Construct the three artifact paths:
   - `./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md`
   - `./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md`
   - `./docs/release-notes/v{CURRENT_VERSION}_releaseNotes.md`
3. Read all three files and note their contents.
4. If any file does not exist, report which are missing and stop:
   `✗ Missing artifact(s) — run postEnterpriseCommitArchival.ps1 first to reset the live artifacts.`

---

## Step 2 — Detect which files still need to be populated

For each of the three files, check for placeholder bracket sequences: `{{` or `}}`.

- **Files with NO placeholders** — already manually filled in by the developer.
  Skip population for those files; report them as already complete.
- **Files with placeholders** — mark for population; continue to Step 3.
- **If ALL three files have no placeholders** — stop immediately and report:
  `✓ All three artifacts appear already populated. No action taken.`

---

## Step 3 — Gather comprehensive workspace change information (single shared analysis)

Run **all** of the following terminal commands once. Capture the full output of
each inside the pwsh terminal integrated into this VS Code workspace session.
This analysis is shared across all three documents — do not repeat it per document:

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
- Read `./CHANGELOG.md` and compare its `[Unreleased]` section against the most
  recent released version entry
- Read `./docs/PROJECT_STATUS.md` if it exists — note component versions and status
- Read `./README.md` and check for version badge or reference changes
- For any files under `./src/`, `./docs/`, `./.github/`, or `./config/`,
  identify every meaningful content change — not just filenames

Build a complete, accurate inventory covering:
- Everything added (new files, new features, new content)
- Everything changed (modified files, updated values, renamed files)
- Everything removed (deleted files, removed functionality)
- The version transition (last commit's VERSION → current VERSION)
- Any known issues, incomplete implementations, or admin prerequisites
- Component baseline versions for all tracked components

Determine the **release type**: `Feature`, `Maintenance / Patch`, `Fix`, or `Security`.

Hold all findings in memory. You will use them to populate all three documents
without re-running terminal commands.

---

## Step 4A — Populate `_commitMessage.md`

*(Skip this document if it had no placeholders in Step 2)*

Rewrite the full content of `./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md`,
replacing every `{{PLACEHOLDER}}` with accurate information from Step 3.
Preserve all structural headings; only placeholder text changes.

### Commit title (line 1)
`{type}({scope}): v{CURRENT_VERSION} — {headline}`

- `{type}`: `feat`, `fix`, `docs`, `chore`, `refactor`, or `build` — whichever
  best fits the bulk of changes
- `{scope}`: `canvas-app`, `power-automate`, `sharepoint`, `scripts`, `docs`,
  `alm`, `ci`, or `repo` — use comma-separated scopes if multiple areas are
  equally primary
- `{headline}`: 2–5 comma-separated specific change descriptions, naming actual
  features, files, or behaviors changed

### Context section
2–4 sentences: what this commit does, how it was made, what paths are affected,
any component version transitions (`vOLD → vNEW`).

### What changed — source sections
One `### ` subsection per logical file or feature area (flush-left, no indentation).
Bullet points name concrete identifiers and include before→after values.
Delete placeholder sections for areas with no actual changes.

### What changed — project documentation section
One bullet per changed documentation file: updated, new, renamed, or removed.

**Quality rules**: every bullet is verifiable from the diff; no vague language;
no invented details.

**Save** `./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md`.

---

## Step 4B — Populate `_pullRequest.md`

*(Skip this document if it had no placeholders in Step 2)*

Rewrite the full content of `./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md`,
replacing every `{{PLACEHOLDER}}` with accurate information from Step 3.
Preserve all structural headings; only placeholder text changes.

### PR title (line 1)
`# PR: v{CURRENT_VERSION} — {Component/area}: {headline}`

### Summary section
2–4 sentences: what this PR delivers, how it was made, the primary change target,
any component version transitions.

### Changes at a glance table
One row per changed file or folder. Include `VERSION`, `README.md`, `CHANGELOG.md`
if any changed. Include new release artifact files.

### Detailed breakdown sections
Numbered `### N. Title` sections — one per logical change area.
Narrative paragraph + specific bullets. Add admin action callout if needed:
`> **Admin action required before deploying:** {exact action}`
Delete placeholder sections for areas with no actual changes.

### Known issues / follow-up items section
Include ONLY if there are real incomplete features or admin prerequisites.
Remove entirely if there are none.

### Verification checklist
Replace each placeholder item with a specific, verifiable check for this release.
Always end with the PII/secrets and `git status` clean checks.

**Save** `./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md`.

---

## Step 4C — Populate `_releaseNotes.md`

*(Skip this document if it had no placeholders in Step 2)*

Rewrite the full content of `./docs/release-notes/v{CURRENT_VERSION}_releaseNotes.md`,
replacing every `{{PLACEHOLDER}}` with accurate information from Step 3.
Preserve all structural headings; only placeholder text changes.

### Title line (line 1)
`# {REPO_NAME} — Release Notes (v{CURRENT_VERSION})`
Where `{REPO_NAME}` is the human-readable project name from `./README.md`.

### Metadata block
- **Release date**: today's date `YYYY-MM-DD`
- **Release type**: the type determined in Step 3 + one-line description
- **Previous release**: tag and date of the most recent prior release
- **Component versions**: `vOLD → vNEW` for changed components; `vX.Y.Z (unchanged)` for others
- Remove metadata lines for components that don't exist in this project

### Executive Summary
3–5 sentences on what this release does, who it impacts, what changed.
Then a numbered list of distinct improvement areas (must match the count of `###` sections below).

### Change area sections
`### {Component} — {Area Title} ({screen or file name})` — one section per numbered area.
Opening paragraph → sub-section heading → detailed description (tables, code blocks, bullets).
Delete placeholder sections with no matching changes. Add sections for ungrouped changes.

### Documentation & Screenshots section
All documentation changes: updated, new, renamed.

### Upgrade Notes
Only if there are genuine admin/deployment prerequisites.
Otherwise: `No environment action required for this release.`

### Known Issues section
Only if there are real known issues. Remove entirely if none.

### Component Baselines table
All tracked components with previous and current versions.
Mark unchanged ones explicitly with "(unchanged)".

**Save** `./docs/release-notes/v{CURRENT_VERSION}_releaseNotes.md`.

---

## Step 5 — Insert a new entry into CHANGELOG.md

Read `./CHANGELOG.md`. Insert a new version entry immediately **after** the
`## [Unreleased]` block and **before** the most recently released version entry.

```markdown
## [{CURRENT_VERSION}] - {YYYY-MM-DD}

### Added
- **`{path/to/file}`** — {specific description}

### Changed
- **`{path/to/file}`** — {specific description}

### Fixed
- {specific description}

### Removed
- {specific description}

### Notes
- Release type: {Feature / Maintenance / Patch / Security}
- {Component version transitions or "unchanged" notes}
- {Known issues or follow-up items}
```

Rules:
- Today's actual date for `{YYYY-MM-DD}`
- Only include sections with real content — omit empty sections entirely
- Each bullet: concise (1–2 lines), specific, names files and actual changes
- The `[Unreleased]` block must remain untouched above the new entry
- All existing CHANGELOG content below the insertion point must remain intact

**Save** `./CHANGELOG.md`.

---

## Final report

Once all steps are complete, print this summary:

```
══ Enterprise Prepare All Release Artifacts — Complete ══

Version:        v{CURRENT_VERSION}
Release type:   {Feature / Maintenance / Patch / Security}

Documents populated:
  ✓  v{CURRENT_VERSION}_commitMessage.md  —  {commit title first line}
  ✓  v{CURRENT_VERSION}_pullRequest.md    —  {PR title first line}
  ✓  v{CURRENT_VERSION}_releaseNotes.md   —  {N} change areas documented
  ✓  CHANGELOG.md  —  [{CURRENT_VERSION}] entry inserted for {YYYY-MM-DD}

  (any skipped documents listed here as "already populated — skipped")

Warnings (if any):
  ⚠  {files that could not be fully analyzed, or sections left with
      placeholder text because no matching changes were found}

Next steps:
  1. Review all three ./docs/release-notes/v{CURRENT_VERSION}_*.md files
  2. Edit any sections that need human judgment or additional context
  3. Run enterpriseCommitGuide.ps1 to commit, push, create PR, merge, and sync
  4. After merge: run postEnterpriseCommitArchival.ps1 to archive artifacts
     and reset the live folder for the next release cycle
══════════════════════════════════════════
```
