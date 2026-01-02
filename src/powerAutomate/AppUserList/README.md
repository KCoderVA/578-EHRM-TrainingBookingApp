# Power Automate Flow: AppUserList (v0.0.1 template)

## Purpose
This flow watches for new or updated entries in the access-control SharePoint list (local sanitized sample: `src/sharePoint/lists/DeskAccessControl/DeskAccessControl.csv`).

When a user’s email and access level are added/changed by an admin, the flow populates the remaining list columns using Active Directory / Microsoft 365 user profile data. The app uses the SharePoint column `AccessLevel_Choice` to dynamically enable/disable functionality and views.

## Source / authorship
- This flow template was originally authored by Kyle.Coder@va.gov for a previous project and imported here as the first baseline flow for the EHRM Training Scheduler App.

## Files
- Packaged zip: `src/powerAutomate/AppUserList/importedTemplate/.zip/`
- Unpacked template: `src/powerAutomate/AppUserList/importedTemplate/.unpacked/`

## Important note (public repo)
The unpacked flow definition may include environment-specific identifiers and internal URLs/emails from the source environment. Review and sanitize as appropriate before publishing broadly.
