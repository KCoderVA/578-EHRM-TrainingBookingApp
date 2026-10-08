# Analytics (Power BI, SQL & TMS data)

This folder holds the reporting and data-analysis components for the 578 EHRM Training App: Power BI
reports/dashboards, supporting SQL, and staged VA **TMS** (Talent Management System) completion data.

**Status @ v1.3.5:** actively developed (analytics components unchanged since v1.2.7). The TMS reporting
area (`tms/`) is **local-only and excluded from the public repo** for now, pending organization for a
future release; locally it maintains the canonical CSV used by the internal 578 EHRM Training Details report.

## Structure

```
src/analytics/
├── powerBI/
│   ├── .pbit/       — Power BI template(s) (tracked source-of-truth: "Signup Tool.pbit")
│   ├── .pbix/       — Power BI report binaries (git-ignored): "Signup Tool.pbix", "SuperUserDashboard-Final.pbix"
│   └── local/       — local-only templates/scratch (git-ignored)
├── tms/             — LOCAL-ONLY / excluded from public repo (WIP; see .gitignore §10)
│   ├── lists/       — staged VA TMS completion exports (.xlsx) + Power BI links (.url) (local-only)
│   └── powerBI/     — local/internal TMS-specific Power BI reports (local-only)
└── sql/
    ├── queries/     — reporting queries
    └── local/       — local-only staging/scratch (git-ignored)
```

See [`powerBI/README.md`](powerBI/README.md) for details. *(The `tms/` reporting area is local-only and not published to the public repo yet.)*

## Power BI (summary)

- **`Signup Tool`** — the sign-up/attendance report; `.pbit` template is tracked (source-controlled),
  `.pbix` stays local. Uses row-level, identity-aware DAX so a signed-in user sees their own eligible
  scenarios.
- **`SuperUserDashboard-Final`** — a leadership dashboard (thin report on a published dataset); **WIP**.
- **`578 EHRM Training Details Reports`** — internal management/executive report sourced primarily from
    the canonical SharePoint TMS Program Completion Detail CSV maintained by Power Automate.

## Note on environment-specific values

Power BI reports embed data-source URLs (SharePoint sites, Excel workbooks), a published dataset ID, and
row-level-security DAX keyed on `USERPRINCIPALNAME()`. TMS exports contain real VA completion data (kept in
git-ignored `local/`). Review before committing/publishing per
[`.github/SECURITY.md`](../../.github/SECURITY.md).
