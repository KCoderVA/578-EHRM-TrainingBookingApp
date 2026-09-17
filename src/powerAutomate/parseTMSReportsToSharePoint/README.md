<!--
Copyright 2025-2026 Coder, Kyle J. (github.com/KCoderVA)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

# Power Automate Flow: `parseTMSReportsToSharePoint`

**Display name:** `578EHRMTrainingApp_parseTMSReport-updateSharePointCSV`
**Export label:** `v1.2.7_578EHRMTrainingApp_parseTMSReport-updateSharePointCSV`
**Flow GUID:** `0ca17aa8-4878-4862-8791-49361c71719b`
**Package resource GUID:** `0d7d81d1-4b8d-4ac2-9a6e-32b776aaf4ca`
**Component version:** v1.0.0 (new at project v1.2.7)

## Purpose

This automated cloud flow ingests the recurring TMS Program Completion Detail CSV delivered by the
VA Training Management System (TMS). When the configured mailbox receives an email from the TMS
reporting sender with an attachment, the flow finds `.csv` attachments and copies their content to the
canonical SharePoint document:

`/Shared Documents/TMS_Reports/TMSProgramCompletion_DetailedReport.csv`

That stable SharePoint file is the primary data source for the internal Power BI report
`578 EHRM Training Details Reports.pbix`. The report supports hospital management and executive
oversight of completed and incomplete EHRM/FEHR-related training for employees associated with Edward
Hines Jr. VA Hospital.

The flow also attempts to retain each incoming CSV in:

`/Shared Documents/TMS_Reports/archives/`

## End-to-end data path

```text
TMS automated reporting service (approximately every 6 hours)
  -> Office 365 Outlook mailbox
  -> filter each attachment by a lowercase .csv suffix
  -> retrieve attachment bytes
  -> overwrite the canonical SharePoint CSV
  -> create a dated SharePoint archive copy
  -> decode and inspect CSV rows in memory (currently no persisted output)
  -> Power BI refresh reads the canonical SharePoint CSV
```

The Power BI dataset refresh is not initiated by this flow. Refresh scheduling and credentials remain
Power BI service configuration concerns.

## Trigger and filters

The `When_a_new_email_arrives_(V3)` trigger uses Office 365 Outlook `OnNewEmailV3` with these filters:

| Setting | Exported value |
|---|---|
| Recipient | `Kyle.Coder@va.gov` |
| Sender | `TMS-NoReply@va.ns2cloud.com` |
| Include attachments | `true` |
| Only messages with attachments | `true` |
| Subject filter | None |
| Split-on behavior | One flow run per message returned by the trigger |

The trigger does not itself guarantee a CSV attachment. The attachment loop applies a separate,
case-sensitive `endsWith(name, '.csv')` condition.

## Action inventory

| Order | Exported action | Type / operation | Function |
|---:|---|---|---|
| 1 | `Initialize_variable` | Initialize array variable | Creates `initializeArray`, shared by the attachment/row loops for this run. |
| 2 | `v3_ForEach(emailAttatchment)` | `Foreach` | Iterates over `triggerOutputs().body.attachments`. |
| 2.1 | `If(attatchmentItemName,endsWith(.csv))` | `If` | Accepts attachments whose names end exactly with lowercase `.csv`. |
| 2.1.1 | `GetAttatchment` | Outlook `GetAttachment_V2` | Retrieves the selected attachment by message ID and attachment ID. |
| 2.1.2 | `UpdateFile(sharepointItem,with(attatchmentContents))` | SharePoint `UpdateFile` | Overwrites the canonical CSV with `GetAttatchment.body.contentBytes`. |
| 2.1.3 | `CreateFile(datedArchival.csv)` | SharePoint `CreateFile` | Attempts to save the same bytes under `TMS_Reports/archives`. Runs in parallel with the canonical update after attachment retrieval. |
| 2.2 | `Compose(rawContent_fromAttatchedCSV)` | Compose | Base64-decodes attachment bytes to text; emits `NULL` when content is empty. |
| 2.3 | `Compose_2` | Compose | Splits decoded text on `\n`, then skips the header row. |
| 2.4 | `Apply_to_each` | `Foreach` | Iterates over the remaining text rows. |
| 2.4.1 | `Compose_3` | Compose | Splits each row on a literal comma. |
| 2.4.2 | `Append_to_array_variable` | Append to array | Removes double quotes from column 0 and appends the value to `initializeArray`. |
| 2.4.3 | `Select` | Data Operation `Select` | Maps column 0 to an object property named `Program ID`. |

## Current functional boundary

The SharePoint update and archive actions receive the original attachment bytes directly. The later
Compose/Apply-to-each branch does inspect rows and extract `Program ID`, but neither `initializeArray`
nor the `Select` output is consumed by another action. Therefore:

- the canonical SharePoint file is an unmodified copy of the attached CSV;
- no parsed rows are written to a SharePoint list, Dataverse, SQL, or another file;
- the parsing branch currently has no effect on the file consumed by Power BI.

