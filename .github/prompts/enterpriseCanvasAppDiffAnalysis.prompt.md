---
description: >
  Single-run agent that performs a deep, comprehensive difference analysis between the
  previously-published (archived) version of the Power Apps Canvas app's unpacked source
  and the newest unpublished (freshly unpacked) version, then generates a SET of verbose
  Canvas-app documentation files (diff analysis, change summary, known issues, and future
  recommendations), updates all core project/repo documentation and release-draft
  artifacts, performs a recursive repo-wide correction sweep, updates CHANGELOG.md, and
  finishes with a full workspace health check + report. It self-discovers all version
  numbers and source paths at run time and never commits/pushes. Use when: documenting a
  new Canvas app version, diffing old vs new unpacked .msapp sources, generating canvas
  app change/diff/known-issues/recommendations docs, preparing a Canvas-app release's
  documentation, refreshing README/PROJECT_STATUS/solution.xml/release-notes for a new
  app version, auditing the repo before a commit/PR/push/release.
agent: agent
argument-hint: "Optional: extra focus or context (e.g. 'focus on SharePoint schema + Confirm screen', or 'old=v0.8.14 new=v0.9.26')"
---
# Enterprise Canvas App Difference Analysis & Documentation

You are acting as an expert Power Platform release-engineering and technical-writing agent
for this software project. Your job is to **compare the currently-published version of this
repository's Canvas app against the newest unpublished version**, then produce an
exhaustive, professional, and fully-evidenced set of documentation — and to bring every
downstream repo/documentation artifact up to date in preparation for the developer's next
manual commit / pull request / push / release.

Complete every step **in order**. Do not skip steps. Do not stop early unless an explicit
stop condition below is triggered. When a step says "report", accumulate the result for the
Final Report — do not abandon the run.

---

## Operating principles (read first — these govern the entire run)

1. **Maximize thoroughness, not efficiency.** Use your deepest reasoning, the largest
   context you can, and the most capable tools available. Do **not** optimize for token
   usage, speed, or brevity. Verbose, complete, precise output is the goal. Model every
   deliverable as if it were being produced by a top-tier engineering organization.
2. **Never invent details.** Every statement in every document must be verifiable from the
   actual unpacked source files, the repository's tracked files, or `git`/`pac` output. If
   something cannot be confirmed from evidence, either verify it or explicitly mark it as
   *unconfirmed / needs developer input* — never fabricate control names, property values,
   column names, formulas, versions, dates, or behaviors.
3. **Self-discover everything.** Do not hardcode version numbers or paths. Detect the
   project version, the old (published) component version, the new (unpublished) component
   version, and both unpacked-source locations at run time (Steps 1–2). This prompt must
   remain correct on every future run of this repository as versions advance.
4. **NEVER modify these locations, under any condition** (they are point-of-origin,
   immutable, or local-only):
   - `archive/` (entire tree — git-ignored, long-term frozen snapshots)
   - `src/powerApps/.unpacked/` (the raw `pac canvas unpack` output — read-only evidence)
   - `docs/release-notes/releaseTemplates/` (original release templates & helper scripts)
     You will **read from** `archive/…/.unpacked/` and `src/powerApps/.unpacked/` extensively,
     but you will **never write, rename, move, or delete** anything inside them.
5. **Do not commit, stage, push, tag, create a PR, or run any release script.** You are
   preparing and staging content only. The developer executes the actual
   commit/PR/push/release manually afterward.
6. **Maintain your own execution plan.** In Step 2 you will build an explicit, trackable
   to-do list covering Steps 3–8 and work it to completion, updating status as you go.
7. **Honor the invocation argument.** If the user supplied extra context via the argument
   (e.g., a focus area, or explicit `old=`/`new=` version hints), fold it into your
   analysis — but still perform the full workflow.

---

## Step 0 — Preflight & environment guards

1. Confirm you are at the repository root of a Power Platform project by verifying that
   **all** of these exist: `./VERSION`, `./CHANGELOG.md`, `./src/powerApps/`,
   `./docs/release-notes/`, `./.github/`. If any are missing, stop and report:
   `✗ This does not look like the expected repo root (missing one of VERSION / CHANGELOG.md / src/powerApps / docs/release-notes / .github). Aborting.`
