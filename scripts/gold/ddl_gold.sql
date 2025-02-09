/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_hired_employees
-- =============================================================================
IF OBJECT_ID('gold.dim_hired_employees', 'V') IS NOT NULL
    DROP VIEW gold.dim_hired_employees;
GO

CREATE VIEW gold.dim_hired_employees AS
SELECT
    he.id                AS employee_id,
    he.name              AS employee_name,
    he.datetime          AS hired_date,
    he.department_id,
	CASE WHEN he.department_id = 0 THEN 'n/a'
		ELSE d.department
	END AS department_name,
	he.job_id,
	CASE WHEN he.job_id = 0 THEN 'n/a'
		ELSE j.job
	END AS job_name
FROM silver.hired_employees he
LEFT JOIN silver.departments d
    ON he.department_id = d.id
LEFT JOIN silver.jobs j
    ON he.job_id = j.id;
GO
