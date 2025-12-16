# ============================
# EHRM Training App Scaffold (Root-as-Repo Layout)
# ============================

# 1. SET YOUR ROOT PATH HERE (this is your Git root and project root)
$root = "S:\Informatics\Data Team\Coder - Informatics\App Programing\EHRM_TrainingBookingApp"

# Helper: create folder if missing
function New-DirSafe {
    param([string]$Path)
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path | Out-Null
    }
}

# Helper: create file with content if missing
function New-FileSafe {
    param(
        [string]$Path,
        [string]$Content = ""
    )
    if (-not (Test-Path $Path)) {
        New-Item -ItemType File -Path $Path -Force | Out-Null
        if ($Content -ne "") {
            Set-Content -Path $Path -Value $Content -Encoding UTF8
        }
    }
}

# 2. CREATE FOLDERS

# Root (Git root)
New-DirSafe $root

# src structure
$src = Join-Path $root "src"
New-DirSafe $src

$srcPowerApps = Join-Path $src "powerApps"
New-DirSafe $srcPowerApps
$srcPowerAppsUnpacked    = Join-Path $srcPowerApps "unpacked"
New-DirSafe $srcPowerAppsUnpacked
$srcPowerAppsUnpackedSrc = Join-Path $srcPowerAppsUnpacked "src"
New-DirSafe $srcPowerAppsUnpackedSrc

$srcPowerAutomate = Join-Path $src "powerAutomate"
New-DirSafe $srcPowerAutomate
New-DirSafe (Join-Path $srcPowerAutomate "definitions")
New-DirSafe (Join-Path $srcPowerAutomate "scripts")

$srcSharePoint = Join-Path $src "sharePoint"
New-DirSafe $srcSharePoint
New-DirSafe (Join-Path $srcSharePoint "schemas")
New-DirSafe (Join-Path $srcSharePoint "views")
New-DirSafe (Join-Path $srcSharePoint "scripts")

$srcPowerBI = Join-Path $src "powerBI"
New-DirSafe $srcPowerBI
New-DirSafe (Join-Path $srcPowerBI "reports")
New-DirSafe (Join-Path $srcPowerBI "datasets")
New-DirSafe (Join-Path $srcPowerBI "docs")

# scripts
$scripts = Join-Path $root "scripts"
New-DirSafe $scripts
New-DirSafe (Join-Path $scripts "pwsh")
New-DirSafe (Join-Path $scripts "js")
New-DirSafe (Join-Path $scripts "python")
New-DirSafe (Join-Path $scripts "sql")

# config
$config = Join-Path $root "config"
New-DirSafe $config

# docs
$docs = Join-Path $root "docs"
New-DirSafe $docs
New-DirSafe (Join-Path $docs "guides")
New-DirSafe (Join-Path $docs "design")
New-DirSafe (Join-Path $docs "releaseNotes")
New-DirSafe (Join-Path $docs "html")

# .github
$github = Join-Path $root ".github"
New-DirSafe $github
New-DirSafe (Join-Path $github "workflows")

# .vscode
$vscode = Join-Path $root ".vscode"
New-DirSafe $vscode

# archive (under root; you will add this to .gitignore manually)
$archive = Join-Path $root "archive"
New-DirSafe $archive

# 3. CREATE PLACEHOLDER FILES (TOP LEVEL)

New-FileSafe (Join-Path $root "README.md") @"
# EHRM Training & Booking App

Power Platform solution for managing EHRM training requests and bookings at Edward Hines Jr. VA Hospital.
"@

New-FileSafe (Join-Path $root "CONTRIBUTING.md") @"
# Contributing

- Use camelCase for names.
- Follow semantic versioning (vMAJOR.MINOR.PATCH) in Git tags.
- Keep changes small and well-documented in commits.
"@

New-FileSafe (Join-Path $root "LICENSE.md") @"
# License

Specify the appropriate license or internal VA usage statement here.
"@

