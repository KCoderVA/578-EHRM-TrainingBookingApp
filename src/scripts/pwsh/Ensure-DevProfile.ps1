[CmdletBinding()]
param()

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..')).Path

if (Test-Path -LiteralPath $PROFILE) {
  . $PROFILE
  Write-Host "Loaded PowerShell profile: $PROFILE"
} else {
  Write-Warning "PowerShell profile not found at: $PROFILE"
}

$shimScript = Join-Path $repoRoot 'src\scripts\pwsh\Restore-CustomToolShims.ps1'
if (Test-Path -LiteralPath $shimScript) {
  & $shimScript
  Write-Host "Ran: $shimScript"
}
