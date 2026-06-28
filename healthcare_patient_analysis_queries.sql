-- Business Questions
-------------------------------------------------

-- 1. What is the breakdown of patient encounters per admission_type?
SELECT adt.admission_type_id
		,admission_type_description
		, COUNT(patient_nbr) AS number_of_patients
FROM patient_encounter pe
	INNER JOIN admission_type adt
		ON pe.admission_type_id = adt.admission_type_id
GROUP BY adt.admission_type_id
	,admission_type_description
ORDER BY number_of_patients DESC; -- 8 rows

-- 2. Admission Source? (Where) - identifies the location or 
--    context of the patient immediately prior to being admitted to the facility
--    Break down admission source per patient encounter?
SELECT ads.admission_source_id
	,admission_source_description
    , COUNT(patient_nbr) AS number_of_patients
FROM patient_encounter pe
INNER JOIN admission_source ads
	ON pe.admission_source_id = ads.admission_source_id
GROUP BY ads.admission_source_id
	,admission_source_description
ORDER BY COUNT(patient_nbr) DESC
LIMIT 10;

--------------------------------------------------------------
-- Discharge disposition is the final destination or setting 
-- a patient goes to upon leaving a healthcare facility, 
-- determining their next level of care. It defines whether 
-- the patient is going home (with or without support), 
-- transferring to another facility (like nursing or rehab), 
-- or leaving against medical advice
---------------------------------------------------------------
-- 3. What is the breakdown of patient encounters per discharge dispositions?
SELECT dd.discharge_disposition_id
		, discharge_disposition_description
		, COUNT(patient_nbr) AS number_of_patients
FROM patient_encounter pe
	INNER JOIN discharge_disposition dd
		ON pe.discharge_disposition_id = dd.discharge_disposition_id
GROUP BY dd.discharge_disposition_id
	, discharge_disposition_description
ORDER BY number_of_patients DESC; -- 26 rows

-- 4. Breakdown by diagnosis (primary)
WITH patient_primary_diagnosis_cte AS (
SELECT pe.patient_nbr
    ,diag_1
	,icd9_1.icd9_description
FROM patient_encounter pe
INNER JOIN icd9 icd9_1
	ON TO_NUMBER(pe.diag_1, 'L999.99') BETWEEN icd9_1.code_start_int AND icd9_1.code_end_int
		OR pe.diag_1 BETWEEN icd9_1.code_start_str AND icd9_1.code_end_str
)
SELECT diag_1
	, icd9_description
	, COUNT(ppdc.patient_nbr) AS cnt
    , ROW_NUMBER() OVER(ORDER BY COUNT(ppdc.patient_nbr) DESC) AS rnk
FROM patient_primary_diagnosis_cte ppdc
GROUP BY diag_1
	,icd9_description
ORDER BY COUNT(ppdc.patient_nbr) DESC
LIMIT 10; 

-- 6.  Diagnosis 428 is for Heart Failure; check if these patients are 
--	   treated for Diabetes as well (1259 rows)
SELECT *
FROM patient_encounter
WHERE diag_1 = '428'
	AND "diabetesmed" = 'Yes' -- 5358 rows: given diabetic meds during an encounter
    AND (TO_NUMBER(diag_2, 'L999.99') BETWEEN 250 AND 260 OR
		TO_NUMBER(diag_3, 'L999.99') BETWEEN 250 AND 260)
ORDER BY time_in_hospital DESC; -- 1259 rows


-- 7. not given diabetic meds during an encounter
SELECT *
FROM patient_encounter
WHERE diag_1 = '428'
	AND "diabetesmed" = 'No' 
    AND (TO_NUMBER(diag_2, 'L999.99') BETWEEN 250 AND 260 OR
		TO_NUMBER(diag_3, 'L999.99') BETWEEN 250 AND 260)
	ORDER BY time_in_hospital DESC; -- 302 rows: not given diabetic meds during an encounter
    
-- ICD9 Codes
SELECT * 
FROM icd9;

-- 8.  Patients w/ diagnosis 1 (primary diagnosis) as Diabetes
SELECT *
FROM patient_encounter
WHERE TO_NUMBER(diag_1, 'L999.99') BETWEEN 250 AND 260
ORDER BY time_in_hospital DESC; -- 8869 rows

-- 9. not givien diabetic meds on an encounter
SELECT *
FROM patient_encounter
WHERE TO_NUMBER(diag_1, 'L999.99') BETWEEN 250 AND 260
	AND "diabetesmed" = 'No'
ORDER BY time_in_hospital DESC; -- 1343 rows

-- 10. Number of Encounters/Visits per Patient
SELECT patient_nbr
	, num_of_visits
FROM (
SELECT pe.patient_nbr
    , COUNT(pe.encounter_id) AS num_of_visits
    , ROW_NUMBER() OVER(PARTITION BY pe.patient_nbr) AS row_num
FROM patient_encounter pe
INNER JOIN patient p
	ON pe.patient_nbr = p.patient_nbr
GROUP BY pe.patient_nbr
ORDER BY pe.patient_nbr) t
ORDER BY num_of_visits DESC; -- 71,518 rows

-- 11. Patinet Breakdown
SELECT race
	, race_cnt
FROM 
(
SELECT race
    , COUNT(patient_nbr) OVER(PARTITION BY race) AS race_cnt
    , ROW_NUMBER() OVER(PARTITION BY race) AS row_num_race
FROM patient ) t
WHERE row_num_race = 1
ORDER BY race_cnt DESC;

-- 12. Patient encounters/visits that were not readmitted
-- Patient encounters/visits that were readmitted >30 days
-- Patient encounters/visits that were readmitted <30 days
SELECT readmitted
	, CASE WHEN readmitted = 'No' Then SUM(1) Else 0 END AS readmitted_no -- 54,864 rows
	, CASE WHEN readmitted = '>30' Then SUM(1) Else 0 END AS readmitted_greater_30 -- 35,545 rows
	, CASE WHEN readmitted = '<30' Then SUM(1) Else 0 END AS readmitted_lesser_30  -- 11,357 rows
FROM patient_encounter pe
GROUP BY readmitted;