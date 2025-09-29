-- How does employment length correlate with default rates across different job types?
Delete From Credit_Risk Where person_emp_length > 100;

WITH emp_categories AS (
    SELECT *,
        CASE
            WHEN person_emp_length < 5 THEN 'Short'
            WHEN person_emp_length < 12 THEN 'Medium'
            WHEN person_emp_length < 20 THEN 'Long'
            ELSE 'Very Long'
        END as employment_length
    FROM Credit_Risk
    Where person_emp_length IS NOT NULL
)
SELECT 
    employment_length,
    employment_type,
    Count(*) as total_loans,
    ROUND(AVG(CAST(loan_status AS FLOAT)), 3) AS default_rate
FROM emp_categories
WHERE employment_length IS NOT NULL
GROUP BY employment_type, employment_length
Order By default_rate Asc