2. Re-state the **never-edit** guard list from Operating Principle #4 back to yourself and
   keep it active for the entire run.
3. On Windows use PowerShell with backslash paths. If your terminal integration is known to
   prepend a stray control character to the first command in a fresh terminal, run one
   harmless command first (e.g. `Write-Host "init" | Out-Null`) before real commands.

---

## Step 1 — Detect versions and source locations (no hardcoding)

Establish four facts and record them explicitly; you will reuse them everywhere.

1. **`PROJECT_VERSION`** — read `./VERSION`, trim whitespace (e.g., `0.9.27`). This keys the
   release-notes artifacts and `solution.xml`.
2. **`NEW_UNPACKED`** — the newest unpublished unpacked source. Default:
   `./src/powerApps/.unpacked/`. Confirm it exists and contains `CanvasManifest.json` plus a
   `Src/` (or `Other/Src/`) folder of `*.fx.yaml`/`*.pa.yaml` screens.
   - If `./src/powerApps/.unpacked/` is missing **but** an `.msapp` exists under
     `./src/powerApps/.msapp/`, you MAY create the unpacked tree by running:
     `pac canvas unpack --msapp "<path to .msapp>" --sources "./src/powerApps/.unpacked"`
     (This writes only into the allowed `src/powerApps/.unpacked/` target.) If neither
     exists, stop and report that the new source is unavailable.
3. **`NEW_VER`** — the newest **Canvas component** version. Determine it (in priority order)
   from: the `.msapp`/`.zip` filename under `./src/powerApps/.msapp|.zip/` (e.g.
   `v0.9.26_…`), then `varRepoVersion`/version stamp in `NEW_UNPACKED/Src/App.fx.yaml`
   (or `Other/Src/App.pa.yaml`), then `CanvasManifest.json`. If sources disagree, record the
   discrepancy (it is itself a finding for the Known Issues doc) and prefer the `.msapp`
   filename version as the canonical `NEW_VER`.
4. **`OLD_UNPACKED` and `OLD_VER`** — the most-recently-published (archived) version. Search
   under `./archive/src/powerApps/` for versioned folders. The layout is **inconsistent**:
   some are flat (`vX.Y.x/.unpacked/`) and some are nested (`vX.Y.x/vX.Y.Z/.unpacked/`).
   Enumerate every directory that directly contains a `.unpacked/` folder holding a
   `CanvasManifest.json`, parse a SemVer from its folder name (use the most specific
   `vX.Y.Z` when present, else `vX.Y`), and select the **highest** SemVer strictly below
   `NEW_VER`. That folder's `.unpacked/` is `OLD_UNPACKED`; its version is `OLD_VER`.
   - If the user passed explicit `old=`/`new=` hints in the argument, honor them instead.
   - If no archived unpacked version can be found, stop and report the archive is empty/
     unreadable and that the old/published source must be placed under
     `archive/src/powerApps/…/.unpacked/` first.

Print a short confirmation block:

```
PROJECT_VERSION : {PROJECT_VERSION}
OLD_VER         : {OLD_VER}   ({OLD_UNPACKED})
NEW_VER         : {NEW_VER}   ({NEW_UNPACKED})
Focus argument  : {argument or "none"}
```

---

## Step 2 — Build your own execution plan

Create an explicit, trackable to-do list (use the task/todo mechanism available to you)
with one item per remaining step: **deep diff (3)**, **generate 4 docs (4)**,
**update core docs (5)**, **recursive sweep (6)**, **CHANGELOG (7)**, **health check &
report (8)**. Mark each `in_progress` when you start it and `done` when it is fully
finished. Do not batch-close items you have not actually completed.

Also read, if present, the **previous cycle's** Canvas-app docs in `./src/powerApps/`
(e.g. `v{OLD_VER}_*.md` such as `*_recentChangesSummary.md`, `*_knownIssues.md`,
`*_recommendations.md`). You will reconcile against them (close/carry/introduce issues)
in Steps 4 and later. Do **not** modify those older files unless Step 6 finds a factual
error in one; they are historical record.

