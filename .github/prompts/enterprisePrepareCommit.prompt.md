---
description: >
  Analyzes all pending workspace changes since the last commit, populates the
  current-version _commitMessage.md draft with real content (replacing all
  {{PLACEHOLDER}} brackets with accurate findings), and inserts a new dated
  entry into CHANGELOG.md. Use when: preparing a commit, auto-filling a
  commit message draft, generating release documentation, updating changelog
  with pending changes, populating release notes placeholders.
agent: agent
argument-hint: "Optional: extra context to include in the analysis (e.g. 'focus on Canvas app changes')"
---

# Enterprise Prepare Commit

You are acting as an expert release documentation agent for this software project.
Your job is to analyze every pending change in this workspace, then generate
accurate, verbose, and professional release documentation — no invented details,
no vague summaries.

Complete every step **in order**. Do not skip steps. Do not stop early unless
the explicit stop condition in Step 2 is triggered.

---

## Step 1 — Identify the current version and locate the commit message artifact

1. Read the file `./VERSION` and extract the trimmed version string (e.g., `0.3.5`).
   Call this `CURRENT_VERSION`.
2. Construct the commit message path:
   `./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md`
3. Read that file and hold its full contents in memory.
4. If the file does not exist, stop and report:
   `✗ Cannot find ./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md — run postEnterpriseCommitArchival.ps1 first to reset the live artifacts.`

---

## Step 2 — Detect whether the file needs to be populated

Scan the file contents for any placeholder bracket sequences: `{{` or `}}`.

- **If NO placeholders are found** → the developer has already manually filled in
  this file. Stop immediately and report:
  `✓ v{CURRENT_VERSION}_commitMessage.md appears already populated (no {{}} brackets found). No action taken.`
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
- Read `./docs/PROJECT_STATUS.md` if it exists and note any status changes
- Check `./README.md` for any version badge or reference that changed
- For any files under `./src/`, `./docs/`, `./.github/`, or `./config/`,
  identify every meaningful content change — not just filenames

Cross-reference all git diff output with your direct file analysis. Build a
complete, accurate inventory of every change since the last commit. Note:
- What was added (new files, new features, new content)
- What was changed (modified files, updated values, renamed files)
- What was removed (deleted files, removed functionality)
- The version transition (what VERSION was at the last commit → what it is now)

---

## Step 4 — Populate the `_commitMessage.md` file with complete content

Using all findings from Step 3, rewrite the full content of
`./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md`.

Replace every `{{PLACEHOLDER}}` with accurate information. Preserve all
structural headings and formatting from the template — only the placeholder
text changes. Apply these standards for each section:

### Commit title (line 1)

Format exactly as:
`{type}({scope}): v{CURRENT_VERSION} — {headline}`

- `{type}`: the Conventional Commit type that best fits the bulk of changes —
  `feat` (new functionality), `fix` (bug fix), `docs` (documentation only),
  `chore` (maintenance/tooling), `refactor` (restructuring), `build` (ALM/CI)
- `{scope}`: the primary changed area —
  `canvas-app`, `power-automate`, `sharepoint`, `scripts`, `docs`, `alm`,
  `ci`, `repo` (use comma-separated scopes if multiple areas are equally primary)
- `{headline}`: 2–5 comma-separated specific change descriptions, not generic —
  name actual features, files, or behaviors changed (e.g.,
  `RBAC model, smart scheduling, solution manifest correction`)

### Context section

Write 2–4 sentences that explain:
- What this commit does at a high level and why it matters
- How the changes were made (hands-on editor, script, documentation pass, etc.)
- What artifact or source path is the primary change target
- If a component version advanced, state `v{old} → v{new}`

### What changed — source sections

For each logical change area (grouped by file or feature, not by individual line):
- Create a `### ` subsection with the file name or feature area as the heading
- Write bullet points that state the specific property, control, formula, or
  setting that changed — include before→after values in format `OldValue → NewValue`
- Name actual identifiers: control names, property names, function names,
  column names, screen names — do not say "the setting was updated"
- Delete any placeholder sections for which there were no actual changes

### What changed — project documentation section

List all documentation files changed:
- For `VERSION`: show `{old} → {CURRENT_VERSION}`
- For updated files: one bullet per file, describing what was updated
- For new files: one bullet per file, with its path and purpose
- For renamed files: `old name → new name` with reason

### Quality rules (enforced — do not violate)

- Every bullet states a concrete, verifiable fact evidenced in the git diff
- No vague language: "various improvements," "several updates," "misc changes"
- No invented details: if a change is not visible in the diff or workspace
  analysis, do not mention it
- The completed document must be detailed enough for a reviewer with zero
  context to understand exactly what changed and why

**Save** the completed content by overwriting
`./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md`.

---

## Step 5 — Insert a new entry into CHANGELOG.md

Read `./CHANGELOG.md`. Find the `## [Unreleased]` section at the top. Insert
a **new version entry immediately after the `## [Unreleased]` block** and
**before** the most recently released version entry (e.g., before `## [0.3.4]`).

Use this format exactly:

```markdown
## [{CURRENT_VERSION}] - {YYYY-MM-DD}

### Added
- **`{path/to/file}`** — {description of what was added and why}

### Changed
- **`{path/to/file}`** — {description of what changed}

### Fixed
- {description of what was corrected}

### Removed
- {description of what was removed}

### Notes

- Release type: {Feature / Maintenance / Patch / Security}
- {Any component version transitions, e.g., "Canvas app baseline remains v0.3.4 (unchanged)"}
- {Any known issues or follow-up items worth calling out}
```

Rules:
- Use today's actual date for `{YYYY-MM-DD}`
- Only include sections (Added / Changed / Fixed / Removed / Notes) that have
  real content — omit empty sections entirely
- Each bullet should be concise (1–2 lines max) but specific — name files and
  describe actual changes, not categories of changes
- This is a summary of the commit message — accurate, shorter, scannable
- The `[Unreleased]` section itself must remain untouched above the new entry
- All existing CHANGELOG content below the insertion point must remain intact

**Save** the updated `./CHANGELOG.md`.

---

## Final report

Once all steps are complete, print this summary:

```
══ Enterprise Prepare Commit — Complete ══

Version:        v{CURRENT_VERSION}
Commit title:   {full first line of the populated _commitMessage.md}
Change areas:   {N} sections documented
CHANGELOG:      [{CURRENT_VERSION}] entry inserted for {YYYY-MM-DD}

Files modified:
  ✓  ./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md  (populated)
  ✓  ./CHANGELOG.md  (entry added)

Warnings (if any):
  ⚠  {list any files that could not be fully analyzed, or sections left with
      placeholder text because no matching changes were found}

Next steps:
  1. Review ./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md and edit as needed
  2. Review the new CHANGELOG entry and adjust if needed
  3. Run enterpriseCommitGuide.ps1 to commit, push, create PR, merge, and sync
══════════════════════════════════════════
```
