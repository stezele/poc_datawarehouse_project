/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
===============================================================================
*/

GO
CREATE SCHEMA silver;
GO

IF OBJECT_ID ('silver.hired_employees', 'U') IS NOT NULL
	DROP TABLE silver.hired_employees;
CREATE TABLE silver.hired_employees (
	id				INT,
	name			NVARCHAR(50),
	datetime		NVARCHAR(50),
	department_id   INT,
	job_id          INT,
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);



IF OBJECT_ID ('silver.departments', 'U') IS NOT NULL
	DROP TABLE silver.departments;
CREATE TABLE silver.departments (
	id		    INT,
	department	NVARCHAR(50),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);



IF OBJECT_ID ('silver.jobs', 'U') IS NOT NULL
	DROP TABLE silver.jobs;
CREATE TABLE silver.jobs (
	id		INT,
	job 	NVARCHAR(50),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);

