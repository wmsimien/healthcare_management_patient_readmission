-- Ensure the PostgreSQL healthcare database is created.
-- Ensure the silver_ddl file has been exeuted.
-- Insert into tables in healthcare database with data from the silver level tables.
-- Data has been transformed further from the silver level tables.  Tables created from this file
-- will not have any level prefix.

-- Create final tables after all trasformations have been implemented in the silver level.


DROP TABLE IF EXISTS admission_type;

-- create table: admission_type:
CREATE TABLE admission_type (
	admission_type_id SERIAL PRIMARY KEY,
    admission_type_description VARCHAR(50) 
);

DROP TABLE IF EXISTS discharge_disposition;

-- create table discharge_disposition:
CREATE TABLE discharge_disposition (
	discharge_disposition_id SERIAL PRIMARY KEY,
    discharge_disposition_description VARCHAR(255) 
);

DROP TABLE IF EXISTS admission_source;

-- create table admission_source:
CREATE TABLE admission_source (
	admission_source_id SERIAL PRIMARY KEY,
    admission_source_description VARCHAR(255) 
);

DROP TABLE IF EXISTS ICD9;

-- create small ICD9 table
CREATE TABLE ICD9 (
	id SERIAL PRIMARY KEY,
    code_start_str VARCHAR(4),
	code_end_str VARCHAR(4),
    code_start_int INTEGER,
	code_end_int INTEGER,
	icd9_description VARCHAR(255)
);

DROP TABLE IF EXISTS patient;

-- create table patient:
CREATE TABLE patient (
	patient_nbr	BIGINT,
	race VARCHAR(50) ,
	gender VARCHAR(50) ,
	age	VARCHAR(20),
	weight VARCHAR(20)
);

DROP TABLE IF EXISTS patient_encounter;

-- create patient_encounter table:
CREATE TABLE patient_encounter (
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