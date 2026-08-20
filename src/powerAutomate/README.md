# Power Automate

This folder contains unpacked and packaged Power Automate flows used by the EHRM Training & Booking App.

## v0.0.1 contents
- `AppUserList/` — flow template that populates user demographics in the access-control SharePoint list.

## Current contents

- **`AppUserList/`** — populates/refreshes user demographics in the `DeskAccessControl` SharePoint list and emails an access-change confirmation (adaptive card) to the requester.
  - Unpacked source: `AppUserList/.unpacked/` (flow `2d7505ba-bc23-4900-b533-a37064789a15`).
  - Current export: `AppUserList/.json/v0.12.2_578EHRMTrainingApp_AppUserList.json` (re-exported at project v0.12.3; connection/API/manifest maps refreshed).
- **`SendReminders/`** *(new in v0.12.3)* — "Send Email Reminder" flow that emails a **"You are scheduled for EHRM Learning Lab training!"** confirmation/reminder to scheduled users, pulling name, email, role, scheduled-by, and access window from `DeskAccessControl`.
  - Unpacked source: `SendReminders/.unpacked/` (flow `ecd1d899-5df4-4795-a98b-f1a1b55ee837`).
  - Adaptive-card email design: `SendReminders/adaptiveCards/v0.12.4_flowSendReminders_adaptiveCard.json` (the flow definition also embeds the card inline). The superseded v0.12.2 card design is retained locally under `archive/`.
  - Packed export: `SendReminders/.zip/v0.12.2_578EHRMTrainingApp_SendEmailReminder_20260812115737.zip` *(local-only; `.zip` is git-ignored)*.

## Component versions

| Flow | Version | Notes |
|------|---------|-------|
| `AppUserList` | v0.1.1 | Re-exported at project v0.12.3 (map/manifest refresh; export renamed with `v0.12.2_` prefix). |
| `SendReminders` | v0.1.0 | New at project v0.12.3; adaptive-card design iterated through v0.12.4. |

## Note on environment-specific values
Unpacked flow definitions can contain environment-specific identifiers and internal URLs (tenant IDs, SharePoint site URLs, app play URLs, email addresses). Review/sanitize before publishing broadly if needed.
