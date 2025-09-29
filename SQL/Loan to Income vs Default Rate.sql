-- What's the relationship between loan-to-income ratio and default probability?

WITH LTI_BIN AS
(
	SELECT
		*,
		CASE
			When loan_to_income_ratio < 0.1 Then '< 10%'
			When loan_to_income_ratio < 0.3 Then '10% - 30%'
			When loan_to_income_ratio < 0.5 Then '30% - 50%'
			When loan_to_income_ratio < 0.7 Then '50% - 70%'
			Else '70% >'
		END as lti_bin
	FROM Credit_Risk
)

SELECT 
	lti_bin,
	COUNT(*) AS total_loans,
	ROUND(AVG(CAST(loan_status AS FLOAT)), 3) AS default_rate
FROM LTI_BIN
Group by lti_bin
Order By default_rate DESC