---

## Step 3 — Deep comparative difference analysis (the core analysis)

Perform an exhaustive, evidence-based comparison of `OLD_UNPACKED` vs `NEW_UNPACKED`. This
single analysis feeds all four documents in Step 4 — do the heavy work **once**, here, and
hold the complete findings in memory.

### 3.1 Build a complete file inventory of both trees

For each tree, enumerate every file with its relative path, byte size, and a content hash
(e.g. MD5/SHA-256). Then classify every path as **Added** (new only), **Removed**
(old only), **Modified** (in both, hash differs), or **Unchanged** (hash identical).
Record size deltas (`+/- KB`) for modified/added/removed files. Robust tooling suggestions:
`Get-FileHash`, `Compare-Object` on hash tables, or a small script — but you MUST then
**read the actual contents** of changed files; hashes alone are not analysis.

### 3.2 Classify files as SIGNIFICANT vs NOISE

- **Significant (deep-diff these):** `*.fx.yaml` and `*.pa.yaml` (screens, components, App),
  `CanvasManifest.json`, `DataSources/*.json`, `pkgs/TableDefinitions/*.json`,
  `Connections/Connections.json`, `ComponentReferences.json`, `ControlTemplates.json`,
  `pkgs/*.xml` and `pkgs/PcfControlTemplates/*` (control/template versions),
  `Assets/Images/*` (by hash — added/removed/replaced), `Src/Themes.json` /
  `Other/References/ModernThemes.json`.
- **Noise (report at summary level only; do NOT treat churn here as meaningful behavior
  change):** `Entropy/` (incl. `Entropy.json`, `checksum.json`, `AppCheckerResult.sarif`)
  and `Src/EditorState/*.editorstate.json`. Note their presence/size drift briefly and move
  on. If `AppCheckerResult.sarif` differs, you MAY mine it for genuine app-checker
  findings to feed the Known Issues doc, but do not conflate it with source changes.

### 3.3 Deep-diff each significant area

For every **Modified**, **Added**, or **Removed** significant file, open **both** versions
(as applicable) and extract concrete, named differences:

- **Screens/components (`*.fx.yaml` / `*.pa.yaml`):** added/removed/renamed screens and
  controls; changed control **properties**; rewritten **formulas** (`OnStart`, `OnVisible`,
  `OnSelect`, `Items`, `Text`, `Visible`, `Fill`, `Patch(...)`, `Set(...)`, etc.). Capture
  `Old → New` values for changed formulas/properties. Prefer the current `*.fx.yaml`
  representation for the canonical diff; cross-check `Other/Src/*.pa.yaml` if it clarifies.
