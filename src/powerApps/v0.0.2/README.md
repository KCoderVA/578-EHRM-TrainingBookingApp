# Power App: 578 Training Scheduler

**Version**: 0.0.1
**Description**: recurrence add to outlook working

## Provenance / credits (v0.0.1 baseline)
- The initial `.msapp` used as the starting point for this project was shared by **Hiram A. Zayas** (Hiram.Zayas@va.gov), Health Informatics Service, Battle Creek VA Medical Center.
- This repo stores both the original app package and the unpacked source:
    - App package: `src/powerApps/.msapp/v0.0.1_578TrainingSchedulerApp.msapp`
    - Unpacked source: `src/powerApps/.unpacked/`
- The app’s connected SharePoint list sample data (sanitized) is stored locally under `src/sharePoint/lists/`.

## 1. App Overview
- **App Type**: Phone
- **Orientation**: landscape
- **Connectors**:
    - Office 365 Outlook
    - Office 365 Users
    - SharePoint
- **Data Sources**:
    - **SharePoint**:
        - Desk Reservations
        - DeskAccessControl
        - Desks
    - **Office 365 Outlook**:
        - Actions: CalendarGetTables, V3CalendarPostItem, V2CalendarPostItem, FindMeetingTimes, GetRoomLists, GetRooms, GetRoomsInRoomList
    - **Office 365 Users**:
        - Actions: SearchUser

## 2. Screens
The application is composed of the following screens, in order of appearance:
1.  `Dashboard`
2.  `MyAppts`
3.  `POCSUPERVISOR`
4.  `chkWeekDays`
5.  `DeskSelect`
6.  `Confirm`
7.  `Success`
8.  `ManageDesks`
9.  `NewDesk`
10. `NewEditDesk`
11. `Reservation`
12. `SuccessDeskMod`
13. `ReleaseNotes`
14. `Screen3`
15. `scrn_MoCalendar`
16. `scrn_WeeklyCal`
17. `scrn_WeeklyCal_1`
18. `DebuggingScreen`
19. `Screen1`
20. `PDFScreen`
21. `Screen2`
