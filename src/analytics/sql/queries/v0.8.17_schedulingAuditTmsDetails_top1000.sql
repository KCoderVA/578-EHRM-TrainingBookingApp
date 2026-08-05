/*======================================================================================
Author:         Kara Halpin
Creation Date:  10/23/2019
Description:    Main dataset for scheduling audit/TMS details report.

Converted:      Standalone read-only "SELECT TOP 1000" script (view-style output).
                Formerly a stored procedure body. Because this logic relies on
                variables, temp tables, and DROP/UPDATE/INTO statements, it cannot
                be expressed as a literal CREATE VIEW. Instead this is a runnable
                script that declares the former procedure parameters as local
                variables, runs the identical logic, and returns the final result
                set capped at TOP (1000) rows.
                All writes target #temp tables only, so source data is never modified.
Change History:


=======================================================================================*/

--SET STATISTICS IO ON

-- Former stored-procedure parameters, now declared as local variables so the
-- script runs standalone. Adjust the SET values below as needed.
DECLARE @start        DATETIME2(0)
       ,@TrainingDate DATETIME2(0)
       ,@DaysBack     SMALLINT
       ,@StaffClass   VARCHAR(MAX);

SET @start        = CAST(DATEADD(DAY, -30, GETDATE()) AS DATETIME2(0));
SET @TrainingDate = CAST(DATEADD(YEAR,  -6, GETDATE()) AS DATETIME2(0));
SET @DaysBack     = 30;
SET @StaffClass   = 'MSA';

