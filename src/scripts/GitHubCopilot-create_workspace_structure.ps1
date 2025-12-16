param(
    [Parameter(Mandatory=$true)]
    [string]$RootPath,  # e.g., "S:\Informatics\Data Team\Coder - Informatics\App Programing\EHRM_TrainingBookingApp"
    [string]$SolutionName = "EHRMTrainingBooking",
    [string]$CanvasAppFolderName = "EHRMTrainingBookingApp",
    [string]$ProjectDisplayName = "EHRM Training & Booking App",
    [string]$OrgName = "Edward Hines Jr. VA Hospital (Station #578), VISN12, U.S. Department of Veterans Affairs"
)

function Ensure-Folder {
    param([string]$Path)
    if (-not (Test-Path -Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
        Write-Host "Created: $Path" -ForegroundColor Green
    } else {
        Write-Host "Exists:  $Path" -ForegroundColor Gray
    }
}

function Ensure-File {
    param(
        [string]$Path,
        [string]$Content,
        [switch]$Force
    )
    if ((-not (Test-Path -Path $Path)) -or $Force) {
        $parent = Split-Path -Parent $Path
        if ($parent -and -not (Test-Path $parent)) {
            New-Item -ItemType Directory -Path $parent | Out-Null
            Write-Host "Created parent folder: $parent" -ForegroundColor Green
        }
        $Content | Out-File -FilePath $Path -Encoding UTF8
        Write-Host "Created: $Path" -ForegroundColor Green
    } else {
        Write-Host "Exists:  $Path" -ForegroundColor Gray
    }
}

# 1) Create folders
$folders = @(
    "$RootPath\.vscode",
    "$RootPath\.github\workflows",
    "$RootPath\.github\ISSUE_TEMPLATE",
    "$RootPath\assets\images",
    "$RootPath\assets\branding",
    "$RootPath\assets\dataInputs",
    "$RootPath\docs\changeLogs",
    "$RootPath\docs\developerNotes",
    "$RootPath\docs\userGuides",
    "$RootPath\docs\architecture",
    "$RootPath\docs\runbooks",
    "$RootPath\src\solutions\$SolutionName",
    "$RootPath\src\powerApps\CanvasApps\$CanvasAppFolderName",
    "$RootPath\src\powerAutomate\flows",
    "$RootPath\src\sharePoint\lists",
    "$RootPath\src\powerBi\reports",
    "$RootPath\src\sql\queries",
    "$RootPath\src\sql\storedProcedures",
    "$RootPath\src\scripts\pwsh",
    "$RootPath\src\scripts\python",
    "$RootPath\src\scripts\js",
    "$RootPath\src\scripts\hooks",
    "$RootPath\src\webResources\css",
    "$RootPath\src\webResources\js",
    "$RootPath\src\webResources\html",
    "$RootPath\src\config\env\dev",
    "$RootPath\src\config\env\test",
    "$RootPath\src\config\env\prod",
    "$RootPath\src\config\templates",
    "$RootPath\tests\scripts",
    "$RootPath\tests\unit",
    "$RootPath\tools\pac",
    "$RootPath\tools\cli",
    "$RootPath\dist\release",
    "$RootPath\dist\debug",
    "$RootPath\config\public",
    "$RootPath\config\local",
    "$RootPath\archive",
    "$RootPath\logs\build",
    "$RootPath\logs\deploy",
    "$RootPath\tmp",
    "$RootPath\git\hooks"
)

foreach ($f in $folders) { Ensure-Folder $f }

# 2) Template files

# .editorconfig
$editorConfig = @"
root = true

[*]
charset = utf-8
end_of_line = crlf
insert_final_newline = true
indent_style = space
indent_size = 2
trim_trailing_whitespace = true

[*.ps1]
indent_size = 2

[*.md]
max_line_length = off
"@
Ensure-File -Path "$RootPath\.editorconfig" -Content $editorConfig

# .gitattributes (normalize line endings; keep binary types)
$gitattributes = @"
* text=auto eol=crlf
*.ps1 text eol=crlf
*.md text eol=lf
*.json text eol=lf
*.yaml text eol=lf
*.yml text eol=lf

# Binary files
*.msapp binary
*.zip binary
*.pbix binary
*.pbit binary
"@
Ensure-File -Path "$RootPath\.gitattributes" -Content $gitattributes

# .gitignore
$gitignore = @"
# Keep repo fast and clean: commit unpacked source, not binaries
dist/
tmp/
logs/
*.msapp
*.zip

# Power BI (choose whether to commit large files)
# *.pbix
# *.pbit

# Local-only configs/secrets
config/local/
*.env
*.env.*
.secrets/
secrets.*
credentials.*

# Dependencies and build artifacts
node_modules/
coverage/
__pycache__/
*.pyc
*.pyo

# OS/editor files
.DS_Store
Thumbs.db
desktop.ini
"@
Ensure-File -Path "$RootPath\.gitignore" -Content $gitignore

# README.md
$readme = @"
# $ProjectDisplayName

This repository contains the source (unpacked) Microsoft Power Platform artifacts, documentation, and automation for the $ProjectDisplayName used at $OrgName.

## Key folders
- `src/` — Unpacked, human-readable source for Power Apps (Canvas), Power Automate flows, SharePoint list schemas/formatting, SQL, scripts.
- `docs/` — User guides, changelogs, developer notes, architecture, runbooks.
- `dist/` — Exports/binaries used for import (kept local; not committed).
- `archive/` — Calendar-versioned historical snapshots (optional, public).
- `.github/workflows/` — CI automation for packing/validation.
- `.vscode/` — Shared workspace settings and tasks.

## Daily workflow (summary)
1. Make changes in Dev environment (web editor), inside a Solution when possible.
2. Export Solution (or .msapp) to `dist/release`.
3. Unpack to `src/...` (overwrite/clean so only latest source is present).
4. Use Copilot Agent to summarize changes, update docs, propose commit message.
5. Commit `src/` and `docs/`, tag release (semantic version).
6. Create a GitHub Release and optionally attach the export.
"@
Ensure-File -Path "$RootPath\README.md" -Content $readme

# SECURITY.md
$security = @"
# Security Policy

- Do not commit secrets or credentials. Use `config/local/` and environment variables.
- Keep exports (`.msapp`, Solution `.zip`) out of Git; attach to Releases if needed.
- Use Government endpoint for `pac` login when targeting `make.gov.powerapps.us`.
"@
Ensure-File -Path "$RootPath\SECURITY.md" -Content $security

# CONTRIBUTING.md
$contributing = @"
# Contributing

## Branches
- `main` — stable branch.
- Feature branches: `feature/<short-description>`.

## Commits
- Commit only unpacked source under `src/`, docs under `docs/`.
- Use clear, action-oriented commit messages.

## Pull Requests
- Describe changes, include screenshots if UI changes.
- Link to change logs and any environment notes.
"@
Ensure-File -Path "$RootPath\CONTRIBUTING.md" -Content $contributing

# CODE_OF_CONDUCT.md (simple placeholder)
$codeOfConduct = @"
# Code of Conduct

Be respectful and collaborative. Follow organizational policies and data handling guidelines.
"@
Ensure-File -Path "$RootPath\CODE_OF_CONDUCT.md" -Content $codeOfConduct

# docs/changeLogs/CHANGELOG.md
$changelog = @"
# Changelog

All notable changes to this project will be documented here.

## [Unreleased]
- Initial structure and templates.

## [0.1.0] - $(Get-Date -Format "yyyy-MM-dd")
- Initialized repository structure and automation.
"@
Ensure-File -Path "$RootPath\docs\changeLogs\CHANGELOG.md" -Content $changelog

# docs/developerNotes/ARCHITECTURE.md
$architecture = @"
# Architecture Overview

- Power Platform Solution: `$SolutionName`
- Components:
  - Canvas App: `$CanvasAppFolderName`
  - Flows: `src/powerAutomate/flows/`
  - SharePoint Lists: `src/sharePoint/lists/` (schemas, formatting JSON, permissions notes)
- Source Control: unpacked source in `src/`, binaries in `dist/`
"@
Ensure-File -Path "$RootPath\docs\architecture\ARCHITECTURE.md" -Content $architecture

# docs/runbooks/ALM-RUNBOOK.md
$runbook = @"
# ALM Runbook

## Export (Dev)
- Export Solution (unmanaged) to `dist/release/$SolutionName_Solution.zip`

## Unpack
- Unpack to `src/solutions/$SolutionName` with `--overwrite`

## Commit
- Commit `src/`, update `docs/changeLogs/`, tag semantic version

## Release
- Create GitHub Release, attach exported ZIP or `.msapp` (optional)
"@
Ensure-File -Path "$RootPath\docs\runbooks\ALM-RUNBOOK.md" -Content $runbook

# .vscode/settings.json
$vscodeSettings = @"
{
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "editor.formatOnSave": true,
  "powershell.codeFormatting.preset": "OTBS",
  "files.exclude": {
    "**/dist": true,
    "**/tmp": true,
    "**/.git": true
  }
}
"@
Ensure-File -Path "$RootPath\.vscode\settings.json" -Content $vscodeSettings

# .vscode/extensions.json
$vscodeExtensions = @"
{
  "recommendations": [
    "ms-powerplatform.powerplatform-vscode",
    "github.copilot",
    "github.copilot-chat",
    "ms-vscode.powershell",
    "yzhang.markdown-all-in-one"
  ]
}
"@
Ensure-File -Path "$RootPath\.vscode\extensions.json" -Content $vscodeExtensions

# .vscode/tasks.json
$vscodeTasks = @"
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Canvas: Unpack .msapp to src",
      "type": "shell",
      "command": "pac canvas unpack --msapp \"${workspaceFolder}/dist/release/$CanvasAppFolderName.msapp\" --source \"${workspaceFolder}/src/powerApps/CanvasApps/$CanvasAppFolderName\" --force",
      "problemMatcher": []
    },
    {
      "label": "Canvas: Pack src to .msapp",
      "type": "shell",
      "command": "pac canvas pack --msapp \"${workspaceFolder}/dist/release/$CanvasAppFolderName.msapp\" --sources \"${workspaceFolder}/src/powerApps/CanvasApps/$CanvasAppFolderName\"",
      "problemMatcher": []
    },
    {
      "label": "Solution: Export (unmanaged) to dist",
      "type": "shell",
      "command": "pac solution export --name \"$SolutionName\" --path \"${workspaceFolder}/dist/release/${SolutionName}_Solution.zip\" --managed false",
      "problemMatcher": []
    },
    {
      "label": "Solution: Unpack zip to src",
      "type": "shell",
      "command": "pac solution unpack --zipfile \"${workspaceFolder}/dist/release/${SolutionName}_Solution.zip\" --folder \"${workspaceFolder}/src/solutions/$SolutionName\" --overwrite true",
      "problemMatcher": []
    }
  ]
}
"@
Ensure-File -Path "$RootPath\.vscode\tasks.json" -Content $vscodeTasks

