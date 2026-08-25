# Analytics (Power BI, SQL & TMS data)

This folder holds the reporting and data-analysis components for the EHRM Training & Booking App: Power BI
reports/dashboards, supporting SQL, and staged VA **TMS** (Talent Management System) completion data.

**Status @ v1.0.12:** actively developed. Two Power BI reports now exist (one still work-in-progress) and a
new `tms/` data-staging folder was added. See
[`v1.0.12_differenceAnalysis.md`](v1.0.12_differenceAnalysis.md).

## Structure

```
src/analytics/
├── powerBI/
│   ├── .pbit/       — Power BI template(s) (tracked source-of-truth: "Signup Tool.pbit")
│   ├── .pbix/       — Power BI report binaries (git-ignored): "Signup Tool.pbix", "SuperUserDashboard-Final.pbix"
│   └── local/       — local-only templates/scratch (git-ignored)
├── tms/
│   ├── lists/       — staged VA TMS completion exports (.xlsx) + Power BI links (.url) (git-ignored data)
│   └── powerBI/     — placeholder for TMS-specific reports
└── sql/
    ├── procedures/  — stored procedures (scaffold)
    ├── queries/     — reporting queries
    └── local/       — local-only staging/scratch (git-ignored)
```

See [`powerBI/README.md`](powerBI/README.md) and [`tms/README.md`](tms/README.md) for details.

## Power BI (summary)

- **`Signup Tool`** — the sign-up/attendance report; `.pbit` template is tracked (source-controlled),
  `.pbix` stays local. Uses row-level, identity-aware DAX so a signed-in user sees their own eligible
  scenarios.
- **`SuperUserDashboard-Final`** — a leadership dashboard (thin report on a published dataset); **WIP**.

## Note on environment-specific values

Power BI reports embed data-source URLs (SharePoint sites, Excel workbooks), a published dataset ID, and
row-level-security DAX keyed on `USERPRINCIPALNAME()`. TMS exports contain real VA completion data (kept in
git-ignored `local/`). Review before committing/publishing per
[`.github/SECURITY.md`](../../.github/SECURITY.md).
