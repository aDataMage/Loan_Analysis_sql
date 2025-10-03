-- What cities represent the best expansion opportunities based on income levels and default rates?
use CreditRisk;

WITH risk_score
     AS (SELECT client_id,
                ( 0.35 * loan_grade_score ) + 
                ( 0.25 * debt_to_income_ratio ) +
                ( 0.15 * credit_utilization_ratio ) + 
                ( 0.15 * ( 1 - ( cb_person_cred_hist_length / 25.0 ) ) ) + 
                ( 0.10 * CASE
                         WHEN ( past_delinquencies / 3.0 ) < 1 THEN
                         ( past_delinquencies / 3.0 )
                         ELSE 1
                       END 
                ) AS risk_score
         FROM   (SELECT client_id,
                        loan_grade,
                        debt_to_income_ratio,
                        credit_utilization_ratio,
                        cb_person_cred_hist_length,
                        past_delinquencies,
                        CASE
                          WHEN loan_grade = 'A' THEN 0.1
                          WHEN loan_grade = 'B' THEN 0.2
                          WHEN loan_grade = 'C' THEN 0.4
                          WHEN loan_grade = 'D' THEN 0.6
                          WHEN loan_grade = 'E' THEN 0.8
                          WHEN loan_grade = 'F' THEN 0.9
                          ELSE 1
                        END AS loan_grade_score
                 FROM   credit_risk)
     t),
     risk_bin
     AS (SELECT *,
                CASE
                  WHEN risk_score <= 0.2 THEN 'Very Low'
                  WHEN risk_score <= 0.4 THEN 'Low'
                  WHEN risk_score <= 0.6 THEN 'Medium'
                  WHEN risk_score <= 0.8 THEN 'High'
                  ELSE 'Very High'
                END AS risk_bin
         FROM   risk_score)

SELECT 
    c.city,
    COUNT(*) AS total_applications,
    Format(ROUND(AVG(c.person_income), 0), 'C') AS avg_income,
    ROUND(AVG(CAST(c.loan_status AS FLOAT)), 3) AS default_rate,
    ROUND(AVG(r.risk_score), 3) AS avg_risk_score,
    SUM(c.loan_amnt) AS total_loan_volume
FROM Credit_Risk AS c
INNER JOIN risk_score AS r ON r.client_ID = c.client_ID
WHERE c.city IS NOT NULL
GROUP BY c.city
HAVING COUNT(*) >= 50
ORDER BY default_rate ASC, avg_income DESC;