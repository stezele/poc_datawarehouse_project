
--- Returns the number of employees hired per job and department in 2021, divided by quarter.

SELECT
        department_name,
        job_name,
        SUM(CASE WHEN MONTH(hired_date) BETWEEN 1 AND 3 THEN 1 ELSE 0 END) AS Q1,
        SUM(CASE WHEN MONTH(hired_date) BETWEEN 4 AND 6 THEN 1 ELSE 0 END) AS Q2,
        SUM(CASE WHEN MONTH(hired_date) BETWEEN 7 AND 9 THEN 1 ELSE 0 END) AS Q3,
        SUM(CASE WHEN MONTH(hired_date) BETWEEN 10 AND 12 THEN 1 ELSE 0 END) AS Q4
    FROM gold.dim_hired_employees
    WHERE YEAR(hired_date) = 2021 and department_name != 'n/a'
    GROUP BY department_name, job_name
    ORDER BY department_name, job_name;


--- Returns a list of departments that hired more employees than the average in 2021.

    WITH hires AS(
            SELECT department_id, 
            department_name, 
            COUNT(employee_id) AS hired
            FROM gold.dim_hired_employees
            WHERE YEAR(hired_date) = 2021 
            GROUP BY department_id, department_name
        ),
        avg_hires AS(
            SELECT AVG(hired * 1.0) as avg_hired FROM hires
        )
        SELECT h.department_id, h.department_name, h.hired
        FROM hires h, avg_hires a
        WHERE h.hired > a.avg_hired
        ORDER BY h.hired DESC
