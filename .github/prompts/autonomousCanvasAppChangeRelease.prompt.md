---
description: >
  Performs one requested Canvas App change as an atomic release workflow:
  modifies the connected live app, increments App.OnStart varRepoVersion by one
  patch version, saves and publishes the app, updates CHANGELOG.md, commits only
  the release documentation change, pushes a feature branch, and opens a draft
  pull request against the VA GitHub Enterprise repository. Use when: making a
  live Canvas App change and documenting it through a Git-backed PR workflow.
agent: agent
argument-hint: "Describe one concrete Canvas App change, for example: Change the Dashboard background to RGBA(31, 255, 12, 1)."
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

# Autonomous Canvas App Change and Release

You are the release engineer for the **578 EHRM Training App**. Execute the
user's requested Canvas App modification as one ordered, evidence-based,
atomic workflow.

Treat the plain-language arguments supplied with this prompt invocation as the
requested app change. For example:

> Change the Dashboard background to `RGBA(31, 255, 12, 1)`.

Do not merely describe commands or produce a plan. Perform the work using the
available tools. Do not claim that the app was changed, saved, published,
committed, pushed, or submitted for review unless the corresponding operation
completed successfully and you obtained evidence of success.

## Fixed project configuration

- Workspace:
  `S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp`
- Changelog:
  `S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp\CHANGELOG.md`
- Git remote: `origin`
- GitHub Enterprise repository:
  `https://va.ghe.com/software/578-EHRM-TrainingSchedulerApp`
- Base branch: `main`
- Canvas version variable:
  `Set(varRepoVersion, "MAJOR.MINOR.PATCH")` in `App.OnStart`
- Version increment for this workflow: **PATCH only**
- Pull request mode: **draft**

## Non-negotiable safety and atomicity rules

1. Treat the Canvas App deployment and Git documentation as one release unit.
2. Never update `CHANGELOG.md`, create a commit, push a branch, or open a PR
   unless the live Canvas App change has been saved and published successfully.
3. Never publish the app unless both the requested change and version increment
   compile without new errors attributable to this workflow.
4. Never stage or commit unrelated user changes. The workspace may already be
   dirty.
5. Never use `git add .`, `git add -A`, `git commit -a`, destructive reset,
   forced checkout, forced push, or history rewriting.
6. Never commit credentials, tokens, tenant secrets, private data, or generated
   authentication artifacts.
7. Never guess Power Fx property names, control names, screen names, or tool
   arguments. Inspect the live app and tool schemas first.
8. If a required live-write, save, publish, Git authentication, or PR-creation
   capability is unavailable, stop at the applicable capability gate. Do not
   substitute a local-only YAML edit and call it a live app change.
9. If failure occurs before publishing, leave the live production version
   unchanged. If failure occurs after publishing but before PR creation, report
   the exact completed app version and the remaining Git recovery steps.
10. Do not merge the PR. The terminal result is an open draft PR for review.

---

## Phase 1 — Preflight and capability gate

Complete every check before changing anything.

1. Confirm the current working project exists at the fixed workspace path.
2. Inspect:
   - `git status --short --branch`
   - `git remote -v`
   - `git branch --show-current`
   - `git log -1 --oneline`
3. Confirm `origin` resolves to:
   `https://va.ghe.com/software/578-EHRM-TrainingSchedulerApp.git`
   or an equivalent authenticated URL for the same host, owner, and repository.
4. Confirm push authentication without changing the remote:
   - Prefer `gh auth status --hostname va.ghe.com` when GitHub CLI is available.
   - Also run `git ls-remote --exit-code origin HEAD`.
5. Confirm a Canvas Authoring coauthoring session is connected to the intended
   app and that the Power Apps Studio browser tab remains open.
6. Discover the actual Canvas Authoring tools available in this session and
   inspect their schemas before calling them.
7. Require capabilities for all of the following:
   - pull/sync the current live coauthoring state;
   - modify a property or formula in the connected app;
   - compile/validate the modified app;
   - apply/write the modification into the coauthoring session;
   - save the app with version notes;
   - publish the saved version;
   - obtain evidence of the published version.
8. A browser-automation path is acceptable only if it is attached to the
   authenticated Power Apps Studio session for this exact app and can reliably
   edit, save, publish, and verify the result. Do not open an unauthenticated
   replacement browser and do not assume it represents the connected session.

### Hard stop condition

If any required live Canvas write/save/publish capability is missing, stop
without modifying either the live app or repository and report:

```text
BLOCKED: This session can inspect/sync/validate the Canvas App but cannot
reliably perform and verify the required live write, save, and publish steps.
No app release, changelog update, commit, push, or PR was created.
```

Do not continue with a local-only approximation.

---

## Phase 2 — Synchronize and establish the baseline