# .github/workflows/powerplatform-ci.yml
$workflow = @"
name: Power Platform CI

on:
  push:
    branches: [ "main" ]
  workflow_dispatch:

jobs:
  validate-and-pack:
    runs-on: windows-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Power Platform CLI
        uses: microsoft/powerplatform-actions/setup@v1

      - name: Pack Solution from src
        run: |
          pac solution pack --folder ""$`{{ github.workspace }}\\src\\solutions\\$SolutionName"" --zipfile ""$`{{ github.workspace }}\\dist\\release\\${SolutionName}_Solution.zip"" --packageType Unmanaged
"@
Ensure-File -Path "$RootPath\.github\workflows\powerplatform-ci.yml" -Content $workflow

# .github/ISSUE_TEMPLATE/bug_report.md
$issueBug = @"
---
name: Bug report
about: Report a problem or unexpected behavior
title: '[BUG] '
labels: bug
assignees: ''
---

## Description
Describe the issue.

## Steps to Reproduce
1.
2.

## Expected Behavior

## Screenshots

## Environment
- Solution: $SolutionName
- App: $CanvasAppFolderName
"@
Ensure-File -Path "$RootPath\.github\ISSUE_TEMPLATE\bug_report.md" -Content $issueBug

# .github/ISSUE_TEMPLATE/feature_request.md
$issueFeature = @"
---
name: Feature request
about: Suggest an idea for improvement
title: '[FEATURE] '
labels: enhancement
assignees: ''
---