This distinction matters when troubleshooting source-data quality: column cleanup, filtering, type
conversion, and deduplication must currently happen upstream in TMS or downstream in Power Query/Power
BI.

## Connections and environment bindings

| Connector | API | Exported connection mode | Used by |
|---|---|---|---|
| Office 365 Outlook | `shared_office365` | Embedded | Email trigger and attachment retrieval |
| SharePoint Online | `shared_sharepointonline` | Embedded | Canonical-file update and archive-file creation |

The package manifest marks both API resources and both connection resources as existing dependencies.
On import, map them to authorized connections in the target environment. The Outlook identity needs
access to the monitored mailbox; the SharePoint identity needs edit rights on the canonical file and
contribute rights in the archive folder.

## SharePoint and Power BI contract

| Item | Contract |
|---|---|
| Site | `https://dvagov.sharepoint.com/sites/HinesInformatics&AdvancedAnalytics/578_EHRM_TrainingApp` |
| Library | `Shared Documents` |
| Canonical file | `TMS_Reports/TMSProgramCompletion_DetailedReport.csv` |
| Archive folder | `TMS_Reports/archives` |
| Power BI report | `src/analytics/tms/powerBI/.pbix/578 EHRM Training Details Reports.pbix` (local/internal binary) |
| Expected cadence | TMS report delivery approximately every 6 hours; Power BI refresh is configured separately |

Treat the canonical file path and CSV schema as an integration contract. Renaming the site, library,
folder, file, or CSV columns can break the flow or Power BI refresh.

## Known risks and recommended hardening

1. **Downstream actions are outside the CSV condition.** If an email contains a non-CSV attachment,
   `GetAttatchment` is skipped but `Compose(rawContent_fromAttatchedCSV)` still runs after the condition
   reports success and references that skipped action. Move the decode/row loop inside the true branch
   or add an explicit skipped-action guard.
2. **The extension check is case-sensitive.** Normalize with `toLower(item()?['name'])` before testing
   `.csv` so `.CSV` attachments are accepted.
3. **The archive filename uses raw `utcNow()`.** The default timestamp includes `:` characters, which
   are unsafe in SharePoint file names. Use a format such as
   `formatDateTime(utcNow(), 'yyyy-MM-dd_HHmmss')`.
4. **The parser is not RFC 4180-aware.** `split(row, ',')` breaks quoted fields containing commas,
   embedded line breaks, or escaped quotes. Use a proven CSV parser before relying on parsed columns.
5. **Parsed output is unused.** Either connect the parsed records to an intentional destination or
   remove the dead parsing branch after confirming Power BI only needs the raw file.
6. **Multiple CSV attachments can overwrite the same target.** Restrict the expected report filename,
   reject ambiguous messages, and configure loop concurrency deliberately.
7. **No explicit failure handling or notification exists.** Add scoped try/catch-style branches and an
   operator alert for trigger, attachment, SharePoint update, archive, and schema failures.
8. **No subject or report-name validation exists.** The sender filter alone allows any lowercase CSV
   from that sender to replace the production Power BI source.
9. **Archive retention is unbounded.** Define retention, sensitivity labeling, and least-privilege
   access for files containing employee training records.

## Deployment and validation

1. Import the legacy package from `.zip/` in Power Automate.
2. Map the Office 365 Outlook and SharePoint Online connections.
3. Reconfirm the mailbox, sender, SharePoint site, canonical file, and archive folder.
4. Ensure the canonical file already exists because `UpdateFile` does not create it.
5. Send a controlled test email containing one representative lowercase `.csv` attachment.
6. Verify the run history shows successful attachment retrieval, canonical update, and archive creation.
7. Compare the SharePoint file bytes/row count and expected headers with the test attachment.
8. Refresh the Power BI dataset and verify record counts, completion statuses, and key filters.
9. Test non-CSV, uppercase `.CSV`, empty, malformed, quoted-comma, duplicate, and multiple-attachment
   cases before production approval.

## Source artifacts

- `.unpacked/manifest.json` - package metadata and resource dependencies.
- `.unpacked/Microsoft.Flow/flows/manifest.json` - packaged flow asset index.
- `.unpacked/Microsoft.Flow/flows/0d7d81d1-4b8d-4ac2-9a6e-32b776aaf4ca/definition.json` - workflow definition.
- `apisMap.json` - connector API resource IDs.
- `connectionsMap.json` - exported connection resource IDs.
- `.zip/` - original legacy export package (git-ignored/local-only).
- `.json/` - optional local export staging (currently empty).

## Security and privacy

The TMS report contains internal employee training records. Keep CSV/PBIX artifacts out of public source
control, use least-privilege connector identities, restrict the SharePoint library and archive folder,
and follow the repository security policy before sharing logs or run outputs. The unpacked definition
also contains internal email addresses, URLs, resource IDs, and embedded connection identifiers; it does
not contain connector credentials or access tokens.
