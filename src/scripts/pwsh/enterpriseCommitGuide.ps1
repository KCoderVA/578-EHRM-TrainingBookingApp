#Requires -Version 7
# Copyright 2026-07-10 Coder, Kyle J. (github.com/KCoderVA)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Halt immediately on any error (cmdlets and, in PS 7.3+, native commands)
$ErrorActionPreference              = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

# ── Output helpers ────────────────────────────────────────────────────────────
function Step { param([string]$Msg) Write-Host "`n── $Msg" -ForegroundColor Cyan   }
function Done { param([string]$Msg) Write-Host "   ✓  $Msg" -ForegroundColor Green  }

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 1 — Validate prerequisites & declare variables
# ═════════════════════════════════════════════════════════════════════════════
Step "Validating prerequisites and declaring variables"

if (-not (Test-Path ".\VERSION")) {
    throw ".\VERSION not found — run this script from the repo root."
}

$BaseBranch  = "main"
$ReleaseVer  = (Get-Content -Raw ".\VERSION").Trim()
$ReleaseTag  = "v$ReleaseVer"
$Branch      = "pr/release-$ReleaseTag"
$CommitFile  = ".\docs\release-notes\${ReleaseTag}_commitMessage.md"
$PrFile      = ".\docs\release-notes\${ReleaseTag}_pullRequest.md"
$RnotesFile  = ".\docs\release-notes\${ReleaseTag}_releaseNotes.md"

foreach ($f in @($CommitFile, $PrFile, $RnotesFile)) {
    if (-not (Test-Path $f)) { throw "Required release artifact not found: $f" }
}

$CommitTitle = (Get-Content $CommitFile -TotalCount 1).Trim()
$PrTitle     = (Get-Content $PrFile     -TotalCount 1).Trim()

Done "Releasing $ReleaseTag via branch '$Branch'"

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 2 — Sync main, create release branch, commit & push
# ═════════════════════════════════════════════════════════════════════════════
Step "Syncing main, creating release branch, committing and pushing"

git switch $BaseBranch
git pull --ff-only
git switch --force-create $Branch
git add --all
git commit -m $CommitTitle -m (Get-Content -Raw $CommitFile)
git push --set-upstream origin $Branch

Done "Branch '$Branch' committed and pushed to origin"

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 3 — Open draft PR, watch checks, mark ready, merge
# ═════════════════════════════════════════════════════════════════════════════
Step "Creating draft pull request"

gh pr create `
    --assignee "@me" `
    --draft `
    --base $BaseBranch `
    --head $Branch `
    --title $PrTitle `
    --body-file $PrFile

$PrNumber = gh pr view --json number -q .number
Done "Draft PR #$PrNumber created"

Step "Watching automated checks on PR #$PrNumber (waiting for all to pass)"
gh pr checks $PrNumber --watch

Step "Marking PR #$PrNumber ready for review and merging"
gh pr ready $PrNumber
gh pr merge $PrNumber --merge --delete-branch --admin

Done "PR #$PrNumber merged — branch '$Branch' deleted"

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 4 — Return to main and sync local repo
# ═════════════════════════════════════════════════════════════════════════════
Step "Returning to '$BaseBranch' and syncing local repo"

git switch $BaseBranch
git pull --ff-only
gh repo sync

$GitStatus = git status --short
Done "Local repo is up-to-date$(if ($GitStatus) { "`n       $GitStatus" })"

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 5 — Bump patch version (unstaged) for next release cycle
# ═════════════════════════════════════════════════════════════════════════════
Step "Bumping patch version for next release cycle"

$VerParts = ((Get-Content -Raw ".\VERSION").Trim()).Split('.')
$NextVer  = "$($VerParts[0]).$($VerParts[1]).$([int]$VerParts[2] + 1)"
Set-Content -Path ".\VERSION" -Value $NextVer

Done "VERSION: $($VerParts -join '.') → $NextVer  (unstaged — ready for next release)"

Write-Host "`n══ $ReleaseTag released successfully!  Next version staged: $NextVer ══`n" -ForegroundColor Green

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 6 — Trigger the 'postEnterpriseCommitArchival.ps1' script
# ═════════════════════════════════════════════════════════════════════════════
Step "Auto-triggering the execution of the 'postEnterpriseCommitArchival.ps1' script, which will archive the previous release artifacts & reset the templates in preperation for the next release cycle"

& ".\src\scripts\pwsh\postEnterpriseCommitArchival.ps1"