## Summary

## Motivation

## Proposal

## Notes
"@
Ensure-File -Path "$RootPath\.github\ISSUE_TEMPLATE\feature_request.md" -Content $issueFeature

# .github/copilot-instructions.md (org-level Agent guidance)
$copilotOrg = @"
# Copilot Instructions (GitHub context)

## Purpose
Guide GitHub Copilot and Copilot Chat to help with ALM tasks, documentation, and code reviews.

## Focus Areas
- Read unpacked source in `src/`.
- Propose `docs/changeLogs/` entries.
- Suggest semantic version tags and Release notes.
- Assist with `pac` commands for export/unpack/pack.
"@
Ensure-File -Path "$RootPath\.github\copilot-instructions.md" -Content $copilotOrg

# Project-level Copilot instructions (root)
$copilotRoot = @"
# Copilot Agent Instructions

## Goal
Maintain ALM hygiene and documentation for `$ProjectDisplayName`.

## Tasks
- Generate changelog entries in `docs/changeLogs/`.
- Produce developer notes in `docs/developerNotes/`.
- Update user guides in `docs/userGuides/`.
- Recommend commit messages and semantic version tags.
- Use `.vscode/tasks.json` to run pack/unpack tasks.

## Rules
- Do not commit binaries; keep exports under `dist/`.
- Highlight breaking changes and permission updates.
"@
Ensure-File -Path "$RootPath\copilot-instructions.md" -Content $copilotRoot