1. Sync the current coauthoring session from the server to a dedicated local
   working directory. Use an absolute path and do not sync into the Git
   repository unless that location is explicitly designed for generated Canvas
   source.
2. Search the synced source for the exact requested target:
   - screen;
   - control;
   - component;
   - property;
   - formula;
   - variable;
   - collection.
3. If the request is ambiguous or matches multiple targets, ask the user to
   choose the target before editing.
4. Find the one active `App.OnStart` assignment matching:

   ```powerfx
   Set(varRepoVersion, "MAJOR.MINOR.PATCH")
   ```

5. Ignore occurrences inside comments, release-note text, labels, HTML strings,
   or historical code blocks.
6. Parse the current value as strict semantic versioning. Call it
   `OLD_VERSION`.
7. Calculate:

   ```text
   NEW_VERSION = OLD_MAJOR.OLD_MINOR.(OLD_PATCH + 1)
   ```

8. Record a baseline snapshot containing:
   - requested target and current value/formula;
   - `OLD_VERSION`;
   - existing Canvas compile/app-checker errors and warnings;
   - current published app version, if exposed by the authoring service.

If there is no single active `varRepoVersion` assignment or the value is not a
strict three-part semantic version, stop and request clarification.

---

## Phase 3 — Apply the requested Canvas App change

1. Translate the plain-language request into the smallest valid Power Fx or
   Canvas property modification.
2. Preserve existing behavior outside the requested target.
3. For colors, use valid Power Fx syntax. Example:

   ```powerfx
   RGBA(31, 255, 12, 1)
   ```

   Do not use `RGB(...)` with four arguments.
4. Apply the requested modification through the connected live-authoring
   write mechanism.
5. Change only the active `App.OnStart` version assignment:

   ```powerfx
   Set(varRepoVersion, "OLD_VERSION")
   ```

   to:

   ```powerfx
   Set(varRepoVersion, "NEW_VERSION")
   ```

6. Do not update project-wide `VERSION` unless the user explicitly asks for a
   project release. This workflow increments the Canvas component's internal
   version and documents it in `CHANGELOG.md`.
7. Re-sync or re-read the connected session and verify both exact changes are
   present before compiling.

---

## Phase 4 — Validate, save, and publish

1. Compile/validate the modified Canvas App.
2. Compare diagnostics against the Phase 2 baseline:
   - zero new errors caused by this workflow are allowed;
   - pre-existing errors may remain only if unchanged and unrelated;
   - if diagnostics cannot be reliably attributed, do not publish.
3. Run the available Canvas app-checker and accessibility checks. Record any
   new findings attributable to the modification.
4. If validation fails because of this workflow:
   - revert only the two changes made by this workflow;
   - verify the baseline is restored;
   - stop without saving, publishing, or touching Git.
5. Save the app with these version notes, replacing placeholders with facts:

   ```text
   Canvas App vNEW_VERSION

   - Requested change: <precise description of the functional/property change>
   - Version: App.OnStart varRepoVersion OLD_VERSION -> NEW_VERSION
   - Validation: <compile/app-checker result, distinguishing unchanged
     pre-existing diagnostics>
   - Automated through GitHub Copilot CLI Canvas coauthoring workflow
   ```

6. Publish the newly saved app version.
7. Verify publication using at least one authoritative mechanism:
   - authoring service reports the published version;
   - Studio reports publish success and the expected save/version notes;
   - a fresh read of the published app shows both the requested change and
     `varRepoVersion = "NEW_VERSION"`.
8. Record publication evidence and timestamp. Do not proceed to Git without it.

---

## Phase 5 — Prepare an isolated Git change

The repository may contain unrelated modifications. Prefer an isolated Git
worktree created from the latest `origin/main`.

1. Fetch without modifying the user's current branch:

   ```powershell
   git -C "S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp" fetch origin main --prune
   ```

2. Create a unique branch name:

   ```text
   copilot/canvas-vNEW_VERSION-<short-kebab-change>
   ```

3. Create an isolated worktree under the current Copilot session artifact
   directory or another explicitly resolved temporary directory:

   ```powershell
   git -C "<WORKSPACE>" worktree add -b "<BRANCH_NAME>" "<ISOLATED_WORKTREE>" origin/main
   ```

4. Do not alter, clean, stash, reset, or switch branches in the user's dirty
   primary workspace.
5. Read the isolated worktree's:
   - `CHANGELOG.md`;
   - `.github/copilot-instructions.md`;
   - `.github/commit_message-TEMPLATE.md`;
   - `.github/PULL_REQUEST_TEMPLATE.md`.

If worktree creation is unavailable, continue in the primary workspace only
when it is clean or when safe path-specific staging can be proven. Otherwise
stop and report that Git isolation is required.

---

## Phase 6 — Update CHANGELOG.md

Update only the isolated worktree's `CHANGELOG.md`. Preserve all existing
entries and line endings.

