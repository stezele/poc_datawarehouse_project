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
			CASE WHEN name IS NULL THEN 'n/a'
				ELSE name
			END,
			CAST (datetime AS DATE) AS datetime,    -- cast 'datetime' to DATE 
			CASE WHEN department_id IS NULL THEN 0
				ELSE department_id
			END AS department_id,                   -- change null values for 0
			CASE WHEN job_id IS NULL THEN 0
				ELSE job_id
			END AS job_id                            -- change null values for 0
		FROM bronze.hired_employees;

    -- Step 1: Calculate the average of the dates
    WITH DateValues AS (
        SELECT DATEDIFF(DAY, '2021-02-01', CAST(datetime AS DATE)) AS DateValue
        FROM silver.hired_employees
        WHERE datetime IS NOT NULL
    ),
    AverageDateValue AS (
        SELECT AVG(DateValue) AS AvgDateValue
        FROM DateValues
    )

    -- Step 2: Update NULL dates using the calculated average
    UPDATE silver.hired_employees
    SET datetime = CASE 
                    WHEN datetime IS NULL 
                    THEN CAST(DATEADD(DAY, (SELECT AvgDateValue FROM AverageDateValue), '2021-02-01') AS DATE)
                    ELSE CAST(datetime AS DATE)
                END;

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