BEGIN
    USE [LSV]
    DROP TABLE IF EXISTS #location
    SELECT
        l.LocationSID
			, l.locationName
            , StopCode As 'PrimaryStopCode'
            , l.NoncountClinicFlag
			, l.DivisionSID

    INTO #location

    FROM LSV.Dim.[Location] As l
        INNER JOIN LSV.Dim.StopCode As s On StopCodeSID = PrimaryStopCodeSID
    --Filter on all clinics in the SAT Tool stops and add any additional stops you want to pull (i.e. radiology)

    WHERE (l.LocationSID In (Select LocationSID
        From BISL_SCHEDAUD.App.Audit_LocationsIncludedInAuditing
        Where LocationSID = l.LocationSID)
        Or l.LocationSID In (Select LocationSID
        From LSV.Dim.[Location]
        Where PrimaryStopCodeSID In (Select StopCodeSID
        From LSV.Dim.StopCode
        Where StopCode In (105,115,150,151,669))))
        --Remove any clinics that are inactivated > 30 days ago. No scheduling should have occured and this will greatly reduce size of this table
        AND ([InactivationDateTime] Is Null Or [InactivationDateTime] > CAST(DateAdd(day, -30, GetDate()) As DateTime2(0))
        Or [ReactivationDateTime] > [InactivationDateTime])

    delete from  #location where primarystopcode=674
        and ( locationname like '%' +'VTS' + '%' or locationname like '%' +'transpo' + '%' or locationname like '%' +'shuttle' + '%' or locationname like '%' +'NPT-DAV' + '%' or locationname like '%' +'TRANSPORT' + '%' or locationname like '%' +'TRANS-DAV' + '%' or locationname like '%' +'-VAN-' + '%'  )

    -- Temp Table Resloving Stapc For reporting and resloving DataEntryStaffSID
    DROP TABLE IF EXISTS #TempApptPre


    SELECT
        APT.Sta3n
		  , AppointmentSID
          , DataEntryStaffSID = CASE
                 WHEN [DataEntryStaffSID] = - 1
            OR [DataEntryStaffSID] IS NULL
                 THEN DataEntryLocationStaffSID
               ELSE [DataEntryStaffSID]
              END
          , APT.LocationSID
          , DivisionSID
          , apt.PatientSID
          , (CASE WHEN APT.AppointmentMadeDate = CAST(APT.AppointmentDateTime As Date) THEN 1 ELSE 0 END) As 'SameDay'
		  , AppointmentMadeDate

    Into #TempApptPre
    FROM LSV.Appt.Appointment APT
        INNER join #location As Loc on apt.locationsid = Loc.LocationSID

    WHERE APT.AppointmentDateTime >=CAST(DATEADD(DAY, - 60, GETDATE()) AS DATETIME2(0))
        AND APT.AppointmentMadeDate >= @start
        AND APT.AppointmentMadeDate < CAST(GetDate() As DateTime2(0))

    DROP TABLE IF EXISTS #TempAppt

    Select

        APT.Sta3n,
        (CASE WHEN (DI.StaPc = '*' Or DI.StaPc Is Null) then cast(Apt.Sta3n as varchar(10)) ELSE
      StaPc END) as StaPc,
        DataEntryStaffSID,
        LocationSID,
        APT.DivisionSID,
        APT.PatientSID,
        SameDay,
        TestPatientFlag,
        AppointmentMadeDate

    INTO #TempAppt

    From #TempApptPre As APT
        INNER JOIN LSV.dim.division Div on APT.DivisionSID = Div.DivisionSID
        INNER JOIN LSV.dim.institution DI on div.InstitutionSID = DI.InstitutionSID
        INNER HASH JOIN LSV.SPatient.SPatient As p ON APT.PatientSID = p.PatientSID

    Where SameDay = 0

    DROP TABLE IF EXISTS #tmpAPPpre

    select

        VISN,
        a.sta3n,
        a.staPC,
        a.DataEntryStaffSID,
        Max(AppointmentMadeDate) As 'LastScheduledAppt',
        COUNT(*) 'ScheduledCount'

    into #tmpAPPpre

    from #TempAppt As a
        INNER JOIN LSV.Dim.VistASite As v On a.Sta3n = v.Sta3n

    WHERE (testPatientFlag='N' or TestPatientFlag is Null)

    GROUP BY VISN, a.Sta3n, a.staPC, a.DataEntryStaffSID

    DROP TABLE IF EXISTS #tmpAppStaff

    SELECT

        VISN,
        a.sta3n,
        a.staPC,
        StaffSID,
        a.DataEntryStaffSID,
        ss.staffssn,
        ss.StaffName,
        ss.PositionTitle,
        ScheduledCount,
        LastScheduledAppt,
        ServiceSection,
        terminationDate,
        (CASE WHEN ss.PositionTitle In ('ADVANCED MED SUPPORT ASSISTANT', 'MEDICAL SUPPORT ASSISTANT') Then 'MSA' ELSE StaffClassPosition END) As 'StaffClassPosition',
        StaffClass,
        SupervisorGroup,
        SupGroupOwner_StaffName,
        ServiceGroup

    into #tmpAppStaff

    From #tmpAPPpre As a
        INNER HASH join LSV.SStaff.SStaff ss On a.DataEntryStaffSID = ss.StaffSID
        LEFT JOIN LSV.BISL_SCHEDAUD.AuditPositionTitlesByStaffGrouping As g On a.DataEntryStaffSID = g.DataEntryStaffSID

    --exemptions and needed modifications
    --wrong SSN assigned to staff at facility
    update  #tmpAPPStaff set staffssn='309684142' where DataEntryStaffSid=2866592
    update  #tmpAPPStaff set staffssn='316644101' where DataEntryStaffSid=13402521
    update  #tmpAPPStaff set staffssn='626429067' where DataEntryStaffSid=805539774
    update  #tmpAPPStaff set staffssn='305808671' where DataEntryStaffSid=7558550
    update  #tmpAPPStaff set staffssn='489982654' where DataEntryStaffSid=1006291533
    update  #tmpAPPStaff set staffssn='463112882' where DataEntryStaffSid=4028334
    update  #tmpAPPStaff set staffssn='581698678' where DataEntryStaffSid=1207087453

    drop table IF EXISTS #tmp1

    select distinct t.VISN, t.sta3n, t.staPC, t.DataEntryStaffSid, t.Staffssn, t.staffName, SupervisorGroup, SupGroupOwner_StaffName,
        t.positiontitle, t.scheduledCount, LastScheduledAppt, b.stationnumber as 'tms_sta3n', coursecompletiondate, ssn, courseid, terminationDate

    into #tmp1

    from #tmpAPPStaff As t
        LEFT JOIN LSV.BISL_Collab.TMS_tms_course_completions As b On t.staffssn = b.ssn
            And courseid In (7532, 7533, 7534, 7535, 31329, 31351, 31508, 31632, 32449, 4208765, 4200889,4661783, 4212521, 31360, 33382, 33395, 29422, 33383, 33359, 29867)

    Where terminationDate Is Null Or TerminationDate > GetDate()

    DROP TABLE IF EXISTS #tmpTrain

    select distinct ss.visn, ss.sta3n, ss.staPC, ss.DataEntryStaffSID, ss.StaffSSN, ss.staffname, ss.positiontitle, ss.scheduledcount, tms_sta3n, LastScheduledAppt, SupervisorGroup, SupGroupOwner_StaffName,

        (SELECT

            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 7532
            AND t.ssn = ss.StaffSSN)
                      'RecallReminder_TrainingDate'
                      , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 7533
            AND t.ssn = ss.StaffSSN)
                      'SoftSkills_TrainingDate'
                      , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 7534
            AND t.ssn = ss.StaffSSN)
                      'BusinessRules_TrainingDate'
                      , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 7535
            AND t.ssn = ss.StaffSSN)
                      'MakeAppointment_TrainingDate'

                                    , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 31329
            AND t.ssn = ss.StaffSSN)
                      'Onboarding1_TrainingDate'
                           , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 31351
            AND t.ssn = ss.StaffSSN)
                      'Refresher1_TrainingDate'

                          , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 31508
            AND t.ssn = ss.StaffSSN)
                      'Refresher2_TrainingDate'
                          , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 31632
            AND t.ssn = ss.StaffSSN)
                      'Onboarding2_TrainingDate'
                           , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 32449
            AND t.ssn = ss.StaffSSN)
                      'Onboarding3_TrainingDate'

                      , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 4208765
            AND t.ssn = ss.StaffSSN)
                      'Refresher3_TrainingDate'


               , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 4200889
            AND t.ssn = ss.StaffSSN)
                      'Refresher4_TrainingDate'
                     , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 4212521
            AND t.ssn = ss.StaffSSN)
                      'Onboarding4_TrainingDate'
					   , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 4661783
            AND t.ssn = ss.StaffSSN)
                      'ISS_Scheduler_Training'

         , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 31360
            AND t.ssn = ss.StaffSSN)
                      'TraintheTrainer_TrainingDate'

