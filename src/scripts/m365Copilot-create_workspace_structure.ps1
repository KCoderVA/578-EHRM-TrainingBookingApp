New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/.vscode"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/.github/workflows"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/docs"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/src/powerApp/unpacked/Assets"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/src/powerApp/unpacked/Src"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/src/powerAutomate"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/src/sharePointLists"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/src/scripts"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/src/config/git-hooks"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/data/sql"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/data/exports"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/data/raw"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/reports"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/publish"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/tools"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/archive/src/powerApp"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/archive/src/powerAutomate"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/archive/src/sharePointLists"
New-Item -ItemType Directory -Force -Path "EHRM_TrainingBookingApp/archive/data/exports"
Set-Content -Path "EHRM_TrainingBookingApp/README.md" -Value "# EHRM Training & Booking App

Project overview and setup instructions."
Set-Content -Path "EHRM_TrainingBookingApp/copilot-instructions.md" -Value "# Copilot Instructions

Guidance for using GitHub Copilot Agent with this workspace."
Set-Content -Path "EHRM_TrainingBookingApp/workspace-manifest.md" -Value "# Workspace Manifest

Structure and metadata for the workspace."
Set-Content -Path "EHRM_TrainingBookingApp/.vscode/tasks.json" -Value "{}"
Set-Content -Path "EHRM_TrainingBookingApp/.github/workflows/release.yml" -Value "name: Release Workflow
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2"
