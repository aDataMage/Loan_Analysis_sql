-- Which geographic regions have the most stable lending performance over different loan terms?
USE CreditRisk;

SELECT 
    state,
    loan_term_months,
    COUNT(client_ID) AS loan_count,
    ROUND(AVG(CAST(loan_status AS FLOAT)), 3) AS default_rate,
    ROUND(STDEV(CAST(loan_status AS FLOAT)), 3) AS default_volatility
FROM Credit_Risk
WHERE state IS NOT NULL 
    AND loan_term_months IS NOT NULL
GROUP BY state, loan_term_months
ORDER BY default_volatility