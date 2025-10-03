-- Which credit utilization ranges show the lowest default rates?
use CreditRisk;

WITH CUR_BIN AS (
	SELECT 
		*,
		CASE
			WHEN credit_utilization_ratio < 0.2 THEN '< 0.2'
			WHEN credit_utilization_ratio < 0.4 THEN '0.2 - 0.4'
			WHEN credit_utilization_ratio < 0.6 THEN '0.4 - 0.6'
			WHEN credit_utilization_ratio < 0.8 THEN '0.6 - 0.8'
			Else '0.8+'
		END AS cur_bin
	FROM Credit_Risk
	WHERE credit_utilization_ratio IS NOT NULL
)


SELECT
	cur_bin AS credit_utilization_ratio,
    COUNT(*) AS total_loans,
	ROUND(AVG(CAST(loan_status AS FLOAT)), 3) AS default_rate
FROM CUR_BIN
Group By cur_bin
Order By default_rate