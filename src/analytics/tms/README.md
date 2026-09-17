# TMS Data Staging (`tms/`)

**New at v1.0.12; automated ingestion added at v1.2.7.** This folder holds local VA **TMS** (Training
Management System) completion exports and Power BI reports for EHRM/FEHR training oversight. The
production reporting path now receives its canonical CSV through the `parseTMSReportsToSharePoint`
Power Automate flow.

## Structure

```
src/analytics/tms/
├── lists/          — TMS completion exports (.xlsx) + Power BI report links (.url)
└── powerBI/.pbix/  — local/internal TMS Power BI report binaries
```

## Contents (`lists/`)

| File | What it is |
|---|---|
| `2026.08.21_Incomplete 200 Level CBTs Detail.xlsx` | TMS export: users with incomplete 200-level Computer-Based Trainings |
| `2026.08.21_Super User Program Completion Detail.xlsx` | TMS export: Super User program completion detail |
| `PBI - EHRM Incomplete 200 Level CBTs Details.url` | Link to the corresponding Power BI report |
| `PBI - EHRM Super User Program Completion Details.url` | Link to the corresponding Power BI report |

> All `.xlsx`/`.csv` data files here are **git-ignored** (by extension) — they contain real VA training
> records and must never be committed. The `.url` shortcuts are tracked pointers to the published reports.

## Production data path

TMS automatically emails its Program Completion Detail CSV approximately every six hours. The new
[`parseTMSReportsToSharePoint`](../../powerAutomate/parseTMSReportsToSharePoint/) flow copies the original
attachment bytes to the internal SharePoint file
`TMS_Reports/TMSProgramCompletion_DetailedReport.csv` and creates an archive copy. That stable SharePoint
file is the primary data source for the local/internal `578 EHRM Training Details Reports.pbix` report.

The flow does not transform the production CSV and does not trigger a Power BI refresh. Power Query and
Power BI own downstream shaping and refresh scheduling.

## Note on environment-specific values
Exports and PBIX files contain or expose personally identifiable VA training records. They remain
git-ignored; keep them in internal/local paths and follow [`.github/SECURITY.md`](../../../.github/SECURITY.md)
before sharing.
