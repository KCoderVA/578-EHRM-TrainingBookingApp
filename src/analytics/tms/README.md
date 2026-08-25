# TMS Data Staging (`tms/`)

**New at v1.0.12.** This folder stages VA **TMS** (Talent Management System — the enterprise LMS for
mandatory training) completion exports that feed the Super User program's Power BI reporting. It is a
data-ingestion staging area, not a Power Platform component.

## Structure

```
src/analytics/tms/
├── lists/     — TMS completion exports (.xlsx) + Power BI report links (.url)
└── powerBI/   — placeholder for TMS-specific Power BI report(s)
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

## Purpose & flow

TMS completion data is exported (dated snapshots), staged here, and consumed by Power BI to report on
Super User training progress (e.g., who still has incomplete 200-level CBTs). The `powerBI/` subfolder is
reserved for TMS-specific report files once they are separated from the main `../powerBI/` reports.

## Note on environment-specific values
Exports contain personally identifiable VA training records. Keep them in `local`/git-ignored paths and
follow [`.github/SECURITY.md`](../../../.github/SECURITY.md) before sharing.