, (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 33382
            AND t.ssn = ss.StaffSSN)
                      'SchedulerVSETrainingDate'

, (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 33395
            AND t.ssn = ss.StaffSSN)
                      'SchedulerScenarioSkillsReview_Date'

, (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 29422
            AND t.ssn = ss.StaffSSN)
                      'SchedulerVSETraining2Date'
, (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 33383
            AND t.ssn = ss.StaffSSN)
                      'SchedulerVSESuperUserDate'

 , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 33359
            AND t.ssn = ss.StaffSSN)
                      'SchedulerVSESuperUser2Date'


 , (SELECT
            MAX(t.coursecompletiondate)
        FROM #tmp1 t
        WHERE t.courseid = 29867
            AND t.ssn = ss.StaffSSN)
                      'ChoiceSingleBooking2Date'

    into #tmpTrain
    FROM #tmp1 As ss
    Where StaffSSN Is Not Null

    --select * from #tmpTrain

    DROP TABLE IF EXISTS #tmpAllTrain

    select z.*, iif(RecallReminder_TrainingDate >= @TrainingDate,'Y','N')as RecallReminder_TrainingDone,
        iif(SoftSkills_TrainingDate >= @TrainingDate,'Y','N')as softskills_TrainingDone,
        iif(BusinessRules_TrainingDate >= @TrainingDate,'Y','N')as BusinessRules_TrainingDone,
        iif(MakeAppointment_TrainingDate >= @TrainingDate,'Y','N')as MakeAppointment_TrainingDone,
        iif(Onboarding1_TrainingDate >= @TrainingDate,'Y','N')as Onboarding1_TrainingDone,
        iif(Refresher1_TrainingDate >= @TrainingDate,'Y','N')as Refresher1_TrainingDone,
        iif(Refresher2_TrainingDate >= @TrainingDate,'Y','N')as Refresher2_TrainingDone,
        iif(Onboarding2_TrainingDate >= @TrainingDate,'Y','N')as onboarding2_TrainingDone,
        iif(Refresher3_TrainingDate >= @TrainingDate,'Y','N')as Refresher3_TrainingDone,
        iif(Onboarding3_TrainingDate >= @TrainingDate,'Y','N')as Onboarding3_TrainingDone,
        iif(Refresher4_TrainingDate >= @TrainingDate,'Y','N')as Refresher4_TrainingDone,
        iif(Onboarding4_TrainingDate >= @TrainingDate,'Y','N')as Onboarding4_TrainingDone,
        iif(TraintheTrainer_TrainingDate >= @TrainingDate,'Y','N')as TraintheTrainer_TrainingDone,
        iif(SchedulerVSETrainingDate >= @TrainingDate,'Y','N')as SchedulerVSETrainingDone,
        iif(SchedulerScenarioSkillsReview_Date >= @TrainingDate,'Y','N')as SchedulerScenarioSkillsReview_Done,
        iif(SchedulerVSETraining2Date >= @TrainingDate,'Y','N')as SchedulerVSETraining2Done,
        iif(SchedulerVSESuperUserDate >= @TrainingDate,'Y','N')as SchedulerVSESuperUserDone,
        iif(SchedulerVSESuperUser2Date >= @TrainingDate,'Y','N')as SchedulerVSESuperUser2Done,
        iif(ChoiceSingleBooking2Date >= @TrainingDate,'Y','N')as ChoiceSingleBooking2Dater2Done,

        iif(Onboarding1_TrainingDate >= @TrainingDate or
                          Refresher1_TrainingDate >= @TrainingDate or
                           Refresher2_TrainingDate >= @TrainingDate or
                     Onboarding2_TrainingDate >= @TrainingDate or
                  Onboarding3_TrainingDate >= @TrainingDate or
                     Onboarding4_TrainingDate >= @TrainingDate or
                     Refresher3_TrainingDate >= @TrainingDate or
                     TraintheTrainer_TrainingDate >= @TrainingDate or
              Refresher4_TrainingDate >= @TrainingDate, 'Y','N') As 'ANY_TRAINING_DONE',
        iif((SchedulerVSETrainingDate  >= @TrainingDate and SchedulerScenarioSkillsReview_Date>= @TrainingDate) or  (Onboarding3_TrainingDate >= @TrainingDate and ISS_Scheduler_Training >=@TrainingDate),
                        'Y','N') As 'ANY_VSE_Training_DONE'

    into #tmpAllTrain

    from #tmpTrain z


    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where SchedulerVSESuperUser2Date >= @TrainingDate or SchedulerVSESuperUserDate >= @TrainingDate

    --exempt from VSE training
    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where sta3n=757 or sta3n=583 or sta3n =664
    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where dataentryStaffSid=1693124
    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where dataentryStaffSid=1003812358

    ---staff record did not get pushed into CDW
    update #tmpAllTrain set ANY_Training_DONE='Y' where dataentryStaffSid=1201194120

    --staff came back as volunteer so his training was dropped from cdw-station 635
    update #tmpAllTrain set ANY_Training_DONE='Y' where dataentryStaffSid=4011494
    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where dataentryStaffSid=4011494

    --radiation therapists whose dosage make a phantom appt in VISTA
    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where dataentryStaffSid=2340215
    update #tmpAllTrain set ANY_Training_DONE='Y' where dataentryStaffSid=2340215

    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where dataentryStaffSid=1200837733
    update #tmpAllTrain set ANY_Training_DONE='Y' where dataentryStaffSid=1200837733

    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where dataentryStaffSid=1202965881
    update #tmpAllTrain set ANY_Training_DONE='Y' where dataentryStaffSid=1202965881

    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where dataentryStaffSid=10887511
    update #tmpAllTrain set ANY_Training_DONE='Y' where dataentryStaffSid=10887511

    update #tmpAllTrain set ANY_VSE_Training_DONE='Y' where dataentryStaffSid=2175903
    update #tmpAllTrain set ANY_Training_DONE='Y' where dataentryStaffSid=2175903

    DROP TABLE IF EXISTS #tmpFinalStaff

    select a.* , b.staffClassPosition as job_type, b.servicegroup,
        iif(ANY_TRAINING_DONE= 'Y' and ANY_VSE_Training_DONE  ='Y','Y','N') As 'BOTH_VSE_MSA_Training_DONE'
    into #tmpFinalStaff
    from #tmpAllTrain      as a
        left join #tmpAppStaff as b on a.dataEntryStaffSid = b.dataEntryStaffSid
            and a.StaPc=b.staPC

    DROP TABLE IF EXISTS #tmpFacilityTotal
    --INSERT INTO #tmpFacilityTotal
    SELECT DISTINCT a.VISN AS VISN, a.StaPC AS Sta3n, PositionTitle,
        count(staffName) AS [# of Staff Scheduling], sum(a.ScheduledCount) AS [Appts made],
        sum(case when a.any_training_done ='Y' then 1 else 0 end)  AS [Staff Trained],
        sum(case when a.any_training_done ='N' then 1 else 0 end)  AS [Staff NOT Trained],
        sum(case when a.ANY_VSE_Training_DONE ='Y' then 1 else 0 end ) AS [Staff VSE Trained],
        sum(case when a.ANY_VSE_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE NOT Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='Y' then 1 else 0 end) AS [Staff VSE AND MSA Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE AND MSA NOT Trained] ,
        3 AS orderNo
    INTO #tmpFacilityTotal
    FROM #tmpFinalStaff a
    GROUP BY VISN, staPC, positiontitle

    INSERT INTO #tmpFacilityTotal
    SELECT DISTINCT a.VISN AS VISN, a.StaPC AS Sta3n, a.[job_type] + ' TOTAL' AS PositionTitle,
        count(staffName) AS [# of Staff Scheduling], sum(a.ScheduledCount) AS [Appts made],
        sum(case when a.any_training_done ='Y' then 1 else 0 end)  AS [Staff Trained],
        sum(case when a.any_training_done ='N' then 1 else 0 end)  AS [Staff NOT Trained],
        sum(case when a.ANY_VSE_Training_DONE ='Y' then 1 else 0 end ) AS [Staff VSE Trained],
        sum(case when a.ANY_VSE_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE NOT Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='Y' then 1 else 0 end) AS [Staff VSE AND MSA Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE AND MSA NOT Trained] , 1 AS orderNo
    -- INTO #tmpFacilityTotal
    FROM #tmpFinalStaff a
    GROUP BY VISN, staPC, [job_type]


    INSERT INTO #tmpFacilityTotal
    SELECT DISTINCT a.VISN, a.StaPC AS sta3n, 'ALL STAFF' AS PositionTitle, count(staffName) AS [# of Staff Scheduling],
        sum(a.ScheduledCount) AS [Appts made],
        sum(case when a.any_training_done ='Y' then 1 else 0 end)  AS [Staff Trained],
        sum(case when a.any_training_done ='N' then 1 else 0 end)  AS [Staff NOT Trained],
        sum(case when a.ANY_VSE_Training_DONE ='Y' then 1 else 0 end ) AS [Staff VSE Trained],
        sum(case when a.ANY_VSE_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE NOT Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='Y' then 1 else 0 end) AS [Staff VSE AND MSA Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE AND MSA NOT Trained] ,
        2 AS orderNo
    from #tmpfinalStaff a
    GROUP BY VISN, staPC



    INSERT INTO #tmpFacilityTotal
    SELECT DISTINCT ' ' AS VISN, 'ALL FACILITY' AS Sta3n, a.[job_type] + ' TOTAL' AS PositionTitle, count(staffName) AS [# of Staff Scheduling],
        sum(a.ScheduledCount) AS [Appts made],
        sum(case when a.any_training_done ='Y' then 1 else 0 end)  AS [Staff Trained],
        sum(case when a.any_training_done ='N' then 1 else 0 end)  AS [Staff NOT Trained],
        sum(case when a.ANY_VSE_Training_DONE ='Y' then 1 else 0 end ) AS [Staff VSE Trained],
        sum(case when a.ANY_VSE_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE NOT Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='Y' then 1 else 0 end) AS [Staff VSE AND MSA Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE AND MSA NOT Trained]
 , 1 AS orderNo
    FROM #tmpFinalStaff a
    GROUP BY [job_type];


    INSERT INTO #tmpFacilityTotal
    SELECT ' ' AS VISN, 'ALL FACILITY' AS Sta3n, 'ALL STAFF' AS PositionTitle,
        count(staffName) AS [# of Staff Scheduling], sum(a.ScheduledCount) AS [Appts made],
        sum(case when a.any_training_done ='Y' then 1 else 0 end)  AS [Staff Trained],
        sum(case when a.any_training_done ='N' then 1 else 0 end)  AS [Staff NOT Trained],
        sum(case when a.ANY_VSE_Training_DONE ='Y' then 1 else 0 end ) AS [Staff VSE Trained],
        sum(case when a.ANY_VSE_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE NOT Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='Y' then 1 else 0 end) AS [Staff VSE AND MSA Trained],
        sum(case when a.BOTH_VSE_MSA_Training_DONE='N' then 1 else 0 end ) AS [Staff VSE AND MSA NOT Trained] ,
        2 AS orderNo
    FROM #tmpFinalStaff a




    DROP TABLE IF EXISTS #tblFinalData

    SELECT

        a.VISN,
        LEFT(a.Sta3n, 3) As 'Sta3n',
        a.Sta3n As 'StaPc',
        a.PositionTitle,
        a.[# of Staff Scheduling],
        a.[Appts made], a.[Staff Trained] as [staff MSA Trained],
        a.[Staff NOT Trained] as [staff NOT MSA Trained],
        [Staff VSE Trained],
        [Staff VSE NOT Trained],
        [Staff VSE AND MSA Trained],
        [Staff VSE AND MSA NOT Trained],
        cast(cast( [Staff Trained]as float) /cast([# of Staff Scheduling]as float) as decimal (9,4)) AS [% trained],
        cast(cast ( [Staff VSE Trained] as float)/cast([# of Staff Scheduling] as float) as decimal (9,4)) AS [% VSE trained],
        cast(cast ([Staff VSE AND MSA Trained] as float)/ cast([# of Staff Scheduling] as float) as decimal(9,4)) AS [% MSA AND VSE trained],
        orderNo
    INTO #tblFinalData
    FROM #tmpFacilityTotal a
    where [positiontitle]='MSA TOTAL' or [positiontitle]='Non-MSA TOTAL' or [positiontitle]='All Staff'

    Select TOP (1000)

        VISN,
        Sta3n,
        StaPc,
        (CASE WHEN PositionTitle = 'MSA TOTAL' Then 'MSA'
      WHEN PositionTitle = 'Non-MSA TOTAL' Then 'Non-MSA' END) As 'PositionTitle',
        [# of Staff Scheduling],
        [Appts made],
        [staff MSA Trained],
        [staff NOT MSA Trained],
        [Staff VSE Trained],
        [Staff VSE NOT Trained],
        [Staff VSE AND MSA Trained],
        [Staff VSE AND MSA NOT Trained],
        [% trained],
        [% VSE trained],
        [% MSA AND VSE trained],
        orderNo,
        Facility

    From
        (
select

            t.VISN,
            t.Sta3n,
            t.StaPc,
            PositionTitle,
            [# of Staff Scheduling],
            [Appts made],
            [staff MSA Trained],
            [staff NOT MSA Trained],
            [Staff VSE Trained],
            [Staff VSE NOT Trained],
            [Staff VSE AND MSA Trained],
            [Staff VSE AND MSA NOT Trained],
            [% trained],
            [% VSE trained],
            [% MSA AND VSE trained],
            orderNo,
            Facility

        from #tblFinalData As t
            INNER JOIN LSV.BISL_SCHEDAUD.Dim_StaPc As i On t.StaPc = i.StaPc
        WHERE t.StaPc <> 'ALL FACILITY'
            And t.Sta3n <> 'ALL'
            And PositionTitle <> 'ALL STAFF'
) As x
    order by VISN,sta3n,orderno
--select * from #tmpFacilityTotal

END
GO
