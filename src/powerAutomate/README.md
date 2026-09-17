# Power Automate — Cloud Flows

This folder contains the four Power Automate cloud flows that support the 578 EHRM Training App.
The canvas app does **not** call these flows directly; they run independently on SharePoint/Outlook
triggers and are linked to the app and reporting stack by **data and email** (see the trigger table below).

> **Current project release:** `v1.2.7`. See
> [`parseTMSReportsToSharePoint/v1.2.7_flowAnalysis.md`](parseTMSReportsToSharePoint/v1.2.7_flowAnalysis.md)
> for the new flow's source-level analysis.

## Flows at a glance

| Flow | Trigger | Purpose | Status @ v1.2.7 |
|---|---|---|---|
| [`AppUserList/`](AppUserList/) | SharePoint — new/changed `DeskAccessControl` item (poll 5 min) | Enriches new users with M365 profile/manager data, drives RBAC provisioning, and notifies admins via **chatbot adaptive cards** + email per access level | **Unchanged** |
| [`SendReminders/`](SendReminders/) | SharePoint — new item on `578_EHRM_TrainingApp` (poll 5 min) | Sends the **"You are scheduled for EHRM Learning Lab training!"** reminder — now as both an **email** and a **Teams adaptive card** | **Updated** |
| [`CreateBackups/`](CreateBackups/) | Outlook — new email, subject `[REGISTERED] EHRM Learning Lab Training -` | Parses the app's confirmation email and writes a **backup reservation record** to a separate SharePoint list | **New** |
| [`parseTMSReportsToSharePoint/`](parseTMSReportsToSharePoint/) | Outlook — email from the TMS reporting sender with attachments | Copies lowercase `.csv` attachments to the canonical SharePoint TMS report file and creates archive copies for the Power BI reporting pipeline | **New at v1.2.7** |

### How the app and flows connect
```
Canvas app (Confirm screen)
   │  SendEmailV2 → subject "[REGISTERED] EHRM Learning Lab Training - …"
   ▼
CreateBackups flow (Outlook OnNewEmailV3, subject filter)
   │  parse email → get user + manager → Create_item
   ▼
backupList_DeskReservations (SharePoint)

Admin edits DeskAccessControl ──► AppUserList flow ──► enrich + notify
New Desk Reservations row     ──► SendReminders flow ──► email + Teams card

TMS report email (about every 6 hours)
   │  attached Program Completion Detail CSV
   ▼
parseTMSReportsToSharePoint flow
   │  overwrite canonical SharePoint CSV + create archive copy
   ▼
578 EHRM Training Details Power BI report (separately scheduled refresh)
```

## Component versions

| Flow | Component version | Notes |
|---|---|---|
| `AppUserList` | v0.1.1 | Unchanged; flow `2d7505ba-bc23-4900-b533-a37064789a15`. |
| `SendReminders` | v0.2.0 | Updated at project v1.0.12; flow `ecd1d899-5df4-4795-a98b-f1a1b55ee837`. Added Teams card + reduced polling. |
| `CreateBackups` | v0.1.0 | **New** at project v1.0.12; flow `5bf4e999-2b8a-4d81-a28a-daf4de8894da`. |
| `parseTMSReportsToSharePoint` | v1.0.0 | **New** at project v1.2.7; runtime flow `0ca17aa8-4878-4862-8791-49361c71719b`. |

## Importing these flows
Each flow ships as a packaged **legacy export** `.zip` under its `flowName/.zip/` folder (git-ignored) and
as unpacked source under `flowName/.unpacked/`. To deploy in another environment: *Power Automate → My
flows → Import → Import Package (Legacy)*, upload the `.zip`, and map the SharePoint / Office 365 / Teams
connections to your environment. Then re-point every SharePoint `dataset`/`table` reference to your own
site and list GUIDs.

## Note on environment-specific values
Unpacked flow definitions contain environment-specific identifiers and internal URLs (tenant IDs,
SharePoint site URLs, list GUIDs, email addresses). Review/sanitize before publishing broadly.
