# Architecture Overview

This document describes the high-level architecture of the EHRM Training & Booking App as represented in this repository.

## High-level components

- **Power Platform Solution**: `EHRMTrainingBooking`
  - Exported locally to `dist/release/` as a Solution `.zip` (git-ignored).
- **Canvas app** (source-controlled unpacked assets)
  - Unpacked source: `src/powerApps/.unpacked/`
  - Pack/unpack artifact: a local `.msapp` under `dist/release/` (git-ignored).
- **Power Automate flows**
  - Unpacked sources under `src/powerAutomate/` (each flow includes a `.unpacked/` directory).
- **SharePoint data model (baseline)**
  - Sanitized sample CSVs under `src/sharePoint/`.

## Baseline data flow (conceptual)

- The Canvas app reads/writes reservation data to SharePoint lists.
- The `AppUserList` flow maintains access-control/user-demographic columns in the access-control list based on Microsoft 365 user profile data.

## Repo conventions

- Human-reviewable, source-controlled content lives under:
  - `src/` (unpacked Power Platform sources)
  - `config/` (runbooks, environment templates, tooling helpers)
  - `docs/` (public documentation)
- Local-only artifacts (git-ignored): `dist/`, `tmp/`, `archive/`, and `docs/local/`.
- Local-only configuration (git-ignored): `config/local/`.