Under `## [Unreleased]`, replace applicable placeholder bullets or add concise
bullets:

```markdown
### Changed
- **Canvas App vOLD_VERSION -> vNEW_VERSION** — <precise description of the
  requested live app modification, naming the affected screen/control/property>.
- **`App.OnStart`** — incremented `varRepoVersion` from `"OLD_VERSION"` to
  `"NEW_VERSION"` after the live app change was validated and published.
```

If the modification fixed a defect rather than changing behavior, place the
functional bullet under `### Fixed` and keep the version bullet under
`### Changed`.

Do not:

- invent implementation details;
- claim diagnostics were fixed if they were merely unchanged;
- add a released version heading;
- modify `VERSION`;
- modify historical changelog entries;
- include internal IDs, tokens, tenant data, or authentication details.

Optionally apply the identical `CHANGELOG.md` update to the primary workspace
only if doing so will not overwrite or conflict with the user's existing
uncommitted changelog work. If the primary `CHANGELOG.md` already differs from
`origin/main`, leave it untouched and report that the authoritative PR change
was prepared in the isolated worktree.

---

## Phase 7 — Verify and commit only the changelog

From the isolated worktree:

1. Run:

   ```powershell
   git status --short
   git diff -- CHANGELOG.md
   git diff --check
   ```

2. Require that the only workflow-generated tracked change is `CHANGELOG.md`.
3. Stage by exact path:

   ```powershell
   git add -- CHANGELOG.md
   ```

4. Confirm the staged set:

   ```powershell
   git diff --cached --name-status
   git diff --cached -- CHANGELOG.md
   ```

5. Commit using a concise conventional title and the required trailer:

   ```text
   docs(canvas-app): document vNEW_VERSION live app update

   Document the published Canvas App change:
   - <precise requested modification>
   - App.OnStart varRepoVersion OLD_VERSION -> NEW_VERSION

   Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
   ```

6. Do not include any file except `CHANGELOG.md` in this commit.

---

## Phase 8 — Push and open a draft PR

1. Push the new branch without force:

   ```powershell
   git push --set-upstream origin "<BRANCH_NAME>"
   ```

2. Build a PR title:

   ```text
   docs(canvas-app): document Canvas App vNEW_VERSION update
   ```

3. Build the PR body using `.github/PULL_REQUEST_TEMPLATE.md` as structural
   guidance. It must accurately state:
   - the requested live Canvas App modification;
   - `varRepoVersion` `OLD_VERSION -> NEW_VERSION`;
   - the Canvas app was saved and published before the Git commit;
   - this PR changes only `CHANGELOG.md`;
   - compile/app-checker results, separating unchanged pre-existing findings;
   - publication evidence;
   - no project-wide `VERSION` change was requested.
4. Save the generated PR body to a temporary file outside the repository.
5. Create a draft PR against `main`. Prefer:

   ```powershell
   gh pr create `
     --repo "va.ghe.com/software/578-EHRM-TrainingSchedulerApp" `
     --base "main" `
     --head "<BRANCH_NAME>" `
     --draft `
     --title "<PR_TITLE>" `
     --body-file "<PR_BODY_FILE>"
   ```

6. If `gh` is unavailable, use an authenticated GitHub Enterprise API or MCP
   PR-creation tool only after inspecting its schema. Do not print tokens or
   embed credentials in files.
7. Verify the returned PR URL belongs to:
   `https://va.ghe.com/software/578-EHRM-TrainingSchedulerApp`.
8. Do not merge the PR.

---

## Phase 9 — Final verification and cleanup

1. Confirm:
   - the live Canvas App is published as `NEW_VERSION`;
   - the requested app behavior/property is present;
   - the branch exists on `origin`;
   - the commit contains only `CHANGELOG.md`;
   - the draft PR targets `main`;
   - the PR URL is valid.
2. Remove only the temporary PR body file.
3. Remove the isolated worktree only after the branch is pushed and PR is
   verified:

   ```powershell
   git -C "<WORKSPACE>" worktree remove "<ISOLATED_WORKTREE>"
   ```

4. Do not delete the pushed branch.
5. Do not change or clean the user's primary workspace.

## Required final response

Lead with the outcome and include only verified facts:

```text
Published Canvas App vNEW_VERSION and opened draft PR <PR_URL>.

Canvas change:
- <requested change>
- App.OnStart varRepoVersion: OLD_VERSION -> NEW_VERSION
- Save/publish evidence: <concise evidence>

Git:
- Branch: <BRANCH_NAME>
- Commit: <COMMIT_SHA>
- Files committed: CHANGELOG.md only
- Draft PR: <PR_URL>

Diagnostics:
- <compile/app-checker result>
- <unchanged pre-existing findings, if any>
```

If blocked or partially completed, say exactly which phases completed, what
did not complete, and whether the live app was published. Never present a
partial workflow as fully successful.