# AGENTS.md (describe helper agents/tools)
$agents = @"
# AGENTS

## Copilot Chat (VS Code)
- Use tasks under `.vscode/tasks.json` to run `pac` commands.
- Summarize diffs in `src/` and propose documentation updates.

## Power Platform CLI (pac)
- Export Solution (unmanaged) to `dist`.
- Unpack Solution to `src`.
- Pack Solution from `src` when preparing deployment.

## Git Hooks (optional)
- Place managed hooks in `src/scripts/hooks/` or `git/hooks/`.
"@
Ensure-File -Path "$RootPath\AGENTS.md" -Content $agents

# Starter PowerShell helper (tools\pac\alm.ps1)
$almScript = @"
param(
  [string]\$Action = ""export-and-unpack"", # other: pack
  [string]\$SolutionName = ""$SolutionName"",
  [string]\$Root = ""$RootPath""
)

function Export-Unpack {
  \$zip = Join-Path \$Root ""dist\\release\\\${SolutionName}_Solution.zip""
  pac solution export --name \$SolutionName --path \$zip --managed false
  pac solution unpack --zipfile \$zip --folder (Join-Path \$Root ""src\\solutions\\\${SolutionName}"") --overwrite true
  Write-Host ""Exported and unpacked solution: \$SolutionName""
}

function Pack-Solution {
  \$zip = Join-Path \$Root ""dist\\release\\\${SolutionName}_Solution.zip""
  pac solution pack --folder (Join-Path \$Root ""src\\solutions\\\${SolutionName}"") --zipfile \$zip --packageType Unmanaged
  Write-Host ""Packed solution to: \$zip""
}

switch (\$Action) {
  ""export-and-unpack"" { Export-Unpack }
  ""pack"" { Pack-Solution }
  default { Write-Host ""Unknown action: \$Action"" -ForegroundColor Red }
}
"@
Ensure-File -Path "$RootPath\tools\pac\alm.ps1" -Content $almScript

# Basic git hooks examples (PowerShell)
$preCommit = @"
# pre-commit.ps1
Write-Host ""[pre-commit] Validating repository content...""
# Example: prevent committing dist/ binaries
\$changed = git diff --cached --name-only
if (\$changed | Where-Object { \$_ -match '^dist/' }) {
  Write-Host ""Do not commit files under dist/"" -ForegroundColor Red
  exit 1
}
"@
Ensure-File -Path "$RootPath\git\hooks\pre-commit.ps1" -Content $preCommit

$prePush = @"
# pre-push.ps1
Write-Host ""[pre-push] Running quick checks...""
# Add any lightweight validation here (linting, etc.)
"@
Ensure-File -Path "$RootPath\git\hooks\pre-push.ps1" -Content $prePush

Write-Host "`nAll structure and templates created. Next:" -ForegroundColor Cyan
Write-Host "- Configure pac authentication for your US Government environment" -ForegroundColor Cyan
Write-Host "- Use VS Code tasks to export/unpack and commit src/ changes" -ForegroundColor Cyan
Write-Host "- Keep dist/ out of Git; attach exports to Releases if needed" -ForegroundColor Cyan