- **Data sources & SharePoint schema (`DataSources/*.json`, `pkgs/TableDefinitions/*.json`):**
  added/removed/**retyped** columns; group columns into logical families; note internal
  names and types. (Schema change is frequently the largest, most important delta.)
- **Connections (`Connections.json`):** added/removed connectors and connection references.
- **Components/templates (`ComponentReferences.json`, `ControlTemplates.json`,
  `pkgs/*`):** added/removed components, control-template version bumps (`X.Y.Z → A.B.C`).
- **Manifest (`CanvasManifest.json`):** app name, `AppVersion`/description, version stamps
  (flag any **version drift** where manifest ≠ `.msapp` filename ≠ `varRepoVersion`), screen
  order, dependencies, published state.
- **Assets:** images added/removed/replaced (by hash); note filenames.

### 3.4 Reconcile against prior findings

If a previous-cycle Known Issues / follow-up doc exists (Step 2), determine which prior
items are now **Closed**, which are **Still Open (carried)**, and which are **New** this
cycle. This drives the Known Issues document.

### 3.5 Quality bar for the analysis

Name real identifiers (screen names, control names, property names, function names, column
internal names, connector names, file names) and include `Old → New` values wherever a value
changed. No vague language ("various improvements", "several updates"). If the two trees are
identical for a significant area, say so explicitly rather than omitting it.

---

## Step 4 — Generate the SET of Canvas-app documentation files (task "c")

Write **four separate, cross-linked** Markdown files into `./src/powerApps/`, each prefixed
with the **new component version** `v{NEW_VER}_`. If a target file already exists, regenerate
it fully (these are generated artifacts) and note the overwrite in the Final Report.

Every one of the four files MUST:

- Begin with the repository's **Apache 2.0 license header** as an HTML comment (copy the
  exact header block used by existing `./src/powerApps/*.md` docs, with the correct
  copyright year and author), then the document body.
- Open with a **metadata block**: Component name, `Compared versions: v{OLD_VER} → v{NEW_VER}`,
  `Old source:` and `New source:` paths, `Analysis date:` (today, `YYYY-MM-DD`), and a
  `Method:` line describing the hash-diff + content-inspection approach.
- Include a **"Related documents"** section cross-linking the other three files by relative
  path (and the previous-cycle docs where relevant).
- Match the **depth, tone, and formatting** of the repository's existing exemplar
  (`./src/powerApps/*_recentChangesSummary.md` if present): tables, code blocks, before→after
  values, per-screen and per-schema detail.

Create these four files:

### 4A. `v{NEW_VER}_diffAnalysis.md` — technical difference analysis

The exhaustive, file-by-file / screen-by-screen / schema-by-schema record from Step 3:

- Title: `# Canvas App Difference Analysis — v{OLD_VER} → v{NEW_VER}`
- **File inventory & change tables:** counts and per-file size deltas for Added / Removed /
  Modified / Unchanged (significant files), plus a short Noise/Entropy note.
- **Per-screen/component change sections:** one `### ` section per changed screen/component,
  with property- and formula-level `Old → New` detail.
- **Data-source / SharePoint schema section:** add/remove/retype tables grouped by column
  family with internal names and types.
- **Connections / components / control-templates / themes / assets** sections as applicable.
- A closing **"Files with no meaningful change"** note for transparency.

### 4B. `v{NEW_VER}_changeSummary.md` — functional/executive change summary

The "what changed and why it matters" narrative for a mixed technical/non-technical reader:

- Title: `# Canvas App Change Summary — v{OLD_VER} → v{NEW_VER}`
- **Executive Summary** (3–6 sentences): the headline story of this release.
- **Functional Impact & Design Rationale:** themed subsections explaining what each major
  change accomplishes for end users and why it was made (use tables where helpful).
- **Screen-by-screen user-facing improvements.**
- **Cross-component version notes:** relationship between `NEW_VER`, `PROJECT_VERSION`, and
  any companion Power Automate / SharePoint / Power BI implications surfaced by the schema.

### 4C. `v{NEW_VER}_knownIssues.md` — bugs, risks, and open problems

An honest, evidenced register of problems that still exist in `NEW_VER`:

- Title: `# Canvas App Known Issues & Risks — v{NEW_VER}`
- A table/section per issue with: **ID**, **Title**, **Severity** (Critical/High/Med/Low),
  **Category** (bug / version drift / incomplete feature / data-integrity / performance /
  accessibility / security-PII / tech-debt), **Evidence** (file + control/property/formula or
  column), **Suggested fix**, and **Status** (New this cycle / Carried from v{OLD_VER} /
  Closed since v{OLD_VER}).
- Explicitly reconcile the prior-cycle list (from Step 3.4). Call out any version-string
  drift discovered in Step 3.3.

### 4D. `v{NEW_VER}_recommendations.md` — future improvements & roadmap

Copilot-generated, prioritized advice for the **next** versions (do not overstate certainty):

- Title: `# Canvas App Recommendations & Roadmap — post-v{NEW_VER}`
- Prioritized recommendations (Short / Medium / Long term), each with **Rationale**,
  **Expected impact**, **Rough effort**, and **Dependencies** (e.g., companion Power Automate
  flows, SharePoint schema changes, Power BI, ALM). Include testing, performance,
  accessibility, security/PII, and maintainability suggestions where warranted.

After writing all four, verify each file exists, is non-empty, contains the license header,
and cross-links the others.

---

## Step 5 — Update core project & release documentation (task "d")

Update each of the following. Read the current content first; make **surgical, accurate**
edits; preserve structure and existing valid content; correct every version string, path,
URL, date, and link that the new version affects.

1. **`./src/powerApps/README.md`** — set the current Canvas component version to `NEW_VER`;
   add a brief change-history entry for `v{OLD_VER} → v{NEW_VER}`; add links to the four new
   `v{NEW_VER}_*.md` docs; confirm the documented source paths (`.zip/`, `.msapp/`,
   `.unpacked/`, and the archive location of the prior version) are correct.
2. **`./src/solution.xml`** — locate the solution version element (e.g. `<Version>`). Per
   this repo's versioning policy the Power Platform Solution is the project-wide deployable
   bundle, so align `<Version>` with `PROJECT_VERSION`. Record the pre-existing value first:
   if it currently differs from both `PROJECT_VERSION` and `NEW_VER` (a version drift), make
   the update **and** flag the prior drift in the Final Report for the developer to confirm,
   rather than silently guessing intent. Verify the publisher prefix and unique/friendly
   names remain correct; do not alter unrelated managed-solution structure.
3. **`./README.md`** (root) — update any version badge/reference and any "latest version"
   or "current release" statements to `PROJECT_VERSION`; fix links that point to renamed or
   relocated Canvas-app docs/sources.
4. **`./docs/PROJECT_STATUS.md`** — update the project-wide version, the Canvas app
   component version (`v{OLD_VER} → v{NEW_VER}`), component-baseline table, status, and the
   "last updated" date.
5. **Release drafts** `./docs/release-notes/v{PROJECT_VERSION}_commitMessage.md`,
   `v{PROJECT_VERSION}_pullRequest.md`, and `v{PROJECT_VERSION}_releaseNotes.md` — for each
   file that exists and still contains `{{PLACEHOLDER}}` brackets, populate it from your
   Step 3–4 findings (Conventional-Commit title `type(scope): v{PROJECT_VERSION} — headline`
   for the commit; changes-at-a-glance table + detailed breakdown for the PR; dated,
   component-baseline release notes). If a file has **no** placeholders, treat it as already
   finalized and leave it unchanged. If the files do **not** exist, note in the Final Report
   that `postEnterpriseCommitArchival.ps1` must be run to reset the live release artifacts,
   and do not fabricate them.

Report exactly which files you changed and the key edits made to each.

---

## Step 6 — Recursive repo-wide correction sweep (task "e")

Perform a comprehensive, recursive review of the **rest** of the repository for anything
else that a new version or the Step 4–5 changes render stale, broken, or inconsistent —
especially anything that becomes **publicly visible on the GitHub repo** at the next release.

1. Enumerate tracked/public-facing files (e.g. `git ls-files`) and review under `./src/`,
   `./docs/`, `./.github/`, `./assets/`, and the root docs. **Skip entirely** the never-edit
   locations (`archive/`, `src/powerApps/.unpacked/`, `docs/release-notes/releaseTemplates/`)
   and anything git-ignored (e.g. `config/`, `**/local/`, `tmp/`, `dist/`).
2. Look for: stale version references, broken/incorrect relative links or paths, references
   to files that were renamed/moved, outdated dates, leftover `{{PLACEHOLDER}}`/TODO markers
   in public docs, component READMEs that are missing the new version, and — critically —
   any **PII, secrets, credentials, or sensitive VA data** that must not be published (flag
   these; do not silently commit them).
3. **Autonomously fix** the objective issues (version strings, paths, links, dates, missing
   doc references). For anything requiring human judgment (possible PII, ambiguous intent,
   risky structural change), do **not** guess — record it for the Final Report as a
   decision the developer must make.
4. Keep a running list of every file you change and why.

---

## Step 7 — Update CHANGELOG.md (task "f")

Read `./CHANGELOG.md`. Insert a **new version entry** immediately **after** the
`## [Unreleased]` block and **before** the most recent released entry. Use `PROJECT_VERSION`
and today's date:

