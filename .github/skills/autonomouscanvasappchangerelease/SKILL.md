---
name: autonomouscanvasappchangerelease
description: Executes a plain-language Canvas App change through the active coauthoring connection, increments the Canvas and project patch version, prepares the changelog and release documents, runs enterpriseCommitGuide.ps1, verifies the VA GitHub Enterprise release, and reports the result.
disable-model-invocation: true
argument-hint: "Describe one concrete Canvas App change, for example: Change DebuggingScreen.Height from App.Height to App.Height + 1."
---
<!--
   Copyright 2025-2026 Coder, Kyle J. (github.com/KCoderVA)

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->

# Autonomous Canvas App Change and Enterprise Release

Execute the Canvas App modification supplied as the plain-language argument to
this prompt. Carry it through the active coauthoring session, semantic
versioning, local release documentation, the repository's enterprise release
script, and final remote verification.

Perform the work rather than only describing a plan. Use engineering judgment
to translate the request into the smallest complete Canvas App change. Claim
success only when the relevant tool or command supplies evidence.

## Fixed project configuration

- Workspace:
  `S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp`
- Enterprise repository:
  `https://va.ghe.com/software/578-EHRM-TrainingSchedulerApp`
- Git remote and base branch: `origin` / `main`
- Canvas version expression:
  `Set(varRepoVersion, "MAJOR.MINOR.PATCH")` in `App.OnStart`
- Project version file: `.\VERSION`
- Changelog: `.\CHANGELOG.md`
- Release artifacts: `.\docs\release-notes\`
- Release templates: `.\docs\release-notes\releaseTemplates\`
- Release script:
  `.\docs\release-notes\releaseTemplates\enterpriseCommitGuide.ps1`
- Requested-change version increment: **PATCH**

## Operating rules

1. Inspect before editing. Never guess a screen, control, property, formula, or
   dependency.
2. Always call `sync_canvas` before reading or editing Canvas YAML.
3. Use the established coauthoring sequence:
   **sync current YAML -> edit synchronized YAML -> `compile_canvas` -> fresh
   sync verification**.
4. In this environment, `compile_canvas` has propagated validated YAML edits
   into the connected coauthoring session. A fresh server sync containing the
   requested edits is the required proof that propagation succeeded.
5. Do not require separately named Canvas save or publish tools. Coauthoring
   propagation and fresh-sync verification are sufficient for this workflow.
6. Existing Canvas diagnostics do not automatically block a change. Compare
   against the baseline and block only for new errors caused by this workflow.
7. Keep Canvas `varRepoVersion`, repository `VERSION`, changelog release entry,
   and release artifact filenames aligned before invoking the release script.
8. Preserve unrelated user work. Never revert or overwrite changes you did not
   make.
9. The release script uses `git add --all`; therefore inspect the complete
   worktree before running it. Proceed only when every pending file is intended
   for the release or is already part of the user's prepared release set.
10. The release script owns branch creation, staging, commit, push, PR, checks,
    merge, tag, GitHub release, archival, next-cycle bump, and mirror sync. Do
    not duplicate these operations manually.
11. Never expose credentials, tokens, or private authentication material.

---

## Step 1 — Interpret and investigate the requested change

1. Treat the plain-language argument supplied with this prompt as the assigned
   Canvas App modification.
2. Confirm the Canvas Authoring connection is active for the intended app. If
   needed, reconnect to the same app using known session details.
3. Sync the live app into a dedicated absolute directory outside the Git
   repository.
4. Search and analyze all relevant `.pa.yaml` files to identify:
   - the exact target screen, control, component, property, or formula;
   - references and dependencies that could be affected;
   - the active `App.OnStart` `varRepoVersion` assignment.
5. Distinguish executable formulas from comments, string literals, release-note
   text, and historical code blocks.
6. If multiple materially different targets remain plausible, ask the user to
   choose. Otherwise proceed with the most precise interpretation.
7. Capture the baseline using `compile_canvas`, app checker, and accessibility
   checker where available. Record pre-existing diagnostics.

## Step 2 — Modify and verify the coauthored Canvas App

1. Apply the smallest complete YAML edit needed for the requested behavior.
2. Find the one active expression:

   ```powerfx
   Set(varRepoVersion, "OLD_VERSION")
   ```

3. Parse `OLD_VERSION` as `MAJOR.MINOR.PATCH`, increase only `PATCH` by one,
   and call the result `RELEASE_VERSION`.
4. Change the active expression to:

   ```powerfx
   Set(varRepoVersion, "RELEASE_VERSION")
   ```

5. Do not update commented or historical version references unless required by
   the user's request.
6. Run `compile_canvas` on the modified directory.
7. Compare diagnostics with the baseline:
   - correct and retry any new errors introduced by these edits;
   - unchanged pre-existing diagnostics may remain;
   - if the new errors cannot be corrected safely, restore only this
     workflow's Canvas edits and stop.
8. Run `sync_canvas` into a separate verification directory.
9. Confirm from that fresh server copy that:
   - the requested change is present exactly;
   - active `varRepoVersion` equals `RELEASE_VERSION`;
   - no unrelated Canvas properties or formulas changed.
10. If either edit is absent, reassess and retry the edit/compile sequence once.
    If propagation still fails, stop before modifying repository release files.

## Step 3 — Update project versioning and CHANGELOG.md

From the fixed workspace:

1. Read `VERSION`, `CHANGELOG.md`, `.github\copilot-instructions.md`, recent
   release documents, and the release templates.
2. Follow the repository's archival conventions before modifying tracked
   artifacts when an archive is required.
3. Set `VERSION` to `RELEASE_VERSION`.
4. Preserve the existing `CHANGELOG.md` format, chronology, heading structure,
   style, and all historical entries.
5. Keep `## [Unreleased]` first, then insert:

   ```markdown
   ## [RELEASE_VERSION] - YYYY-MM-DD
   ```

