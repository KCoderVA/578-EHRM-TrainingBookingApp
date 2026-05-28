[CmdletBinding()]
param(
  [ValidateSet('export-and-unpack','pack')]
  [string]$Action = 'export-and-unpack',

  [string]$SolutionName = 'EHRMTrainingBooking',

  # Repo root defaults based on this script living at: src/config/tools/pac/alm.ps1
  [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..\..\..')).Path
)

$distRelease = Join-Path $RepoRoot 'dist\release'
$zipPath = Join-Path $distRelease "${SolutionName}_Solution.zip"
$solutionFolder = Join-Path $RepoRoot "src\config\solutions\${SolutionName}"

function Ensure-DistRelease {
  if (-not (Test-Path -LiteralPath $distRelease)) {
    New-Item -ItemType Directory -Path $distRelease -Force | Out-Null
  }
}

function Export-Unpack {
  Ensure-DistRelease

  pac solution export --name $SolutionName --path $zipPath --managed false
  pac solution unpack --zipfile $zipPath --folder $solutionFolder --overwrite true

  Write-Host "Exported and unpacked solution: $SolutionName"
  Write-Host "Zip: $zipPath"
  Write-Host "Folder: $solutionFolder"
}

function Pack-Solution {
  Ensure-DistRelease

  pac solution pack --folder $solutionFolder --zipfile $zipPath --packageType Unmanaged

  Write-Host "Packed solution: $zipPath"
}

switch ($Action) {
  'export-and-unpack' { Export-Unpack }
  'pack' { Pack-Solution }
}
