param(
  [string]\ = ""export-and-unpack"", # other: pack
  [string]\EHRMTrainingBooking = ""EHRMTrainingBooking"",
  [string]\ = ""s:\Informatics\Data Team\Coder - Informatics\App Programing\EHRM_TrainingBookingApp""
)

function Export-Unpack {
  \ = Join-Path \ ""dist\\release\\\EHRMTrainingBooking_Solution.zip""
  pac solution export --name \EHRMTrainingBooking --path \ --managed false
  pac solution unpack --zipfile \ --folder (Join-Path \ ""src\\solutions\\\EHRMTrainingBooking"") --overwrite true
  Write-Host ""Exported and unpacked solution: \EHRMTrainingBooking""
}

function Pack-Solution {
  \ = Join-Path \ ""dist\\release\\\EHRMTrainingBooking_Solution.zip""
  pac solution pack --folder (Join-Path \ ""src\\solutions\\\EHRMTrainingBooking"") --zipfile \ --packageType Unmanaged
  Write-Host ""Packed solution to: \""
}

switch (\) {
  ""export-and-unpack"" { Export-Unpack }
  ""pack"" { Pack-Solution }
  default { Write-Host ""Unknown action: \"" -ForegroundColor Red }
}