```markdown
## [{PROJECT_VERSION}] - {YYYY-MM-DD}

### Added
- **`{path}`** — {specific description}

### Changed
- **`{path}`** — {specific description}

### Fixed
- {specific description}

### Removed
- {specific description}

### Notes
- Release type: {Feature / Maintenance / Patch / Security}
- Canvas app component: v{OLD_VER} → v{NEW_VER}
- {Carried/new known issues or admin prerequisites worth flagging}
```

Rules: today's real date; omit any empty section; every bullet concise but specific (name
files and actual changes); the `[Unreleased]` block and all existing entries below the
insertion point remain intact. Cover **all** changes since the last commit — the four new
docs, every Step 5 edit, and every Step 6 correction. **Save** `./CHANGELOG.md`.

---

## Step 8 — Final workspace health check & report (task "g")

1. Re-verify the never-edit guards held: nothing was written under `archive/`,
   `src/powerApps/.unpacked/`, or `docs/release-notes/releaseTemplates/`.
2. Run `git status --short` and `git status --verbose` and review the full set of pending
   changes. Confirm: the four `v{NEW_VER}_*.md` docs exist; every intended Step 5 file was
   updated; CHANGELOG has the new entry; no unintended files changed.
3. Run a final **PII/secrets scan** over changed + newly-added files.
4. Confirm you did **not** commit, stage-for-release, push, tag, create a PR, or run a
   release script.
