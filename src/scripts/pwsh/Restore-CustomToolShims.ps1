#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Restores custom tool shims to PowerShell profile for VA Healthcare user-scoped installations.

.DESCRIPTION
    This script automatically recreates PowerShell profile configurations for tools installed
    in user-scope directories (required by VA Healthcare IT security policies).

    Tools configured:
    - .NET Core (dotnet)
    - GitHub CLI (gh)
    - 7-Zip (7z)
    - Node.js (node, npm, npx)
    - Docker (docker)

.NOTES
    File Name      : Restore-CustomToolShims.ps1
    Author         : Kyle Coder
    Prerequisite   : PowerShell 5.1 or higher
    Created        : November 19, 2025

.EXAMPLE
    .\Restore-CustomToolShims.ps1

    Double-click to run or execute from PowerShell to restore all tool shims.
#>

[CmdletBinding()]
param()

# Determine the PowerShell profile path
$profilePath = $PROFILE.CurrentUserCurrentHost

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Custom Tool Shims Restoration Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if tools exist
Write-Host "Checking installed tools..." -ForegroundColor Yellow
Write-Host ""

$tools = @{
    ".NET Core" = "$Env:USERPROFILE\.dotnet\dotnet.exe"
    # "GitHub CLI" = "$Env:USERPROFILE\gh\bin\gh.exe"  # DISABLED (2026-05-28): repo-management tooling temporarily deactivated
    "7-Zip" = "$Env:USERPROFILE\7-Zip\7za.exe"
    "Node.js" = "$Env:USERPROFILE\nodejs\node.exe"
    "Docker" = "$Env:USERPROFILE\docker\docker.exe"
}

$foundTools = 0
foreach ($tool in $tools.GetEnumerator()) {
    if (Test-Path $tool.Value) {
        Write-Host "  ✓ $($tool.Key) found at $($tool.Value)" -ForegroundColor Green
        $foundTools++
    } else {
        Write-Host "  ✗ $($tool.Key) NOT found at $($tool.Value)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Found $foundTools of $($tools.Count) tools installed." -ForegroundColor Cyan
Write-Host ""

# Create backup of existing profile
if (Test-Path $profilePath) {
    $backupPath = "$profilePath.backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Write-Host "Creating backup of existing profile..." -ForegroundColor Yellow
    Copy-Item $profilePath $backupPath -Force
    Write-Host "  ✓ Backup saved to: $backupPath" -ForegroundColor Green
    Write-Host ""
}

# Create the profile content
$profileContent = @'
#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module
Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

# .NET Core user-scoped shim
$uDotnet = "$Env:USERPROFILE\.dotnet\dotnet.exe"
if (Test-Path $uDotnet) {
    function dotnet { & $uDotnet $Args }
}

# GitHub CLI user-scoped shim (VA Healthcare IT Requirements)
# DISABLED (2026-05-28): repo-management tooling temporarily deactivated
# function gh { & "$Env:USERPROFILE\gh\bin\gh.exe" $Args }

# 7-Zip user-scoped shim
function 7z { & "$Env:USERPROFILE\7-Zip\7za.exe" $Args }

# Node.js user-scoped shim
function node { & "$Env:USERPROFILE\nodejs\node.exe" $Args }
function npm { & "$Env:USERPROFILE\nodejs\npm.cmd" $Args }
function npx { & "$Env:USERPROFILE\nodejs\npx.cmd" $Args }

# Docker user-scoped shim
function docker { & "$Env:USERPROFILE\docker\docker.exe" $Args }
'@

# Write the profile
Write-Host "Writing PowerShell profile configuration..." -ForegroundColor Yellow
try {
    # Ensure the profile directory exists
    $profileDir = Split-Path $profilePath -Parent
    if (-not (Test-Path $profileDir)) {
        New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    }

    Set-Content -Path $profilePath -Value $profileContent -Encoding UTF8 -Force
    Write-Host "  ✓ Profile successfully updated: $profilePath" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "  ✗ Error writing profile: $_" -ForegroundColor Red
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

# Verify the tools work
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Verification (Reload PowerShell)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "The profile has been successfully updated!" -ForegroundColor Green
Write-Host ""
Write-Host "To activate the changes:" -ForegroundColor Yellow
Write-Host "  1. Close this PowerShell window" -ForegroundColor White
Write-Host "  2. Open a NEW PowerShell window" -ForegroundColor White
Write-Host "  3. Test the tools:" -ForegroundColor White
Write-Host ""
Write-Host "     gh --version (DISABLED)" -ForegroundColor DarkGray
Write-Host "     node --version" -ForegroundColor Cyan
Write-Host "     npm --version" -ForegroundColor Cyan
Write-Host "     docker --version" -ForegroundColor Cyan
Write-Host "     dotnet --version" -ForegroundColor Cyan
Write-Host "     7z" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Keep window open
Write-Host "Press Enter to exit..." -ForegroundColor Yellow
Read-Host
