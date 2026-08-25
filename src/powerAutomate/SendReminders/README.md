# Power Automate Flow: `SendReminders`

**Display name:** `578EHRMTrainingApp_SendEmailReminder` · **Flow GUID:** `ecd1d899-5df4-4795-a98b-f1a1b55ee837`
· **Component version:** v0.2.0 (updated at project v1.0.12)

## Purpose

Notifies a scheduled trainee that they are booked for an EHRM Learning Lab session. As of v1.0.12 the flow
delivers the reminder through **two channels** — a formatted **email** and a **Microsoft Teams adaptive
card** — and it schedules the send relative to the session time.

## Trigger

- **SharePoint — "When an item is created"** (`GetOnNewItems`) on the app's site
  `…/HinesInformatics&AdvancedAnalytics/578_EHRM_TrainingApp` (list GUID `b7c9bc66-7839-49a4-a55d-5e45dd6870d2`).
- **Polling interval: every 5 minutes** (reduced from every 1 minute in the prior version to lower API
  throughput / throttling).

## Logic (high level)

1. `Get_item` — read the full new reservation row.
2. `cmp_MinutesUntilSend` / `cmp_SendTime` — compute when the reminder should go out.
3. `cond_ShouldWait` → `Delay_Until` — hold until the computed send time.
4. `cmp_Style` / `cmp_Greeting` / `cmp_EventDetails` / `cmp_Prereqs` / `cmp_Footer` / `cmp_FullBody` —
   compose the HTML message body.
5. `Delay(5s)` → `Update_item` — mark the row as reminded.
6. **`Post_card_in_a_chat_or_channel`** — post the reminder as a **Teams adaptive card**.
7. **`Condition (CreatedBy = "Kyle.Coder")`** → `Send_an_email_(V2)` — send the email reminder. *(This gate
   is **intentional**: items the developer submits behave differently from live end-user submissions, so
   email reminders are sent only for the developer's own records.)*
8. **`Post_card_in_a_chat_or_channel_1`** — second Teams card post.

## Artifacts in this folder

- `.unpacked/` — unpacked flow source (`Microsoft.Flow/flows/ecd1d899…/definition.json`).
- `.zip/v1.0.12_578EHRMTrainingApp_SendEmailReminders_20260821124012.zip` — packaged export *(git-ignored)*.
- `adaptiveCards/` — adaptive-card JSON design(s); the flow definition also embeds the card inline.

## What changed at v1.0.12 (from v0.12.3)

- **Added Teams delivery** — two `Post_card_in_a_chat_or_channel` actions (adaptive cards).
- **Email send is conditional** on `CreatedBy` — an intentional developer-vs-end-user differentiation (kept by design).
- **Polling reduced** 1 min → 5 min.
- Action order revised so `Update_item` runs before the notifications.

See [`../v1.0.12_differenceAnalysis.md`](../v1.0.12_differenceAnalysis.md) for the full action-by-action diff.

## Note on environment-specific values
The definition contains the source SharePoint site URL, list GUID, and Teams recipient/channel identifiers.
Re-point these to your environment before use.
