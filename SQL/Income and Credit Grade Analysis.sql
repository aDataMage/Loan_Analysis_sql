-- What is the default rate by credit grade and how does it vary across income brackets?

use CreditRisk;

With incomeBin As (
     Select
            loan_grade,
            loan_status,
            Case
                When person_income <= 25000 Then '< 25k'
                When person_income <= 50000 Then '25k - 50k'
                When person_income <= 100000 Then '50k - 100k'
                When person_income <= 150000 Then '100k - 150k'
                When person_income <= 200000 Then '150k - 200k'
                Else '200k+'
            End as income_bin
      from Credit_Risk
)

SELECT 
    total.loan_grade,
    total.income_bin,
    total.total_loans,
    defaults.total_default,
    Round((Cast(defaults.total_default as float) / total.total_loans), 2) as default_rate
FROM 
    (
        SELECT 
            loan_grade,
            income_bin,
            COUNT(*) AS total_loans
        FROM incomeBin
        GROUP BY loan_grade, income_bin
    ) AS total
INNER JOIN 
    (
        SELECT 
            loan_grade,
            income_bin,
            COUNT(*) AS total_default
        FROM incomeBin
        WHERE loan_status = 1
        GROUP BY loan_grade, income_bin
    ) AS defaults
ON total.loan_grade = defaults.loan_grade
AND total.income_bin = defaults.income_bin 
Order By default_rate desc 