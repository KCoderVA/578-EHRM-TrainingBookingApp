# Power BI — Reports

Two Power BI reports support the EHRM Super User Learning Lab program. Report binaries (`.pbix`) are
**git-ignored** (large + may embed cached data); the **`.pbit` template** is the tracked source of truth.

> **Status @ v1.0.12:** `Signup Tool` is functional; `SuperUserDashboard-Final` is **work-in-progress**.

## 1. `Signup Tool` (`.pbit` tracked, `.pbix` local)

An identity-aware self-service report that shows a signed-in Super User the Learning Lab scenarios/sessions
relevant to **their** role, and supports registering "for me" or "for someone else."

- **Model:** ~40 tables (incl. Power BI auto date tables). Core entities:
  - `URAChicagoRaw` / `URAChicagoSU` — Super User roster (SharePoint, `…/VACO.OEHRMvisn/SitesDeploy`;
    `URAChicagoSU` = filtered `SuperUser = "Yes"`).
  - `URAChicago_AllRoles` / `URAChicagoSU_AllRoles` — role expansion (list-column expand + merge).
  - `EHRMRoles` — role reference (SharePoint).
  - `Scenario` (+ `Scenario Narratives`) — Learning Lab scenarios (SharePoint `…/vacoehrmioeue/Sandbox`).
  - `Master Schedule List`, `Seat Information`, `Seat Information_Link`, `Seat_Information_Cell_Reference`,
    `IcsLLs`, `IcsLLs_Scenario` — schedule/seating (Excel workbooks on `…/vhachsfehrm/superusers`).
  - `CTPMappingTable` — inline Care-Team-Participant → canonical-role mapping.
- **Row-level, identity-aware DAX** (users see only their eligible content):
  - `CurrentUser = USERPRINCIPALNAME()`
  - `IsCurrentUserEmailMatch = IF( MIN(URAChicago_AllRoles[VAEmail]) = USERPRINCIPALNAME(), 1, 0 )`
  - `IsRoleMatch` — matches the signed-in user's roles to a scenario's `Care Team Participants`.
- **Pages:** `Diagnostics`, `SU Learning Lab - For Me`, `SU Learning Lab - Someone Else`,
  `SU Learning Lab - Search`, `Scenario Description`, `Sign-Up App`.

## 2. `SuperUserDashboard-Final` (`.pbix` local; WIP)

A leadership dashboard built as a **thin report** connected to a **published Power BI dataset**
(`DatasetId 3c9a5dc7-14b0-4e79-9e9b-926eeb800fd1`), not an embedded model.

- **Pages:** `Coming Soon` (placeholder), `Hines EHRM Super Users`, `HinesSuperUserOnlyDashboard`.
- **Visuals:** slicers, cards, a column chart and a bar chart, and detail tables.

## Using these reports elsewhere
1. Open the `.pbit` template in Power BI Desktop (US Gov tenant).
2. When prompted, supply the data-source parameters and authenticate to the SharePoint sites / Excel
   workbooks (or substitute your own equivalents).
3. For `SuperUserDashboard-Final`, re-bind the report to your own published dataset.
4. Publish to your Power BI (GOV) workspace; the app's printable `Screen1` embeds a GOV-cloud tile.

## Note on environment-specific values
These reports embed VA SharePoint/Excel data-source URLs, a published dataset ID, and RLS DAX keyed on
`USERPRINCIPALNAME()`. Review/sanitize before publishing broadly; keep `.pbix` local.
