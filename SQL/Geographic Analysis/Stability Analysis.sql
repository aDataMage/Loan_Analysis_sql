-- Which geographic regions have the most stable lending performance over different loan terms?
USE CreditRisk;

SELECT 
    state,
    COUNT(DISTINCT loan_term_months) AS num_terms,
    ROUND(AVG(default_rate), 3) AS avg_default_rate,
    ROUND(STDEV(default_rate), 3) AS default_volatility,
    ROUND(STDEV(default_rate) / NULLIF(AVG(default_rate), 0), 3) AS stability_score,
    ROUND(MAX(default_rate) - MIN(default_rate), 3) AS default_range
FROM (
    SELECT 
        state,
        loan_term_months,
        ROUND(AVG(CAST(loan_status AS FLOAT)), 3) AS default_rate
    FROM Credit_Risk
    WHERE state IS NOT NULL 
        AND loan_term_months IS NOT NULL
    GROUP BY state, loan_term_months
) AS t
GROUP BY state
HAVING COUNT(DISTINCT loan_term_months) >= 2  -- Need at least 2 terms to measure stability
ORDER BY stability_score ASC;