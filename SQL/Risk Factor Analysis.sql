-- Which combination of factors (debt-to-income ratio, previous defaults, credit - history length) creates the highest risk segments?

USE CreditRisk;
With Risk_Score as (
Select 
	client_ID,
	(0.35 * loan_grade_score) + 
	(0.25 * debt_to_income_ratio) + 
	(0.15 * credit_utilization_ratio) + 
	(0.15 * (1 - (cb_person_cred_hist_length/ 25.0))) + 
	(0.10 * CASE 
        WHEN (past_delinquencies / 3.0) < 1 
        THEN (past_delinquencies / 3.0) 
        ELSE 1 
    END) as risk_score
From
	(Select 
		client_ID,
		loan_grade,
		debt_to_income_ratio,
		credit_utilization_ratio,
		cb_person_cred_hist_length,
		past_delinquencies,
		Case
			When loan_grade = 'A' Then 0.1
			When loan_grade = 'B' Then 0.2
			When loan_grade = 'C' Then 0.4
			When loan_grade = 'D' Then 0.6
			When loan_grade = 'E' Then 0.8
			When loan_grade = 'F' Then 0.9
			Else 1
		End as loan_grade_score
	From Credit_Risk
	)t
), Risk_Bin as (
	Select 
	client_ID,
	Case
		When risk_score <= 0.2 Then 'Very Low'
		When risk_score <= 0.4 Then 'Low'
		When risk_score <= 0.6 Then 'Medium'
		When risk_score <= 0.8 Then 'High'
		Else 'Very High'
	End as risk_bin
	from Risk_Score
)

SELECT 
    CASE WHEN debt_to_income_ratio > 0.4 THEN 'High DTI' ELSE 'Low DTI' END AS dti_level,
    cb_person_default_on_file AS previous_default,
    CASE 
        WHEN cb_person_cred_hist_length < 5 THEN 'Short History'
        WHEN cb_person_cred_hist_length < 15 THEN 'Medium History' 
        ELSE 'Long History' 
    END AS credit_history_level,
    COUNT(*) AS segment_size,
    ROUND(AVG(CAST(loan_status AS FLOAT)), 3) AS default_rate,
    ROUND(AVG(debt_to_income_ratio), 3) AS avg_dti,
    ROUND(AVG(CAST(cb_person_cred_hist_length AS FLOAT)), 1) AS avg_credit_years,
	ROUND(AVG(r.risk_score),2) as avg_risk_score
FROM credit_risk as c
Inner Join Risk_Score as r
on r.client_ID = c.client_ID
WHERE debt_to_income_ratio IS NOT NULL 
    AND cb_person_default_on_file IS NOT NULL
    AND cb_person_cred_hist_length IS NOT NULL
GROUP BY 
    CASE WHEN debt_to_income_ratio > 0.4 THEN 'High DTI' ELSE 'Low DTI' END,
    cb_person_default_on_file,
    CASE 
        WHEN cb_person_cred_hist_length < 5 THEN 'Short History'
        WHEN cb_person_cred_hist_length < 15 THEN 'Medium History' 
        ELSE 'Long History' 
    END
ORDER BY avg_risk_score DESC;