# (Optional) blank .gitignore – you will edit it yourself
New-FileSafe (Join-Path $root ".gitignore") @"
# Add entries here, for example:
# archive/
# *.log
# *.tmp
"@

# 4. GITHUB COPILOT / AGENT INSTRUCTIONS

New-FileSafe (Join-Path $github "copilot-instructions.md") @"
# GitHub Copilot Instructions

- Use camelCase for variables, controls, and file names.
- Treat \`src/powerApps/unpacked/src/\` as the source of truth for the canvas app.
- Prefer semantic versioning tags (vMAJOR.MINOR.PATCH) for releases.
- When updating the canvas app, assume \`canvasApp.msapp\` and \`unpacked\` are the latest state.
"@

New-FileSafe (Join-Path $github "AGENTS.md") @"
# AGENTS.md

## Project Overview
EHRM Training & Booking App built on Microsoft Power Platform:
- Canvas app UI for training requests and bookings.
- Power Automate flows for approvals and notifications.
- SharePoint lists for data storage.
- Optional Power BI reports for training metrics.

## Build & Sync Commands
- Unpack latest canvas app:
  - Run VS Code task **Unpack Canvas App** or:
    - \`pac canvas unpack --msapp src/powerApps/canvasApp.msapp --sources src/powerApps/unpacked\`

## Code Style
- camelCase for names.
- Semantic versioning via Git tags (vMAJOR.MINOR.PATCH).
- Keep \`src\` free of secrets.

## Testing & Safety
- Use branches for risky changes.
- Tag stable releases before major refactors.
"@

New-FileSafe (Join-Path $github "PROMPTS.md") @"
# Prompt Snippets for Agents

## Summarize Latest Changes
Summarize the functional differences between the current canvas app source in \`src/powerApps/unpacked/src\` and the previous Git commit, focusing on user-visible behavior.

## Generate Release Notes
Generate release notes for the upcoming version based on the diff since the last tag, formatted for \`docs/releaseNotes/CHANGELOG.md\`.

## Review Flow Definitions
Review the Power Automate flow JSON files under \`src/powerAutomate/definitions\` for:
- naming consistency
- error handling
- dependency on environment-specific URLs.
"@

# 5. CANVAS APP PLACEHOLDERS

New-FileSafe (Join-Path $srcPowerApps "canvasApp.msapp")

New-FileSafe (Join-Path $srcPowerAppsUnpacked "CanvasManifest.json") @"
{
  // Placeholder CanvasManifest.json.
  // This will be overwritten by 'pac canvas unpack'.
}
"@

New-FileSafe (Join-Path $srcPowerAppsUnpackedSrc "App.pa.yaml") @"
# Placeholder for the app source.
# This file will be overwritten by 'pac canvas unpack'.
"@

# 6. POWER AUTOMATE / SHAREPOINT / POWER BI READMEs

New-FileSafe (Join-Path $srcPowerAutomate "readme.md") @"
# Power Automate Flows

- Store exported flow definitions in \`definitions\`.
- Store deployment/helper scripts in \`scripts\`.
"@

New-FileSafe (Join-Path $srcSharePoint "readme.md") @"
# SharePoint Lists

- Store list schemas in \`schemas\`.
- Store view definitions in \`views\`.
- Keep provisioning scripts in \`scripts\`.
"@

New-FileSafe (Join-Path $srcPowerBI "docs\powerBI-readme.md") @"
# Power BI

Use this folder for PBIX files, dataset templates, and documentation related to EHRM training reports.
"@

# 7. SCRIPTS PLACEHOLDERS

New-FileSafe (Join-Path $scripts "pwsh\sync-canvas-unpack.ps1") @"
# sync-canvas-unpack.ps1
# Example: run 'pac canvas unpack' for the latest canvasApp.msapp.

# pac canvas unpack --msapp ""src\powerApps\canvasApp.msapp"" --sources ""src\powerApps\unpacked""
"@

# 8. CONFIG PLACEHOLDERS

New-FileSafe (Join-Path $config "environments.json") @"
{
  ""environments"": [
    {
      ""name"": ""Default-VA"",
      ""displayName"": ""Department of Veterans Affairs (default)"",
      ""url"": ""https://make.gov.powerapps.us/""
    }
  ]
}
"@

New-FileSafe (Join-Path $config "featureFlags.json") @"
{
  ""exampleFeatureFlag"": false
}
"@

# 9. DOCS PLACEHOLDERS

New-FileSafe (Join-Path $docs "guides\userGuide.md") @"
# User Guide

Describe how end users at Hines VAMC request and manage EHRM training bookings.
"@

New-FileSafe (Join-Path $docs "guides\adminGuide.md") @"
# Admin Guide

Instructions for training leads and project leads to manage classes and approvals.
"@

New-FileSafe (Join-Path $docs "design\architecture.md") @"
# Architecture

Describe the high-level architecture: Power Apps canvas UI, Power Automate flows,
SharePoint lists, and optional Power BI reports.
"@

New-FileSafe (Join-Path $docs "design\dataModel.md") @"
# Data Model

Document SharePoint lists, columns, relationships, and any external data sources.
"@

New-FileSafe (Join-Path $docs "releaseNotes\CHANGELOG.md") @"
# Changelog

All notable changes to this project will be documented here.

## [v0.1.0] - 2025-12-16
- Initial project structure scaffolded.
"@

New-FileSafe (Join-Path $docs "html\index.html") @"
<!DOCTYPE html>
<html>
<head>
  <meta charset=""utf-8"">
  <title>EHRM Training & Booking App Docs</title>
</head>
<body>
  <h1>EHRM Training & Booking App</h1>
  <p>Generated documentation can be linked here.</p>
</body>
</html>
"@

# 10. .GITHUB WORKFLOWS

New-FileSafe (Join-Path $github "workflows\ci.yml") @"
name: CI

on:
  push:
    branches: [ main ]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Placeholder
        run: echo ""Add validation (YAML, JSON, Power Fx) here.""
"@

New-FileSafe (Join-Path $github "workflows\docs-build.yml") @"
name: Docs Build

on:
  push:
    paths:
      - 'docs/**'

jobs:
  build-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Placeholder
        run: echo ""Generate static docs from markdown here.""
"@

# 11. .VSCODE SETTINGS, TASKS, SNIPPETS

New-FileSafe (Join-Path $vscode "settings.json") @"
{
  ""files.exclude"": {
    ""**/.git"": true
  },
  ""git.enableSmartCommit"": true
}
"@

New-FileSafe (Join-Path $vscode "tasks.json") @"
{
  ""version"": ""2.0.0"",
  ""tasks"": [
    {
      ""label"": ""Unpack Canvas App"",
      ""type"": ""shell"",
      ""command"": ""pac"",
      ""args"": [
        ""canvas"",
        ""unpack"",
        ""--msapp"",
        ""${workspaceFolder}/src/powerApps/canvasApp.msapp"",
        ""--sources"",
        ""${workspaceFolder}/src/powerApps/unpacked""
      ],
      ""problemMatcher"": []
    }
  ]
}
"@

New-FileSafe (Join-Path $vscode "ehrm-snippets.code-snippets") @"
{
  ""Power Fx Comment Block"": {
    ""prefix"": ""pfxComment"",
    ""body"": [
      ""// =================================="",
      ""// $1"",
      ""// ==================================""
    ],
    ""description"": ""Standardized Power Fx comment block""
  }
}
"@

New-FileSafe (Join-Path $vscode "launch.json") @"
{
  ""version"": ""0.2.0"",
  ""configurations"": []
}
"@

Write-Host "Scaffold complete under root (Git root): $root" -ForegroundColor Green
