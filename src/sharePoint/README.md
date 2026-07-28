# SharePoint (Lists & Search Configuration)

This folder documents the SharePoint lists that back the EHRM Training & Booking App, along with sanitized/local sample data and search configuration exports.

## Structure (current — introduced v0.3.8)

```
src/sharePoint/
├── list/
│   ├── deskAccessControl/local/   — DeskAccessControl.csv (raw export; git-ignored)
│   ├── deskReservations/local/    — Desk Reservations.csv (raw export; git-ignored)
│   ├── desks/local/                — Desks.csv, Desks.xlsx, versioned variants (raw exports; git-ignored)
│   └── schedule/local/             — Schedule list staging data (raw export; git-ignored) — see "Schedule list (new/planned)" below
└── searchConfig/
    └── SearchConfiguration.xml     — SharePoint search configuration export (tracked)
```

Everything under a `local/` subfolder is **local-only and git-ignored by design** (both by file extension — `.csv`/`.xlsx`/etc. — and by folder name, per [`.gitignore`](../../.gitignore) §10–§11). These raw exports may contain real VA scheduling data and must never be committed as-is. Only `searchConfig/SearchConfiguration.xml` is tracked in this component.

## Lists

| List | Folder | Status |
|---|---|---|
| `DeskAccessControl` | `list/deskAccessControl/` | Active — drives Canvas app RBAC (`AccessLevel_Text` column) |
| `Desk Reservations` | `list/deskReservations/` | Active — booking records |
| `Desks` | `list/desks/` | Active — bookable location/room inventory |
| `Schedule` | `list/schedule/` | **New/planned** — scaffold only; no list schema exported yet. Staged from `SULL_Jesse_Brown_Schedule_7.10.26 - Integrated.xlsx` in support of the ongoing "desk reservation" → "training booking" terminology migration (see [docs/PROJECT_STATUS.md](../../docs/PROJECT_STATUS.md)) |

## Provenance / prior structure

The original flat sample layout (`src/sharePoint/Desk Reservations/`, `DeskAccessControl/`, `Desks/`) used through v0.3.7 has been superseded by the `list/<listName>/local/` structure above and archived locally to `archive/src/sharePoint/` per the project's [archive naming conventions](../../.github/copilot-instructions.md). Those files were never tracked in git history under their new paths, and the previously-tracked sanitized CSVs at the old paths have since been untracked (`git rm --cached -r src/sharePoint/`).

## Note on environment-specific values

`searchConfig/SearchConfiguration.xml` and any future tracked exports should be reviewed for site URLs, GUIDs, or other environment-specific identifiers before being committed to the public-facing repository. See [.github/SECURITY.md](../../.github/SECURITY.md).
