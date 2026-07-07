# =============================================================================
# Power Apps Web Development Workflow Helper
# =============================================================================
#
#    Copyright 2025 Kyle J. Coder
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
# =============================================================================
# This script provides quick commands for web-based Power Apps development

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("package", "open-portal", "open-source", "help", "status")]
    [string]$Action = "help"
)

# Colors for output
$Green = "Green"
$Yellow = "Yellow"
$Cyan = "Cyan"
$Red = "Red"
$White = "White"

function Show-PowerAppsStatus {
    Write-Host "🎨 Power Apps Web Development Status" -ForegroundColor $Green
    Write-Host ""

    # Check if source folder exists
    $sourcePath = "./src/powerApps/.unpacked/"
    if (Test-Path $sourcePath) {
        Write-Host "✅ Source code available: $sourcePath" -ForegroundColor $Green
        $sourceFiles = Get-ChildItem -Path $sourcePath -Recurse -Filter "*.fx.yaml" | Measure-Object
        Write-Host "   📄 Contains $($sourceFiles.Count) .fx.yaml files" -ForegroundColor $Cyan
    } else {
        Write-Host "❌ Source code not found: $sourcePath" -ForegroundColor $Red
    }

    # Check if .msapp artifact folder exists
    $msappPath = "./src/powerApps/.msapp"
    if (Test-Path $msappPath) {
        Write-Host "✅ .msapp artifact folder available: $msappPath" -ForegroundColor $Green
        $msappFiles = Get-ChildItem -Path $msappPath -Filter "*.msapp" | Measure-Object
        Write-Host "   📦 Contains $($msappFiles.Count) .msapp files" -ForegroundColor $Cyan
    } else {
        Write-Host "❌ .msapp artifact folder not found: $msappPath" -ForegroundColor $Red
    }

    # Check if pac CLI is available
    try {
        $pacVersion = pac --version 2>$null
        if ($pacVersion) {
            Write-Host "✅ Power Platform CLI available" -ForegroundColor $Green
            Write-Host "   🔧 Version: $($pacVersion.Split()[2])" -ForegroundColor $Cyan
        }
    } catch {
        Write-Host "❌ Power Platform CLI not found or not in PATH" -ForegroundColor $Red
        Write-Host "   💡 Install: https://docs.microsoft.com/powerapps/developer/data-platform/powerapps-cli" -ForegroundColor $Yellow
    }

    Write-Host ""
}

function Invoke-PackageApp {
    Write-Host "📦 Packaging Power App for Web Upload" -ForegroundColor $Green
    Write-Host ""

    $sourcePath = "./src/powerApps/.unpacked"
    $outputPath = "./dist/release/EHRMTrainingBookingApp.msapp"

    if (-not (Test-Path $sourcePath)) {
        Write-Host "❌ Source path not found: $sourcePath" -ForegroundColor $Red
        return
    }

    # Ensure output directory exists
    $outputDir = Split-Path $outputPath -Parent
    if (-not (Test-Path $outputDir)) {
        New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
        Write-Host "📁 Created release directory: $outputDir" -ForegroundColor $Cyan
    }

    Write-Host "🔧 Running: pac canvas pack --sources '$sourcePath' --msapp '$outputPath'" -ForegroundColor $Cyan

    try {
        pac canvas pack --sources $sourcePath --msapp $outputPath

        if (Test-Path $outputPath) {
            $fileInfo = Get-Item $outputPath
            Write-Host ""
            Write-Host "✅ App packaged successfully!" -ForegroundColor $Green
            Write-Host "   📦 File: $outputPath" -ForegroundColor $Cyan
            Write-Host "   📊 Size: $([math]::Round($fileInfo.Length / 1MB, 2)) MB" -ForegroundColor $Cyan
            Write-Host "   📅 Created: $($fileInfo.LastWriteTime)" -ForegroundColor $Cyan
            Write-Host ""
            Write-Host "🌐 Next Steps:" -ForegroundColor $Yellow
            Write-Host "   1. Open Power Apps portal: https://make.powerapps.com" -ForegroundColor $White
            Write-Host "   2. Click 'Apps' → 'Import canvas app'" -ForegroundColor $White
            Write-Host "   3. Upload the .msapp file created above" -ForegroundColor $White
            Write-Host "   4. Test your changes in the web editor" -ForegroundColor $White
        } else {
            Write-Host "❌ Packaging failed - output file not created" -ForegroundColor $Red
        }
    } catch {
        Write-Host "❌ Packaging failed: $($_.Exception.Message)" -ForegroundColor $Red
    }
}

