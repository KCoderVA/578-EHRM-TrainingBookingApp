# Analytics (Power BI & SQL)

This folder holds reporting and data-analysis components for the EHRM Training & Booking App: Power BI reports/dashboards and supporting SQL scripts.

**Status**: New component, introduced v0.3.8. Early-stage/scaffolded — see per-subfolder status below.

## Structure

```
src/analytics/
├── powerBI/
│   ├── .pbit/       — Power BI template files (tracked)
│   ├── .pbix/       — Power BI report binaries (git-ignored — large binary; use .pbit for source control)
│   └── local/       — local-only staging/scratch files (git-ignored)
└── sql/
    ├── procedures/  — stored procedures (currently empty — scaffold only)
    ├── queries/     — ad hoc / reporting queries (currently empty — scaffold only)
    └── local/       — local-only staging/scratch files (git-ignored)
```

## Power BI

- `Signup Tool.pbit` — early-stage Power BI report template covering sign-up/attendance data for the app. The `.pbit` template is tracked so the report definition is source-controlled; the corresponding `.pbix` (bound to live data) stays local-only and git-ignored (see [`.gitignore`](../../.gitignore) §9).

## SQL

No stored procedures or queries have been added yet — `procedures/` and `queries/` are placeholders for upcoming database scripting and data-integrity checks referenced in [`.github/copilot-instructions.md`](../../.github/copilot-instructions.md).

## Note on environment-specific values

Review Power BI reports and any future SQL scripts for connection strings, server names, or other environment-specific values before committing. See [.github/SECURITY.md](../../.github/SECURITY.md).
