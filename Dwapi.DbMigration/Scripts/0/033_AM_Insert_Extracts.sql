﻿INSERT INTO extract (Id, Destination, Display, DocketId, EmrSystemId, ExtractSql, Ispriority, Name, Rank) 
VALUES 

('d40f5576-9cee-4af2-84a6-4a62d89921fd','PSmartStage','Smart Card','PSMART',(SELECT Id FROM emrsystem WHERE Name = 'IQCare'),'select [Id],[shr],[date_created],[status],[status_date],[uuid] FROM [psmart_store] WHERE UPPER(Status) = ''PENDING''',1,'pSmart',1.00), 

('329bfbf4-d404-4dfd-88eb-6fb398c64249','dwhStage','All Patients','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'IQCare'),'SELECT 
	PatientID, PatientPK, FacilityID, SiteCode, FacilityName, SatelliteName, Gender, DOB, RegistrationDate, RegistrationAtCCC, RegistrationAtPMTCT, RegistrationAtTBClinic, PatientSource, Region, District, Village, 
	ContactRelation, LastVisit, MaritalStatus, EducationLevel, DateConfirmedHIVPositive, PreviousARTExposure, PreviousARTStartDate, StatusAtCCC, StatusAtPMTCT, StatusAtTBClinic, ''IQCare'' AS EMR, 
	''Kenya HMIS II'' AS Project, CAST(GETDATE() AS DATE) AS DateExtracted,newid() as Id
FROM            
	tmp_PatientMaster AS a WHERE a.RegistrationAtCCC IS NOT NULL',1,'Patient',1.00),

('41742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','ART Patients','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'IQCare'),'SELECT   
	a.PatientPK, a.PatientID, c.FacilityID, c.SiteCode, a.FacilityName, a.DOB, a.AgeEnrollment, a.AgeARTStart, a.AgeLastVisit, a.RegistrationDate, a.PatientSource, a.Gender, a.StartARTDate, a.PreviousARTStartDate, 
	a.PreviousARTRegimen, a.StartARTAtThisFacility, a.StartRegimen, a.StartRegimenLine, a.LastARTDate, a.LastRegimen, a.LastRegimenLine, a.Duration, a.ExpectedReturn, a.Provider, a.LastVisit, a.ExitReason, 
	a.ExitDate, CAST(GETDATE() AS DATE) AS DateExtracted
FROM            
	tmp_ARTPatients AS a INNER JOIN
	tmp_PatientMaster AS c ON a.PatientPK = c.PatientPK',0,'PatientArt',2.00),


	
('42742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Baselines','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'IQCare'),'SELECT
	tmp_PatientMaster.PatientPK, tmp_PatientMaster.PatientID, tmp_PatientMaster.FacilityID, tmp_PatientMaster.SiteCode, IQC_bCD4.bCD4, IQC_bCD4.bCD4Date, IQC_bWAB.bWAB, IQC_bWAB.bWABDate, 
	IQC_bWHO.bWHO, IQC_bWHO.bWHODate, IQC_eWAB.eWAB, IQC_eWAB.eWABDate, IQC_eCD4.eCD4, IQC_eCD4.eCD4Date, IQC_eWHO.eWHO, IQC_eWHO.eWHODate, IQC_lastWHO.lastWHO, 
	IQC_lastWHO.lastWHODate, IQC_lastWAB.lastWAB, IQC_lastWAB.lastWABDate, IQC_lastCD4.lastCD4, IQC_lastCD4.lastCD4Date, IQC_m12CD4.m12CD4, IQC_m12CD4.m12CD4Date, IQC_m6CD4.m6CD4, 
	IQC_m6CD4.m6CD4Date, CAST(GETDATE() AS DATE) AS DateExtracted
FROM            
	tmp_PatientMaster LEFT OUTER JOIN
    IQC_bCD4 ON tmp_PatientMaster.PatientPK = IQC_bCD4.PatientPK LEFT OUTER JOIN
    IQC_bWAB ON tmp_PatientMaster.PatientPK = IQC_bWAB.PatientPK LEFT OUTER JOIN
    IQC_bWHO ON tmp_PatientMaster.PatientPK = IQC_bWHO.PatientPK LEFT OUTER JOIN
    IQC_lastCD4 ON tmp_PatientMaster.PatientPK = IQC_lastCD4.PatientPK LEFT OUTER JOIN
    IQC_eWAB ON tmp_PatientMaster.PatientPK = IQC_eWAB.PatientPK LEFT OUTER JOIN
    IQC_eWHO ON tmp_PatientMaster.PatientPK = IQC_eWHO.PatientPK LEFT OUTER JOIN
    IQC_lastWAB ON tmp_PatientMaster.PatientPK = IQC_lastWAB.PatientPK LEFT OUTER JOIN
    IQC_eCD4 ON tmp_PatientMaster.PatientPK = IQC_eCD4.PatientPK LEFT OUTER JOIN
    IQC_lastWHO ON tmp_PatientMaster.PatientPK = IQC_lastWHO.PatientPK LEFT OUTER JOIN
    IQC_m12CD4 ON tmp_PatientMaster.PatientPK = IQC_m12CD4.PatientPK LEFT OUTER JOIN
    IQC_m6CD4 ON tmp_PatientMaster.PatientPK = IQC_m6CD4.PatientPK;' ,0,'PatientBaseline',3.00), 	


	('43742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Status','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'IQCare'),'SELECT   
	tmp_PatientMaster.PatientID, tmp_LastStatus.PatientPK, tmp_PatientMaster.SiteCode, tmp_PatientMaster.FacilityName, tmp_LastStatus.ExitDescription, tmp_LastStatus.ExitDate, tmp_LastStatus.ExitReason, 
	CAST(GETDATE() AS DATE) AS DateExtracted
FROM            
	tmp_LastStatus INNER JOIN
	tmp_PatientMaster ON tmp_LastStatus.PatientPK = tmp_PatientMaster.PatientPK', 0,'PatientStatus',4.00),


	('44742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Labs','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'IQCare'),'SELECT   
	tmp_PatientMaster.PatientID, tmp_Labs.PatientPK, tmp_PatientMaster.FacilityID, tmp_PatientMaster.SiteCode, tmp_PatientMaster.FacilityName, tmp_PatientMaster.SatelliteName, tmp_Labs.VisitID, 
	tmp_Labs.OrderedbyDate, tmp_Labs.ReportedbyDate, tmp_Labs.TestName, tmp_Labs.EnrollmentTest, tmp_Labs.TestResult, CAST(GETDATE() AS DATE) AS DateExtracted
FROM           
	tmp_Labs INNER JOIN
	tmp_PatientMaster ON tmp_Labs.PatientPK = tmp_PatientMaster.PatientPK', 0,'PatientLab',5.00), 

	('46742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Pharmacy','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'IQCare'),'SELECT   
	tmp_PatientMaster.PatientID, tmp_PatientMaster.FacilityID, tmp_PatientMaster.SiteCode, tmp_Pharmacy.PatientPK, tmp_Pharmacy.VisitID, tmp_Pharmacy.Drug, tmp_Pharmacy.Provider, 
	tmp_Pharmacy.DispenseDate, tmp_Pharmacy.Duration, tmp_Pharmacy.ExpectedReturn, tmp_Pharmacy.TreatmentType, tmp_Pharmacy.RegimenLine, tmp_Pharmacy.PeriodTaken, 
	tmp_Pharmacy.ProphylaxisType, CAST(GETDATE() AS DATE) AS DateExtracted
FROM            
	tmp_Pharmacy INNER JOIN
    tmp_PatientMaster ON tmp_Pharmacy.PatientPK = tmp_PatientMaster.PatientPK', 0,'PatientPharmacy',6.00), 

	
	('47742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Visits','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'IQCare'),
	'SELECT   
	REPLACE(tmp_PatientMaster.PatientID, '' '', '''') AS PatientID, tmp_PatientMaster.FacilityName, tmp_PatientMaster.SiteCode, tmp_ClinicalEncounters.PatientPK, tmp_ClinicalEncounters.VisitID, 
	tmp_ClinicalEncounters.VisitDate, tmp_ClinicalEncounters.Service, tmp_ClinicalEncounters.VisitType, tmp_ClinicalEncounters.WHOStage, tmp_ClinicalEncounters.WABStage, tmp_ClinicalEncounters.Pregnant, 
	tmp_ClinicalEncounters.LMP, tmp_ClinicalEncounters.EDD, tmp_ClinicalEncounters.Height, tmp_ClinicalEncounters.Weight, tmp_ClinicalEncounters.BP, tmp_ClinicalEncounters.OI, 
	tmp_ClinicalEncounters.OIDate, tmp_ClinicalEncounters.Adherence, tmp_ClinicalEncounters.AdherenceCategory, NULL AS SubstitutionFirstlineRegimenDate, NULL AS SubstitutionFirstlineRegimenReason, NULL 
	AS SubstitutionSecondlineRegimenDate, NULL AS SubstitutionSecondlineRegimenReason, NULL AS SecondlineRegimenChangeDate, NULL AS SecondlineRegimenChangeReason, 
	tmp_ClinicalEncounters.FamilyPlanningMethod, tmp_ClinicalEncounters.PwP, tmp_ClinicalEncounters.GestationAge, tmp_ClinicalEncounters.NextAppointmentDate, CAST(GETDATE() AS DATE) 
	AS DateExtracted
FROM            
	tmp_ClinicalEncounters INNER JOIN
	tmp_PatientMaster ON tmp_PatientMaster.PatientPK = tmp_ClinicalEncounters.PatientPK', 0,'PatientVisit',7.00 ),


('3B742EB0-5856-E811-8E16-9CB6D0DA773C','PSmartStage','Smart Card','PSMART',(SELECT Id FROM emrsystem WHERE Name = 'KenyaEMR'),
'select [Id],[shr],[date_created],[status],[status_date],[uuid] FROM [psmart_store] WHERE UPPER(Status) = ''PENDING''',1,'pSmart',1.00),

('3A742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','All Patients','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'KenyaEMR'),
'select d.unique_patient_no as PatientID,
d.patient_id as PatientPK,
(select value_reference from location_attribute
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'') and attribute_type_id=1) as siteCode,
(select name from location
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'')) as FacilityName,
d.gender as Gender,
d.dob as DOB,
min(hiv.visit_date) as RegistrationDate,
min(hiv.visit_date) as RegistrationAtCCC,
min(mch.visit_date) as RegistrationATPMTCT,
min(tb.visit_date) as RegistrationAtTBClinic,
case  max(hiv.entry_point) 
when 160542 then ''OPD'' 
when 160563 then ''Other''
when 160539 then ''VCT''
when 160538 then ''PMTCT''
when 160541 then ''TB''
when 160536 then ''IPD - Adult''
else cn.name
end as PatientSource,(select state_province from location
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'')) as Region,
(select county_district from location
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation''))as District,
(select address6 from location
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'')) as Village,
d.next_of_kin as ContactRelation,
max(hiv.visit_date) as LastVisit,
d.marital_status as MaritalStatus,
d.education_level as EducationLevel,
min(hiv.date_confirmed_hiv_positive) as DateConfirmedHIVPositive,
max(hiv.arv_status) as PreviousARTExposure,
'''' as PreviousARTStartDate,
''KenyaEMR'' as Emr,
''Kenya HMIS II'' as Project, 
CAST(now() as Date) AS DateExtracted
from kenyaemr_etl.etl_patient_demographics d
left outer join kenyaemr_etl.etl_hiv_enrollment hiv on hiv.patient_id=d.patient_id
left outer join kenyaemr_etl.etl_mch_enrollment mch on mch.patient_id=d.patient_id
left outer join kenyaemr_etl.etl_tb_enrollment tb on tb.patient_id=d.patient_id
left outer join concept_name cn on cn.concept_id=hiv.entry_point  and cn.concept_name_type=''FULLY_SPECIFIED''
and cn.locale=''en''
where unique_patient_no is not null
group by d.patient_id
order by d.patient_id;',1,'Patient',1.00), 


('39742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','ART Patients','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'KenyaEMR'),
'select d.unique_patient_no as PatientID,
d.patient_id as PatientPK,
timestampdiff(year,d.DOB, hiv.visit_date) as AgeEnrollment,
timestampdiff(year,d.DOB, reg.art_start_date) as AgeARTStart,
timestampdiff(year,d.DOB, reg.latest_vis_date) as AgeLastVisit,
(select value_reference from location_attribute
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'') and attribute_type_id=1) as siteCode,
(select name from location
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'')) as FacilityName,
min(hiv.visit_date) as RegistrationDate,
case  max(hiv.entry_point) 
when 160542 then ''OPD'' 
when 160563 then ''Other''
when 160539 then ''VCT''
when 160538 then ''PMTCT''
when 160541 then ''TB''
when 160536 then ''IPD - Adult''
else cn.name
end as PatientSource,
reg.art_start_date as StartARTDate,
'''' as PreviousARTStartDate,
'''' as PreviousARTRegimen,
'''' as StartARTAtThisFacility,
reg.regimen as StartRegimen,
reg.regimen_line as StartRegimenLine,
reg.last_art_date as LastARTDate,
reg.last_regimen as LastRegimen,
reg.last_regimen_line as LastRegimenLine,
reg.latest_tca as ExpectedReturn,
reg.latest_vis_date as LastVisit,
timestampdiff(month,reg.art_start_date, reg.latest_vis_date) as duration,
disc.visit_date as ExitDate,
case
when disc.discontinuation_reason is not null then dis_rsn.name
else '''' end as ExitReason, 
''KenyaEMR'' as Emr,
''Kenya HMIS II'' as Project, 
CAST(now() as Date) AS DateExtracted
from kenyaemr_etl.etl_hiv_enrollment hiv 
join kenyaemr_etl.etl_patient_demographics d on d.patient_id=hiv.patient_id
left outer join  kenyaemr_etl.etl_patient_program_discontinuation disc on disc.patient_id=hiv.patient_id
left outer join (select e.patient_id,
if(enr.date_started_art_at_transferring_facility is not null,enr.date_started_art_at_transferring_facility,
e.date_started)as art_start_date, e.date_started, e.gender,e.dob,d.visit_date as dis_date, if(d.visit_date is not null, 1, 0) as TOut,
e.regimen, e.regimen_line, e.alternative_regimen, max(fup.next_appointment_date) as latest_tca,
last_art_date,last_regimen,last_regimen_line,
if(enr.transfer_in_date is not null, 1, 0) as TIn, max(fup.visit_date) as latest_vis_date
from (select e.patient_id,p.dob,p.Gender,min(e.date_started) as date_started,
max(e.date_started) as last_art_date,
mid(min(concat(e.date_started,e.regimen_name)),11) as regimen,
mid(min(concat(e.date_started,e.regimen_line)),11) as regimen_line, 
mid(max(concat(e.date_started,e.regimen_name)),11) as last_regimen,
mid(max(concat(e.date_started,e.regimen_line)),11) as last_regimen_line,
max(if(discontinued,1,0))as alternative_regimen
from kenyaemr_etl.etl_drug_event e
join kenyaemr_etl.etl_patient_demographics p on p.patient_id=e.patient_id
group by e.patient_id) e
left outer join kenyaemr_etl.etl_patient_program_discontinuation d on d.patient_id=e.patient_id
left outer join kenyaemr_etl.etl_hiv_enrollment enr on enr.patient_id=e.patient_id
left outer join kenyaemr_etl.etl_patient_hiv_followup fup on fup.patient_id=e.patient_id
group by e.patient_id)reg on reg.patient_id=hiv.patient_id
left outer join concept_name dis_rsn on dis_rsn.concept_id=disc.discontinuation_reason  and dis_rsn.concept_name_type=''FULLY_SPECIFIED''
and dis_rsn.locale=''en''
left outer join concept_name cn on cn.concept_id=hiv.entry_point  and cn.concept_name_type=''FULLY_SPECIFIED''
and cn.locale=''en''
where d.unique_patient_no is not null
group by d.patient_id;',0,'PatientArt',2.00),


('3C742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Baselines','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'KenyaEMR'),
'select d.unique_patient_no as PatientID,
d.patient_id as PatientPK,
(select value_reference from location_attribute
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'') and attribute_type_id=1) as facilityId,
(select value_reference from location_attribute
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'') and attribute_type_id=1) as siteCode,
 mid(max(if(l.visit_date<=p_dates.enrollment_date,concat(l.visit_date,test_result),null)),11) as eCd4,
 left(max(if(l.visit_date<=p_dates.enrollment_date,concat(l.visit_date,test_result),null)),10) as eCd4Date,
 if(fup.visit_date<=p_dates.enrollment_date,
 case who_stage
	when 1220 then ''WHO I''
	when 1221 then ''WHO II''
    when 1222 then ''WHO III''
    when 1223 then ''WHO IV''
    when 1204 then ''WHO I''
    when 1205 then ''WHO II''
    when 1206 then ''WHO III''
    when 1207 then ''WHO IV''
 end,null) as ewhostage,
 if(fup.visit_date<=p_dates.enrollment_date and who_stage is not null,
fup.visit_date,null) as ewhodate,
'''' as bCD4,
'''' as bCD4Date,
'''' as bWHO,
'''' as bWHODate,
 mid(max(concat(fup.visit_date,case who_stage
	when 1220 then ''WHO I''
	when 1221 then ''WHO II''
    when 1222 then ''WHO III''
    when 1223 then ''WHO IV''
    when 1204 then ''WHO I''
    when 1205 then ''WHO II''
    when 1206 then ''WHO III''
    when 1207 then ''WHO IV''
 end)),11) as lastwho,
 left(max(concat(fup.visit_date,case who_stage
	when 1220 then ''WHO I''
	when 1221 then ''WHO II''
    when 1222 then ''WHO III''
    when 1223 then ''WHO IV''
    when 1204 then ''WHO I''
    when 1205 then ''WHO II''
    when 1206 then ''WHO III''
    when 1207 then ''WHO IV''
 end)),10) as lastwhodate,
  mid(max(concat(l.visit_date,l.test_result)),11) as lastcd4,
 left(max(concat(l.visit_date,l.test_result)),10) as lastcd4date,
 mid(max(if(l.visit_date>p_dates.six_month_date and l.visit_date<p_dates.twelve_month_date ,concat(l.visit_date,test_result),null)),11) as m6Cd4,
 left(max(if(l.visit_date>=p_dates.six_month_date and l.visit_date<p_dates.twelve_month_date ,concat(l.visit_date,test_result),null)),10) as m6Cd4Date,
 mid(max(if(l.visit_date>=p_dates.twelve_month_date,concat(l.visit_date,test_result),null)),11) as m6Cd4,
 left(max(if(l.visit_date>p_dates.twelve_month_date,concat(l.visit_date,test_result),null)),10) as m6Cd4Date,'''' as eWAB,'''' as eWABDate,'''' as bWAB,'''' as bWABDAte
 ''KenyaEMR'' as Emr,
 ''Kenya HMIS II'' as Project, 
CAST(now() as Date) AS DateExtracted
from kenyaemr_etl.etl_patient_hiv_followup fup
join kenyaemr_etl.etl_patient_demographics d on d.patient_id=fup.patient_id
join (select e.patient_id,date_add(date_add(min(e.visit_date),interval 3 month), interval 1 day) as enrollment_date,
date_add(date_add(min(e.visit_date), interval 6 month),interval 1 day) as six_month_date,
date_add(date_add(min(e.visit_date), interval 12 month),interval 1 day) as twelve_month_date
from kenyaemr_etl.etl_hiv_enrollment e
group by e.patient_id) p_dates on p_dates.patient_id=fup.patient_id
left outer join kenyaemr_etl.etl_laboratory_extract l on l.patient_id=fup.patient_id and l.lab_test in (5497,730)
group by fup.patient_id',0,'PatientBaseline',3.00),


('38742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Status','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'KenyaEMR'),'select d.unique_patient_no as PatientID, d.patient_id as PatientPK,(select value_reference from location_attribute
where location_id in (select property_value from global_property where property=''kenyaemr.defaultLocation'') and attribute_type_id=1) as siteCode, (select name from location where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'')) as FacilityName,
'''' as ExitDescription,
disc.visit_date as ExitDate,
case
when disc.discontinuation_reason is not null then cn.name
else '''' end as ExitReason,
 ''KenyaEMR'' as Emr,
 ''Kenya HMIS II'' as Project, 
CAST(now() as Date) AS DateExtracted
from kenyaemr_etl.etl_patient_program_discontinuation disc
join kenyaemr_etl.etl_patient_demographics d on d.patient_id=disc.patient_id
left outer join concept_name cn on cn.concept_id=disc.discontinuation_reason  and cn.concept_name_type=''FULLY_SPECIFIED''
and cn.locale=''en''
where d.unique_patient_no is not null;',0,'PatientStatus',4.00),


('3D742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Labs','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'KenyaEMR'),
'select d.unique_patient_no as patientID, d.patient_id as patientPK, l.encounter_id as visitID, 
l.visit_date as orderedByDate,l.visit_date as reportedByDate, (select value_reference from location_attribute
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'') and attribute_type_id=1) as facilityID,
(select value_reference from location_attribute
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'') and attribute_type_id=1) as siteCode,
(select name from location
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'')) as facilityName,
cn.name as testName,
case 
when c.datatype_id=2 then cn2.name
else
	l.test_result
end as lab_test_results, '''' as enrollmentTest, 
 ''KenyaEMR'' as Emr,
 ''Kenya HMIS II'' as Project, 
CAST(now() as Date) AS DateExtracted
from kenyaemr_etl.etl_laboratory_extract l
join kenyaemr_etl.etl_patient_demographics d on d.patient_id=l.patient_id
join concept_name cn on cn.concept_id=l.lab_test and cn.concept_name_type=''FULLY_SPECIFIED''
and cn.locale=''en''
join concept c on c.concept_id = l.lab_test
left outer join concept_name cn2 on cn2.concept_id=l.test_result and cn2.concept_name_type=''FULLY_SPECIFIED''
and cn2.locale=''en'';',0,'PatientLab',5.00),



('3F742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Pharmacy','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'KenyaEMR'),
'select d.unique_patient_no as PatientID,
d.patient_id as PatientPK,
(select name from location
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'')) as FacilityName,
(select value_reference from location_attribute
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'') and attribute_type_id=1) as siteCode,
ph.visit_id as VisitID,
if(cn2.name is not null, cn2.name,cn.name) as Drug,
ph.visit_date as DispenseDate,
duration,
fup.next_appointment_date as ExpectedReturn,
 ''KenyaEMR'' as Emr,
 ''Kenya HMIS II'' as Project, 
CAST(now() as Date) AS DateExtracted
from kenyaemr_etl.etl_pharmacy_extract ph
join kenyaemr_etl.etl_patient_demographics d on d.patient_id=ph.patient_id
left outer join concept_name cn on cn.concept_id=ph.drug  and cn.concept_name_type=''FULLY_SPECIFIED''
and cn.locale=''en''
left outer join concept_name cn2 on cn2.concept_id=ph.drug  and cn2.concept_name_type=''SHORT''
and cn.locale=''en''
left outer join kenyaemr_etl.etl_patient_hiv_followup fup on fup.encounter_id=ph.encounter_id
and fup.patient_id=ph.patient_id
where unique_patient_no is not null
order by ph.patient_id,ph.visit_date',0,'PatientPharmacy',6.00),


('40742EB0-5856-E811-8E16-9CB6D0DA773C','dwhStage','Patient Visit','NDWH',(SELECT Id FROM emrsystem WHERE Name = 'KenyaEMR'),
'select d.unique_patient_no as PatientID,
d.patient_id as PatientPK,
(select name from location
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'')) as FacilityName,
(select value_reference from location_attribute
where location_id in (select property_value
from global_property
where property=''kenyaemr.defaultLocation'') and attribute_type_id=1) as siteCode,
fup.visit_id as VisitID,
fup.visit_date as VisitDate,
''Out Patient'' as Service,
fup.visit_scheduled as VisitType,
case fup.who_stage 
	when 1220 then ''WHO I''
	when 1221 then ''WHO II''
	when 1222 then ''WHO III''
	when 1223 then ''WHO IV''
	when 1204 then ''WHO I''
	when 1205 then ''WHO II''
	when 1206 then ''WHO III''
	when 1207 then ''WHO IV''
    else ''''
end as WHOStage,
'''' as WABStage,
case fup.pregnancy_status 
	when 1065 then ''Yes''
	when 1066 then ''No''
end as Pregnant,
fup.last_menstrual_period as LMP,
fup.expected_delivery_date as EDD,
fup.height as Height,
fup.weight as Weight,
concat(fup.systolic_pressure,''/'',fup.diastolic_pressure) as BP,
''ART|CTX'' as AdherenceCategory, 
concat( 
IF(fup.arv_adherence=159405, ''Good'', IF(fup.arv_adherence=159406, ''Fair'', IF(fup.arv_adherence=159407, ''Poor'', ''''))), ''|'', 
IF(fup.ctx_adherence=159405, ''Good'', IF(fup.ctx_adherence=159406, ''Fair'', IF(fup.ctx_adherence=159407, ''Poor'', ''''))) 
) AS Adherence, 
'''' as OI, 
'''' as OIDate, 
case fup.family_planning_status 
when 695 then ''Currently using FP''
when 160652 then ''Not using FP''
when 1360 then ''Wants FP''
else ''''
end as FamilyPlanningMethod,
concat(
case fup.condom_provided 
when 1065 then ''Condoms,''
else ''''
end,
case fup.pwp_disclosure
when 1065 then ''Disclosure|''
else ''''
end,
case fup.pwp_partner_tested
when 1065 then ''Partner Testing|''
else ''''
end,
case fup.screened_for_sti
when 1065 then ''Screened for STI''
else ''''
end )as PWP,
if(fup.last_menstrual_period is not null, timestampdiff(week,fup.last_menstrual_period,fup.visit_date),'''') as GestationAge,
fup.next_appointment_date,
 ''KenyaEMR'' as Emr,
 ''Kenya HMIS II'' as Project, 
CAST(now() as Date) AS DateExtracted
from kenyaemr_etl.etl_patient_demographics d
join kenyaemr_etl.etl_patient_hiv_followup fup on fup.patient_id=d.patient_id
where d.unique_patient_no is not null
order by d.patient_id,fup.visit_date;',0,'PatientVisit',7.00)



	

