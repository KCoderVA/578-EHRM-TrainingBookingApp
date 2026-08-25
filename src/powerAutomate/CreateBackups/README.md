# Power Automate Flow: `CreateBackups`

**Display name:** `578EHRMTrainingApp_CreateBackupReservation` · **Flow GUID:** `5bf4e999-2b8a-4d81-a28a-daf4de8894da`
· **Component version:** v0.1.0 (**new** at project v1.0.12)

## Purpose

Creates a **redundant "backup" reservation record** for every training registration, independent of the
canvas app's own SharePoint write. It listens for the confirmation email the app sends on booking, parses
the reservation details out of the message, enriches them with directory data, and writes a row to a
dedicated backup list. This gives the program a second, email-sourced audit trail of every registration.

## Trigger

- **Outlook — "When a new email arrives (V3)"** (`OnNewEmailV3`) with **subject filter
  `[REGISTERED] EHRM Learning Lab Training -`**.
- This subject is produced by the canvas app's **`Confirm`** screen
  (`Office365Outlook.SendEmailV2`), so the flow fires once per successful booking.

## Logic (high level)

1. **Parse the email body** via ~19 `Compose` actions: `Body_Clean`, `Scenario`, `Role`, `TrainingDate`,
   `TrainingTime`, `LocationRaw`, `RoomNumber`, `FloorNumber`, `BuildingNumber`, `Division`,
   `RegistrationID`, `TimeStart_Text` / `TimeEnd_Text`, `StartDateTime` / `EndDateTime` (+ `_UTC`
   variants), `TimeRange_Display`.
2. `Get_user_profile_(V2)` and `Get_manager_(V2)` — enrich with the registrant's profile and manager.
3. **`Create_item`** — write the parsed + enriched record to the backup SharePoint list
   (`…/578_EHRM_TrainingApp`, list GUID `593e180b-1c0a-4b6c-b478-6dca6db378d0`); `Title` is composed as
   `"{RegistrationID} - {from} - Super User Learning Lab - {Scenario}"`.

## Artifacts in this folder

- `.unpacked/` — unpacked flow source (`Microsoft.Flow/flows/5bf4e999…/definition.json`).
- `.zip/v1.0.12_578EHRMTrainingApp_CreateBackupReservation_20260821124451.zip` — packaged export *(git-ignored)*.

## Note on environment-specific values
The definition contains the target SharePoint site URL, backup-list GUID, and the exact email subject
filter. Re-point the SharePoint target and align the subject filter with your app's confirmation email
before use.