5. Print the Final Report (below), then **stop** — leave the actual
   commit/PR/push/release for the developer to execute manually.

### Final Report format

```
══ Enterprise Canvas App Difference Analysis — Complete ══

Versions:
  Project VERSION : {PROJECT_VERSION}
  Canvas app      : v{OLD_VER} → v{NEW_VER}
  Old source      : {OLD_UNPACKED}
  New source      : {NEW_UNPACKED}

New Canvas-app documents (./src/powerApps/):
  ✓ v{NEW_VER}_diffAnalysis.md      — {N} changed significant files documented
  ✓ v{NEW_VER}_changeSummary.md     — {N} functional themes
  ✓ v{NEW_VER}_knownIssues.md       — {N} issues ({X} new / {Y} carried / {Z} closed)
  ✓ v{NEW_VER}_recommendations.md   — {N} recommendations

Core docs updated (task d):
  ✓ src/powerApps/README.md
  ✓ src/solution.xml
  ✓ README.md
  ✓ docs/PROJECT_STATUS.md
  ✓ docs/release-notes/v{PROJECT_VERSION}_{commitMessage,pullRequest,releaseNotes}.md
      (or: ⚠ release drafts missing — run postEnterpriseCommitArchival.ps1)

Recursive sweep (task e):
  ✓ {list each other file corrected, with a one-line reason}

CHANGELOG.md (task f):
  ✓ [{PROJECT_VERSION}] - {YYYY-MM-DD} entry inserted

Health check (task g):
  ✓ Never-edit guards intact (archive/, src/powerApps/.unpacked/, releaseTemplates/)
  ✓ PII/secrets scan clean (or ⚠ flags listed below)
  ✓ Nothing committed/pushed/tagged/PR'd

⚠ Decisions the developer must make before commit/PR/push/release:
  - {each open decision, ambiguous item, possible-PII flag, or version-drift to resolve}

Summary of autonomous changes:
  - {concise bullet list of everything changed this run}

Next steps (manual, developer-run):
  1. Review the four new src/powerApps/v{NEW_VER}_*.md docs.
  2. Review the Step 5 doc updates and the CHANGELOG entry.
  3. Resolve any ⚠ decisions above.
  4. Run your commit/PR/push/release workflow (e.g. enterpriseCommitGuide.ps1).
══════════════════════════════════════════
```

---

## Absolute constraints (restate before finishing)

- Never wrote to `archive/`, `src/powerApps/.unpacked/`, or `docs/release-notes/releaseTemplates/`.
- Never invented a version, path, control, column, formula, date, or behavior.
- Never committed, pushed, tagged, opened a PR, or ran a release script.
- Auto-discovered all versions/paths; nothing hardcoded.
