/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/


CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    BEGIN TRY
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		-- Loading silver.departments
		PRINT '>> Truncating Table: silver.departments';
		TRUNCATE TABLE silver.departments;
		PRINT '>> Inserting Data Into: silver.departments';
		INSERT INTO silver.departments (
			id,
			department
		)
		SELECT
			id,
			department
		FROM bronze.departments;

		-- Loading silver.hired_employees
		PRINT '>> Truncating Table: silver.hired_employees';
		TRUNCATE TABLE silver.hired_employees;
		PRINT '>> Inserting Data Into: silver.hired_employees';
		INSERT INTO silver.hired_employees (
			id,
			name,
			datetime,
			department_id,
			job_id
		)
		SELECT
			id,
			name,
			CAST (datetime AS DATE) AS datetime,    -- cast 'datetime' to DATE 
			CASE WHEN department_id IS NULL THEN 0
				ELSE department_id
			END AS department_id,                   -- change null values for 0
			CASE WHEN job_id IS NULL THEN 0
				ELSE job_id
			END AS job_id                            -- change null values for 0
		FROM bronze.hired_employees;

		--Loading silver.jobs
		PRINT '>> Truncating Table: silver.jobs';
		TRUNCATE TABLE silver.jobs;
		PRINT '>> Inserting Data Into: silver.jobs';
		INSERT INTO silver.jobs (
			id,
			job
		)
		SELECT
			id,
			job
		FROM bronze.jobs;

	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