function Open-PowerAppsPortal {
    Write-Host "🌐 Opening Power Apps Web Portal" -ForegroundColor $Green
    Write-Host ""
    Write-Host "📋 Web Workflow Reminder:" -ForegroundColor $Yellow
    Write-Host "  1. Import canvas app (if uploading new .msapp)" -ForegroundColor $White
    Write-Host "  2. Edit and test in web editor" -ForegroundColor $White
    Write-Host "  3. Export app when satisfied with changes" -ForegroundColor $White
    Write-Host "  4. Unpack exported .msapp for source control" -ForegroundColor $White
    Write-Host ""

    try {
        Start-Process "https://make.powerapps.com"
        Write-Host "✅ Power Apps portal opened in default browser" -ForegroundColor $Green
    } catch {
        Write-Host "❌ Failed to open browser: $($_.Exception.Message)" -ForegroundColor $Red
        Write-Host "💡 Manually navigate to: https://make.powerapps.com" -ForegroundColor $Yellow
    }
}

function Open-SourceCode {
    Write-Host "📁 Opening Power App Source Code" -ForegroundColor $Green

    $sourcePath = "./src/powerApps/.unpacked"

    if (Test-Path $sourcePath) {
        try {
            code $sourcePath
            Write-Host "✅ Source code opened in VS Code" -ForegroundColor $Green
            Write-Host "   📂 Path: $sourcePath" -ForegroundColor $Cyan
        } catch {
            Write-Host "❌ Failed to open VS Code: $($_.Exception.Message)" -ForegroundColor $Red
            Write-Host "💡 Manually open: $sourcePath" -ForegroundColor $Yellow
        }
    } else {
        Write-Host "❌ Source code not found: $sourcePath" -ForegroundColor $Red
    }
}

function Show-Help {
    Write-Host "🎨 Power Apps Web Development Helper" -ForegroundColor $Green
    Write-Host ""
    Write-Host "📋 Available Commands:" -ForegroundColor $Yellow
    Write-Host "  .\docs\local\powerapps-web.ps1 package      📦 Package source code to .msapp" -ForegroundColor $Cyan
    Write-Host "  .\docs\local\powerapps-web.ps1 open-portal  🌐 Open Power Apps web portal" -ForegroundColor $Cyan
    Write-Host "  .\docs\local\powerapps-web.ps1 open-source  📁 Open source code in VS Code" -ForegroundColor $Cyan
    Write-Host "  .\docs\local\powerapps-web.ps1 status       📊 Show development status" -ForegroundColor $Cyan
    Write-Host "  .\docs\local\powerapps-web.ps1 help         ❓ Show this help message" -ForegroundColor $Cyan
    Write-Host ""
    Write-Host "🔄 Web Development Workflow:" -ForegroundColor $Yellow
    Write-Host "  1. Edit source (.fx.yaml files) → VS Code" -ForegroundColor $White
    Write-Host "  2. Package to .msapp → 'package' command" -ForegroundColor $White
    Write-Host "  3. Upload to web → 'open-portal' command" -ForegroundColor $White
    Write-Host "  4. Test in browser → Power Apps web editor" -ForegroundColor $White
    Write-Host "  5. Export & unpack → Manual process" -ForegroundColor $White
    Write-Host ""
    Write-Host "⚠️  Web-Only Limitations:" -ForegroundColor $Red
    Write-Host "  • No direct save from web to source control" -ForegroundColor $White
    Write-Host "  • Manual upload required (no automation)" -ForegroundColor $White
    Write-Host "  • Desktop Power Apps Studio unavailable" -ForegroundColor $White
    Write-Host ""
}

# Main script logic
switch ($Action) {
    "package" { Invoke-PackageApp }
    "open-portal" { Open-PowerAppsPortal }
    "open-source" { Open-SourceCode }
    "status" { Show-PowerAppsStatus }
    "help" { Show-Help }
    default { Show-Help }
}
