-- Create tables in healthcare database with inital/uncleaned raw data; all tables will start w/ bronze_
-- Ensure PostgreSQL database healthcare is manually created first

-- Bronze Level Tables

DROP TABLE IF EXISTS bronze_admission_type;

-- create table: bronze_admission_type:
CREATE TABLE bronze_admission_type (
	admission_type_id SERIAL PRIMARY KEY,
    admission_type_description VARCHAR(50) 
);

DROP TABLE IF EXISTS bronze_discharge_disposition;

-- create table bronze_discharge_disposition:
CREATE TABLE bronze_discharge_disposition (
	discharge_disposition_id SERIAL PRIMARY KEY,
    discharge_disposition_description VARCHAR(255) 
);

DROP TABLE IF EXISTS bronze_admission_source;

-- create table bronze_admission_source:
CREATE TABLE bronze_admission_source (
	admission_source_id SERIAL PRIMARY KEY,
    admission_source_description VARCHAR(255) 
);

DROP TABLE IF EXISTS bronze_patient;

-- create table bronze_patient:
CREATE TABLE bronze_patient (
	patient_nbr	BIGINT,
	race VARCHAR(50) ,
	gender VARCHAR(50) ,
	age	VARCHAR(20),
	weight VARCHAR(20)
) ;

DROP TABLE IF EXISTS bronze_patient_encounter;

-- create bronze_patient_encounter table:
CREATE TABLE bronze_patient_encounter (
    encounter_id BIGINT,
	patient_nbr	BIGINT,
	admission_type_id INTEGER,
	discharge_disposition_id INTEGER,
	admission_source_id	INTEGER,
	time_in_hospital INTEGER,
	payer_code VARCHAR(15),
	medical_specialty VARCHAR(100),
	num_lab_procedures INTEGER,
	num_procedures INTEGER,
	num_medications	INTEGER,
	number_outpatient INTEGER,
	number_emergency INTEGER,
	number_inpatient INTEGER,
	diag_1 VARCHAR(8),
	diag_2 VARCHAR(8),
	diag_3 VARCHAR(8),
	number_diagnoses INTEGER,
    max_glu_serum VARCHAR(10),
	A1Cresult VARCHAR(10),
	metformin VARCHAR(10),
	repaglinide VARCHAR(10),
	nateglinide VARCHAR(10),
	chlorpropamide VARCHAR(10),
	glimepiride VARCHAR(10),
	acetohexamide VARCHAR(10),
    glipizide VARCHAR(10),
	glyburide VARCHAR(10),
    tolbutamide VARCHAR(10),
	pioglitazone VARCHAR(10),
	rosiglitazone VARCHAR(10),
	acarbose VARCHAR(10),
	miglitol VARCHAR(10),
	troglitazone VARCHAR(10),
	tolazamide VARCHAR(10),
	examide VARCHAR(10),
	citoglipton VARCHAR(10),
	insulin	VARCHAR(10),
    glyburideMetformin VARCHAR(10),
	glipizideMetformin VARCHAR(10),
	glimepiridePioglitazone VARCHAR(10),
	metforminRosiglitazone VARCHAR(10),
	metforminPioglitazone VARCHAR(10),
	change_in_meds	VARCHAR(10),
	diabetesMed	VARCHAR(5),
	readmitted	VARCHAR(5)
);