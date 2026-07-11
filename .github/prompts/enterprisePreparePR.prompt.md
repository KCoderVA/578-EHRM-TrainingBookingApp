---
description: >
  Analyzes all pending workspace changes since the last commit, populates the
  current-version _pullRequest.md draft with real content (replacing all
  {{PLACEHOLDER}} brackets with accurate findings). Use when: preparing a PR,
  auto-filling a pull request draft, generating PR description from git changes,
  populating PR template placeholders, documenting changes for code review.
agent: agent
argument-hint: "Optional: extra context to include in the analysis (e.g. 'focus on Canvas app changes')"
---

# Enterprise Prepare Pull Request

You are acting as an expert release documentation agent for this software project.
Your job is to analyze every pending change in this workspace, then generate
an accurate, verbose, and professional pull request document — no invented details,
no vague summaries.

Complete every step **in order**. Do not skip steps. Do not stop early unless
the explicit stop condition in Step 2 is triggered.

---

## Step 1 — Identify the current version and locate the PR artifact

1. Read the file `./VERSION` and extract the trimmed version string (e.g., `0.3.5`).
   Call this `CURRENT_VERSION`.
2. Construct the pull request artifact path:
   `./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md`
3. Read that file and hold its full contents in memory.
4. If the file does not exist, stop and report:
   `✗ Cannot find ./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md — run postEnterpriseCommitArchival.ps1 first to reset the live artifacts.`

---

## Step 2 — Detect whether the file needs to be populated

Scan the file contents for any placeholder bracket sequences: `{{` or `}}`.

- **If NO placeholders are found** → the developer has already manually filled in
  this file. Stop immediately and report:
  `✓ v{CURRENT_VERSION}_pullRequest.md appears already populated (no {{}} brackets found). No action taken.`
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
- If a `./docs/release-notes/v{CURRENT_VERSION}_commitMessage.md` file exists and
  has already been populated (no `{{` brackets), read it as additional context —
  it may contain detail about changes you can incorporate into the PR description

Cross-reference all git diff output with your direct file analysis. Build a
complete, accurate inventory of every change since the last commit. Note:
- What was added (new files, new features, new content)
- What was changed (modified files, updated values, renamed files)
- What was removed (deleted files, removed functionality)
- The version transition (what VERSION was at the last commit → what it is now)
- Any known issues, incomplete features, or required admin actions before deployment

---

## Step 4 — Populate the `_pullRequest.md` file with complete content

Using all findings from Step 3, rewrite the full content of
`./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md`.

Replace every `{{PLACEHOLDER}}` with accurate information. Preserve all
structural headings and formatting from the template — only the placeholder
text changes. Apply these standards for each section:

### PR title (line 1)

Format exactly as:
`# PR: v{CURRENT_VERSION} — {Component/area}: {headline}`

- `{Component/area}`: the primary changed area using one of:
  `Canvas app`, `Power Automate`, `SharePoint`, `scripts`, `docs`, `ALM`, `CI`, `repo`
  — use `+` to combine (e.g., `Canvas app + repo`) if multiple areas are equally significant
- `{headline}`: 2–5 comma-separated specific change descriptions — name actual
  features, files, or behaviors changed, not categories

### Summary section

Write 2–4 sentences that explain:
- What this PR delivers and why it matters (elevator pitch)
- How the changes were made (hands-on editor, scripted, documentation pass, etc.)
- What artifact or source path is the primary change target
- If a component version advanced, state `v{old} → v{new}`

### Changes at a glance table

Populate the table with one row per changed file or folder. Each row:
- Column 1: file or folder path (code-formatted with backticks)
- Column 2: a concise but specific description of what changed in that path
- Limit to the most meaningful changes — do not list every individual file if there
  are more than ~12; group by folder if needed (e.g., `src/scripts/pwsh/`)
- Always include: `VERSION`, `README.md`, `CHANGELOG.md` if any of these changed
- Always include: any new release artifact files added to `docs/release-notes/`

### Detailed breakdown sections

For each distinct logical change area, create a numbered `### N. Title` section:
- Write a narrative paragraph (2–5 sentences) describing what changed, why, and
  the user-visible or developer-visible impact
- Follow with specific bullet points where helpful (new controls, before→after
  values, specific file changes, named identifiers)
- If an admin or environment action is required before deployment, add a
  blockquote callout:
  `> **Admin action required before deploying:** {exact action required}`
- Delete any placeholder sections for which there were no actual changes
- Aim for one section per logical grouping, not one section per file

### Known issues / follow-up items section

Include this section ONLY if there are legitimate known issues, incomplete features,
or significant prerequisites. For each item:
- Name the specific control, file, or feature
- Describe what is incomplete and what guard is in place (e.g., `Visible = false`)
- State the path to resolution

If there are no known issues, remove this section entirely.

### Verification checklist

Replace each `{{PLACEHOLDER}}` checklist item with a specific, verifiable check
appropriate to this release. Good checklist items are things a reviewer can
actually verify by inspecting the repo. Examples:
- `[ ] \`VERSION\` file reads \`{CURRENT_VERSION}\``
- `[ ] \`src/scripts/pwsh/enterpriseCommitGuide.ps1\` exists`
- `[ ] \`CHANGELOG.md\` has a \`[{CURRENT_VERSION}]\` entry`

Remove any placeholder checklist items that do not apply to this release.
Add items for any new files or artifacts that are part of this PR.
Always end with:
- `[ ] No PII, GUIDs, tenant IDs, or internal URLs visible in staged \`src/\` diffs`
- `[ ] \`git status\` is clean before tagging`

### Quality rules (enforced — do not violate)

- Every bullet and table cell states a concrete, verifiable fact evidenced in
  the git diff or workspace analysis
- No vague language: "various improvements," "several updates," "misc changes"
- No invented details: if a change is not visible in the diff or workspace
  analysis, do not mention it
- The PR title first line must stand alone as a complete, informative summary
  (it becomes the GitHub PR title)

**Save** the completed content by overwriting
`./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md`.

---

## Final report

Once all steps are complete, print this summary:

```
══ Enterprise Prepare Pull Request — Complete ══

Version:        v{CURRENT_VERSION}
PR title:       {full first line of the populated _pullRequest.md}
Change areas:   {N} numbered sections documented
Checklist:      {N} verification items

Files modified:
  ✓  ./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md  (populated)

Warnings (if any):
  ⚠  {list any files that could not be fully analyzed, or sections left with
      placeholder text because no matching changes were found}

Next steps:
  1. Review ./docs/release-notes/v{CURRENT_VERSION}_pullRequest.md and edit as needed
  2. Run enterpriseCommitGuide.ps1 to commit, push, create PR (using this file as
     the PR body), merge, and sync
══════════════════════════════════════════
```
