# Power Automate Flow: SendReminders

**Flow (component) version**: v0.1.0 (current, new in project v0.12.3)

## Purpose

The "Send Email Reminder" flow emails a **"You are scheduled for EHRM Learning Lab training!"** confirmation/reminder to users who have been scheduled for an EHRM Learning Lab training session.

It reads the scheduled user's details from the `DeskAccessControl` SharePoint list — display name, user principal (email), access level/role, the scheduling admin (`Author`), and the access window (`AccessStop_dateTime`) — and formats them into an Adaptive Card email body so the recipient can review prerequisites and event information.

## Artifacts in this folder

- `.unpacked/`
  - Unpacked source generated from the export (flow `ecd1d899-5df4-4795-a98b-f1a1b55ee837`; includes `definition.json`, `apisMap.json`, `connectionsMap.json`, and manifests under `.unpacked/Microsoft.Flow/flows/...`).
- `.zip/v0.12.2_578EHRMTrainingApp_SendEmailReminder_20260812115737.zip`
  - Packaged export artifact downloaded from Power Automate *(local-only; `.zip` is git-ignored)*.
- `adaptiveCards/v0.12.4_flowSendReminders_adaptiveCard.json`
  - Standalone Adaptive Card design (the email body) for editing in the Adaptive Card Designer. The flow `definition.json` also embeds the card inline. The superseded v0.12.2 card design is retained locally under `archive/` (git-ignored).

## Connectors / data sources

- **Office 365 Outlook** — sends the reminder email (Adaptive Card body).
- **SharePoint** — `Get_item` from the `DeskAccessControl` list for the scheduled user's details.

## Status / follow-up

- New in v0.12.3. This fulfills the previously-tracked roadmap item to build the reminder Power Automate flow.
- Validate end-to-end wiring to the reservation/schedule lifecycle (trigger conditions, recipient resolution, and send-time scheduling) before broad production use.

## Important note (public repo)

The unpacked flow definition can include environment-specific identifiers and internal URLs/emails from the source environment. Review and sanitize as appropriate before publishing broadly.
