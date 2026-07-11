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

# PURPOSE:
#   After a commit/PR/merge cycle completes (via enterpriseCommitGuide.ps1),
#   this script performs three actions in sequence:
#     1. ARCHIVE  — copies the current live release artifact .md files from
#                   .\docs\release-notes\ into .\archive\docs\release-notes\
#                   (datetime-stamped on name collision)
#     2. RENAME   — renames those live .md files by swapping the old version
#                   prefix with the next version number read from .\VERSION
#     3. POPULATE — overwrites the renamed live files with fresh template
#                   content from .\docs\release-notes\releaseTemplates\,
#                   leaving them ready-to-fill-in for the next release cycle
#
# PORTABILITY:
#   Run from any repo root that follows the standard directory convention:
#     .\VERSION
#     .\docs\release-notes\         — live artifacts (vX.Y.Z_commitMessage.md etc.)
#     .\docs\release-notes\releaseTemplates\  — template sources
#     .\archive\docs\release-notes\ — long-term archive (gitignored/local-only)

# Halt on any error (cmdlets and, in PS 7.3+, native commands)
$ErrorActionPreference               = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

# ── Output helpers ────────────────────────────────────────────────────────────
function Step { param([string]$Msg) Write-Host "`n── $Msg" -ForegroundColor Cyan  }
function Done { param([string]$Msg) Write-Host "   ✓  $Msg" -ForegroundColor Green }
function Warn { param([string]$Msg) Write-Host "   ⚠  $Msg" -ForegroundColor Yellow }

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 1 — Validate prerequisites & resolve paths
# ═════════════════════════════════════════════════════════════════════════════
Step "Validating prerequisites"

if (-not (Test-Path ".\VERSION")) {
    throw ".\VERSION not found — run this script from the repo root."
}

$NextVer     = (Get-Content -Raw ".\VERSION").Trim()
$NextTag     = "v$NextVer"
$LiveDir     = ".\docs\release-notes"
$ArchiveDir  = ".\archive\docs\release-notes"
$TemplateDir = ".\docs\release-notes\releaseTemplates"

foreach ($p in @($LiveDir, $TemplateDir)) {
    if (-not (Test-Path $p)) {
        throw "Required directory not found: $p — run this script from the repo root."
    }
}

# Archive dir is gitignored/local-only — create it if it does not yet exist
if (-not (Test-Path $ArchiveDir)) {
    New-Item -ItemType Directory -Path $ArchiveDir -Force | Out-Null
    Done "Created archive directory: $ArchiveDir"
}

# Canonical suffix strings that identify each release artifact type
$suffixes = @('_commitMessage', '_pullRequest', '_releaseNotes')

# Keyword variants used to match template files regardless of their exact naming
# convention (supports both "TEMPLATE_commitMessage" and "commit_message-TEMPLATE" styles)
$typeKeywords = @{
    '_commitMessage' = @('commitMessage', 'commit_message')
    '_pullRequest'   = @('pullRequest',   'pull_request')
    '_releaseNotes'  = @('releaseNotes',  'release_notes')
}

Done "Next version from .\VERSION: $NextTag"

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 2 — Discover live release artifact files (non-recursive)
# ═════════════════════════════════════════════════════════════════════════════
Step "Discovering live release artifacts in $LiveDir"

$liveFiles = [System.Collections.Generic.List[System.IO.FileInfo]]::new()

foreach ($suffix in $suffixes) {
    $found = Get-ChildItem -Path $LiveDir -Filter "*$suffix.md" -File
    if ($found) {
        $found | ForEach-Object {
            $liveFiles.Add($_)
            Done "Found: $($_.Name)"
        }
    } else {
        Warn "No file matching *$suffix.md found in $LiveDir"
    }
}

if ($liveFiles.Count -eq 0) {
    throw "No release artifact files found in $LiveDir — nothing to process."
}

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 3 — Archive live files to .\archive\docs\release-notes\
# ═════════════════════════════════════════════════════════════════════════════
Step "Archiving $($liveFiles.Count) file(s) to $ArchiveDir"

$timestamp = (Get-Date).ToString("yyyy.MM.dd-HH.mm.ss")

foreach ($file in $liveFiles) {
    $destPath = Join-Path $ArchiveDir $file.Name

    if (Test-Path $destPath) {
        # Name collision — append datetime suffix before the extension to ensure uniqueness
        $base     = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
        $ext      = $file.Extension
        $destPath = Join-Path $ArchiveDir "${base}_${timestamp}${ext}"
        Warn "Name collision — archive copy will be saved as: $([System.IO.Path]::GetFileName($destPath))"
    }

    Copy-Item -Path $file.FullName -Destination $destPath
    Done "Archived: $($file.Name)  →  $ArchiveDir\$([System.IO.Path]::GetFileName($destPath))"
}

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 4 — Rename live files: swap old version prefix → new version prefix
# ═════════════════════════════════════════════════════════════════════════════
Step "Renaming live artifacts to $NextTag prefix"

$renamedFiles = [System.Collections.Generic.List[System.IO.FileInfo]]::new()

foreach ($file in $liveFiles) {
    # Keep everything from the first '_' onward; replace only the version prefix
    $firstUnderscore = $file.Name.IndexOf('_')
    if ($firstUnderscore -lt 0) {
        Warn "Cannot parse version prefix from: $($file.Name) (no '_' found) — skipping rename"
        $renamedFiles.Add((Get-Item $file.FullName))
        continue
    }

    $suffixPart = $file.Name.Substring($firstUnderscore)  # e.g., _commitMessage.md
    $newName    = "$NextTag$suffixPart"                   # e.g., v0.3.5_commitMessage.md
    $newPath    = Join-Path $LiveDir $newName

    if ($file.Name -eq $newName) {
        Warn "Already at $NextTag prefix: $newName — skipping rename"
        $renamedFiles.Add((Get-Item $file.FullName))
        continue
    }

    Rename-Item -Path $file.FullName -NewName $newName
    $renamedFiles.Add((Get-Item $newPath))
    Done "Renamed: $($file.Name)  →  $newName"
}

# ═════════════════════════════════════════════════════════════════════════════
# PHASE 5 — Overwrite renamed files with matching template content
# ═════════════════════════════════════════════════════════════════════════════
Step "Populating $NextTag artifacts from templates in $TemplateDir"

foreach ($renamedFile in $renamedFiles) {
    # Determine which artifact type this file belongs to
    $fileType = $suffixes | Where-Object { $renamedFile.Name -like "*$_*" } | Select-Object -First 1

    if (-not $fileType) {
        Warn "Cannot determine artifact type for: $($renamedFile.Name) — skipping template injection"
        continue
    }

    # Find the matching template using keyword variants (order determines priority)
    $templateFile = $null
    foreach ($kw in $typeKeywords[$fileType]) {
        $templateFile = Get-ChildItem -Path $TemplateDir -Filter "*$kw*" -File |
                        Select-Object -First 1
        if ($templateFile) { break }
    }

    if (-not $templateFile) {
        Warn "No template found for type '$fileType' (keywords tried: $($typeKeywords[$fileType] -join ', ')) — skipping"
        continue
    }

    # Write template content verbatim — {{PLACEHOLDER}} blocks are preserved as-is
    $templateContent = (Get-Content -Raw $templateFile.FullName).TrimEnd()
    Set-Content -Path $renamedFile.FullName -Value $templateContent
    Done "Populated: $($renamedFile.Name)  ←  $($templateFile.Name)"
}

Write-Host "`n══ Post-commit archival complete!  $($liveFiles.Count) artifact(s) archived · renamed to $NextTag · reset from templates ══`n" -ForegroundColor Green
