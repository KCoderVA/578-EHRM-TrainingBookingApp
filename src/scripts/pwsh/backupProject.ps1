# Compress-Archive Version:
$Timestamp =
	Get-Date -Format "yyyy.MM.dd-HH.mm.ss"
	## e.g. "2026.07.16-11.12.43"
$NetworkDrivePath =
	Split-Path (Split-Path $PWD -Parent) -Parent
	## e.g. "S:\Informatics\Data Team\Coder - Informatics"
$ProjectTypeName =
	Split-Path (Split-Path $PWD -Parent) -Leaf
	## e.g. "App Programing"

# Script artifact self-locater switch
if ($PWD -like (Join-Path -Path $NetworkDrivePath -ChildPath "\")) {
	$ProjectPath = Split-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) -Parent
	## e.g. "C:\Users\VHAHINCoderK1\OneDrive - Department of Veterans Affairs\Desktop"
} else {
	$ProjectPath = $PWD
	## e.g. "S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp"
}
$ProjectName =
	Split-Path -Path $ProjectPath -Leaf
	## e.g. "578-EHRM-TrainingSchedulerApp"
$ArchiveFileType =
	".zip"
	## e.g. ".zip"
$ArchiveFileName =
	$Timestamp + "_GHEC-US-Repo" + $ArchiveFileType
	## e.g. "2026.07.16-11.16.30_GHEC-US-Repo.zip"
$ArchiveFolderPath =
	Join-Path -Path $ProjectPath -ChildPath "archive\backup\"
	## e.g. "S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp\archive\backup"
$ArchiveFullPath =
	Join-Path -Path $ArchiveFolderPath -ChildPath $ArchiveFileName
	## e.g. "S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp\archive\backup\2026.07.16-11.16.30_GHEC-US-Repo.zip"
$TempPath =
	Join-Path -Path $env:TEMP -ChildPath "${Timestamp}_GHEC-US-Repo.zip"
	## e.g. "C:\Users\...\AppData\Local\Temp\2026.07.16-11.16.30_GHEC-US-Repo.zip"
$CompressTargetString =
	Join-Path -Path $ProjectPath -ChildPath "*"
	## e.g. "S:\Informatics\Data Team\Coder - Informatics\App Programing\578-EHRM-TrainingSchedulerApp\*"