6. Include only applicable Keep-a-Changelog sections.
7. Document:
   - the exact target and before/after Canvas values;
   - the functional or technical effect;
   - `varRepoVersion` `OLD_VERSION -> RELEASE_VERSION`;
   - successful compile and fresh-sync verification;
   - relevant unchanged pre-existing diagnostics, if any.

## Step 4 — Prepare release documents

The release script requires these exact files:

```text
.\docs\release-notes\vRELEASE_VERSION_commitMessage.md
.\docs\release-notes\vRELEASE_VERSION_pullRequest.md
.\docs\release-notes\vRELEASE_VERSION_releaseNotes.md
```

1. Generate them from:
   - `releaseTemplates\TEMPLATE_commitMessage.md`;
   - `releaseTemplates\TEMPLATE_pullRequest.md`;
   - `releaseTemplates\TEMPLATE_releaseNotes.md`.
2. Preserve the established document structures and replace all applicable
   placeholders with verified facts.
3. Remove unused template sections and all unresolved placeholder tokens.
4. Keep the commit title brief and conventional, for example:

   ```text
   fix(canvas-app): vRELEASE_VERSION — update DebuggingScreen height
   ```

5. The PR and release notes must describe the Canvas change, semantic-version
   transition, repository version/changelog updates, validation, and files
   included in the release.
6. Generate the release-notes document even if the user mentioned only commit
   and PR text because the automation requires it for the GitHub release.

## Step 5 — Validate the complete local release set

1. Run:

   ```powershell
   git status --short
   git diff --check
   git diff -- VERSION CHANGELOG.md docs/release-notes
   ```

2. Inspect every pending modified, renamed, deleted, and untracked file because
   the release script stages everything.
3. Confirm:
   - `VERSION` equals `RELEASE_VERSION`;
   - `CHANGELOG.md` has the matching dated release entry;
   - all three matching release documents exist;
   - titles and contents match the actual change;
   - no template placeholders remain;
   - no credentials or authentication artifacts are present;
   - every pending file belongs to the intended release set.
4. If unrelated changes would be committed, stop and identify them instead of
   running the script.

## Step 6 — Run and monitor enterpriseCommitGuide.ps1

1. Run PowerShell 7 from the repository root:

   ```powershell
   Set-Location "S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp"
   & ".\docs\release-notes\releaseTemplates\enterpriseCommitGuide.ps1"
   ```

2. Use synchronous execution with a long initial wait. If it continues in the
   background, retain the shell ID and use the shell-read tool until it exits.
   Never launch a second copy while the first is active.
3. Monitor its phases:
   - branch creation;
   - staging, commit, and push;
   - draft PR creation;
   - checks, ready transition, and merge;
   - annotated tag and GitHub release;
   - next-cycle patch bump;
   - release artifact archival/reset;
   - public mirror synchronization.
4. If authentication or user interaction is required, surface it rather than
   guessing credentials.
5. If the script fails, record the exact phase and error. Inspect local and
   remote state before retrying any completed operation.
6. The script intentionally increments `VERSION` again after releasing:
   - released/tagged version: `RELEASE_VERSION`;
   - local post-run `VERSION`: next patch for the following release cycle.

## Step 7 — Verify VA GitHub Enterprise

After successful script completion, query
`https://va.ghe.com/software/578-EHRM-TrainingSchedulerApp` with authenticated
`gh`, Git, GitHub tools, or the GHES API.

Verify:

1. the release PR exists and was merged into `main`;
2. the merged commit contains the intended release files;
3. remote `main` contains the correct changelog entry, released `VERSION`, and
   all three release documents;
4. tag `vRELEASE_VERSION` exists;
5. the GitHub release for `vRELEASE_VERSION` exists;
6. mirror synchronization succeeded if reported by the script;
7. the local repository returned to `main`;
8. local `VERSION` contains the expected next-cycle patch.

Report any discrepancy rather than silently accepting the script's output.

## Step 8 — Final response

Respond with a concise verified report:

```text
Completed Canvas App vRELEASE_VERSION and enterprise release <PR_URL>.

Canvas App:
- <exact requested change and before -> after value>
- App.OnStart varRepoVersion: OLD_VERSION -> RELEASE_VERSION
- Coauthoring verification: fresh sync confirmed both edits

Repository:
- Released VERSION: RELEASE_VERSION
- CHANGELOG.md: matching dated entry added
- Commit: <SHA and title>
- PR: <number, URL, merged status>
- Tag/release: vRELEASE_VERSION
- Local next-cycle VERSION: <post-script value>

Validation:
- <compile/app-checker/accessibility result>
- <unchanged pre-existing diagnostics, if applicable>
```

If incomplete, state the last successful step, exact failure, whether the
Canvas edits propagated, and whether any commit, PR, merge, tag, or release was
created. Never present partial completion as complete.
