/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/


GO
CREATE SCHEMA bronze;
GO

IF OBJECT_ID ('bronze.hired_employees', 'U') IS NOT NULL
	DROP TABLE bronze.hired_employees;
GO

CREATE TABLE bronze.hired_employees (
	id				INT,
	name			NVARCHAR(50),
	datetime		NVARCHAR(50),
	department_id   INT,
	job_id          INT
);
GO


IF OBJECT_ID ('bronze.departments', 'U') IS NOT NULL
	DROP TABLE bronze.departments;

GO
CREATE TABLE bronze.departments (
	id		    INT,
	department	NVARCHAR(50)
);
GO


IF OBJECT_ID ('bronze.jobs', 'U') IS NOT NULL
	DROP TABLE bronze.jobs;

GO
CREATE TABLE bronze.jobs (
	id		INT,
	job 	NVARCHAR(50)
);
GO