#################################################################################
Write-Host ""
Write-Host "Timestamp            = $Timestamp"
Write-Host "NetworkDrivePath     = $NetworkDrivePath"
Write-Host "ProjectTypeName      = $ProjectTypeName"
Write-Host "ProjectPath          = $ProjectPath"
Write-Host "ProjectName          = $ProjectName"
Write-Host "ArchiveFileType      = $ArchiveFileType"
Write-Host "ArchiveFileName      = $ArchiveFileName"
Write-Host "ArchiveFolderPath    = $ArchiveFolderPath"
Write-Host "ArchiveFullPath      = $ArchiveFullPath"
Write-Host "TempPath             = $TempPath"
Write-Host "CompressTargetString = $CompressTargetString"
TimeOut /T 15
#################################################################################
$scriptSuccess = $false
##New-Item -ItemType Directory -Force -Path "$ProjectPath\archive" | Out-Null
##New-Item -ItemType Directory -Force -Path "$ProjectPath\archive\backup" | Out-Null
Compress-Archive -Path $CompressTargetString -DestinationPath $TempPath -CompressionLevel "Fastest" -Force
#################################################################################
if (Test-Path -Path $TempPath -PathType Leaf) {
    Write-Host "Target .zip found! Running 7z integrity test..." -ForegroundColor Green
    & 7z t $TempPath | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Integrity checks/tests on temporary archive PASSED. Moving to permanent location..." -ForegroundColor Green
        Move-Item -Path $TempPath -Destination $ArchiveFolderPath -Force
		& 7z t $ArchiveFullPath | Out-Null
		if ($LASTEXITCODE -eq 0) {
			Write-Host "The archive has been moved to the permanent directory and integrity retested successfully!" -ForegroundColor Green
			Write-Host "The permanent full path of your final .zip archive artifact is:" -ForegroundColor Green
			Write-Host "          $ArchiveFullPath" -ForegroundColor Green
			$scriptSuccess = $true
		} else {
			Write-Host "Integrity checks/tests on temporary .zip archive artifact PASSED, but the archive failed to be moved into destination folder:" -ForegroundColor Yellow
			Write-Host "          $ArchiveFolderPath" -ForegroundColor Yellow
			Write-Host "The temporary artifact still remains in directory path:" -ForegroundColor Yellow
			Write-Host "          $env:TEMP\" -ForegroundColor Yellow
			Write-Host "The temporary .zip archive artifact full path still remains:" -ForegroundColor Yellow
			Write-Host "          $TempPath" -ForegroundColor Yellow
		}
    } else {
        Write-Host "Integrity checks/tests on temporary archive FAILED, the temporary .zip archive artifact has some corruptions..." -ForegroundColor Red
		Write-Host "The temporary .zip archive artifact full path is:" -ForegroundColor Red
			Write-Host "          $TempPath" -ForegroundColor Red
		Write-Host "The original target parent directory that was intended to be compressed was:" -ForegroundColor Red
			Write-Host "          $ProjectPath" -ForegroundColor Red
    }
} else {
    Write-Host "No temporary .zip archive artifact could be found." -ForegroundColor Yellow
	Write-Host "Checking if target directory exists..." -ForegroundColor Yellow

    if (Test-Path -Path $ArchiveFolderPath -PathType Container) {
        Write-Host "The project archival subfolder DOES exist." -ForegroundColor Green
		Write-Host "Searching recursively for all .zip files in current project \root\ directory..." -ForegroundColor Yellow
        Get-ChildItem -Path $ProjectPath -Filter "*.zip" -Recurse
		Write-Host "User should proceed with manually archiving this project by another method..." -ForegroundColor Yellow
    } else {
        Write-Host "The project archival subfolder DOES NOT exist at all." -ForegroundColor Red
		Write-Host "Attempting to create archival subfolders" -ForegroundColor Yellow
		New-Item -ItemType Directory -Force -Path "$ProjectPath\archive" | Out-Null
		New-Item -ItemType Directory -Force -Path "$ProjectPath\archive\backup" | Out-Null
		if (Test-Path -Path $ArchiveFolderPath -PathType Container) {
			Write-Host "Archival subfolders created successfully..." -ForegroundColor Green
			Write-Host "Attempting to move temporary .zip archive artifact to newly created project archival subfolders..." -ForegroundColor Yellow
			Move-Item -Path $TempPath -Destination $ArchiveFolderPath -Force
			& 7z t $ArchiveFullPath | Out-Null
			if ($LASTEXITCODE -eq 0) {
				Write-Host "The temporary archive has been moved into the permanent archive directory!" -ForegroundColor Green
				Write-Host "The permanent full path of your final .zip archive artifact is:" -ForegroundColor Green
				Write-Host "          $ArchiveFullPath" -ForegroundColor Green
				$scriptSuccess = $true
			} else {
				Write-Host "Integrity checks/tests on permanent .zip archive artifact FAILED after moving to destination folder:" -ForegroundColor Red
				Write-Host "          $ArchiveFolderPath" -ForegroundColor Yellow
				Write-Host "The temporary artifact may still remain in directory path:" -ForegroundColor Yellow
				Write-Host "          $env:TEMP\" -ForegroundColor Yellow
				Write-Host "The temporary .zip archive artifact full path is:" -ForegroundColor Yellow
				Write-Host "          $TempPath" -ForegroundColor Yellow
			}
			Write-Host "Searching recursively for all .zip files in current project \root\ directory..." -ForegroundColor Yellow
			Get-ChildItem -Path $ProjectPath -Filter "*.zip" -Recurse
		} else {
			Write-Host "Archival subfolders FAILED to be created..." -ForegroundColor Red
			Write-Host "Target \archive\ directory artifact could not be created at path $ProjectPath\..." -ForegroundColor Red
			Write-Host "Target \backup\ directory artifact could not be created at path $ProjectPath\archive\..." -ForegroundColor Red
		}
    }
}
#################################################################################
Write-Host ""
if ($scriptSuccess) {
	Write-Host "    SCRIPT EXECUTION RESULTS: SUCCESS" -ForegroundColor Green
	Write-Host "    -   'Compress-Archive' completed successfully!" -ForegroundColor Green
	Write-Host "    -   Project archival directory path:" -ForegroundColor Green
	Write-Host "                $ProjectPath\archive\backup\" -ForegroundColor Green
	Write-Host "    -   Project .zip artifact path:" -ForegroundColor Green
	Write-Host "                $ArchiveFullPath" -ForegroundColor Green
	Write-Host "    -   Archival Integrity Check: PASSED" -ForegroundColor Green
	Write-Host "    Run manually to re-verify:  7z t `"$ArchiveFullPath`"" -ForegroundColor Cyan
} else {
	Write-Host "    SCRIPT EXECUTION RESULTS: FAILED" -ForegroundColor Red
	Write-Host "    -   Script encountered errors. Review output above for details." -ForegroundColor Red
	Write-Host "    -   Expected archive path (if partially created):" -ForegroundColor Yellow
	Write-Host "                $ArchiveFullPath" -ForegroundColor Yellow
}
