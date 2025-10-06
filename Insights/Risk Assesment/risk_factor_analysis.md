# Risk Factor Analysis

## **Business Context**

Effective credit risk assessment requires identifying which borrower characteristics most reliably predict loan defaults. Traditional models often include numerous factors without clear understanding of their relative importance, leading to complex underwriting processes and suboptimal resource allocation.
This analysis determines which combination of three commonly used risk factors - debt-to-income ratio, previous default history, and credit history length - provides the strongest predictive power. The findings will inform risk scoring model updates, streamline underwriting guidelines, and optimize staff focus on the most impactful risk indicators.

## **Question**

Which combination of factors (debt-to-income ratio, previous defaults, credit - history length) creates the highest risk segments?

## **SQL Query**

```sql
USE creditrisk;

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
                 FROM   credit_risk)t),
     risk_bin
     AS (SELECT client_id,
                CASE
                  WHEN risk_score <= 0.2 THEN 'Very Low'
                  WHEN risk_score <= 0.4 THEN 'Low'
                  WHEN risk_score <= 0.6 THEN 'Medium'
                  WHEN risk_score <= 0.8 THEN 'High'
                  ELSE 'Very High'
                END AS risk_bin
         FROM   risk_score)

SELECT 
    CASE
        WHEN debt_to_income_ratio > 0.4 THEN 'High DTI'
        ELSE 'Low DTI'
    END AS dti_level,
    cb_person_default_on_file AS previous_default,
    CASE
        WHEN cb_person_cred_hist_length < 5 THEN 'Short History'
        WHEN cb_person_cred_hist_length < 15 THEN 'Medium History'
        ELSE 'Long History'
    END AS credit_history_level,
    Count(*)                                                 AS segment_size,
    Round(Avg(Cast(loan_status AS FLOAT)), 3)                AS default_rate,
    Round(Avg(debt_to_income_ratio), 3)                      AS avg_dti,
    Round(Avg(Cast(cb_person_cred_hist_length AS FLOAT)), 1) AS avg_credit_years,
    Round(Avg(r.risk_score), 2)                              AS avg_risk_score
FROM credit_risk AS c
    INNER JOIN risk_score AS r
       ON r.client_id = c.client_id
WHERE  debt_to_income_ratio IS NOT NULL
       AND cb_person_default_on_file IS NOT NULL
       AND cb_person_cred_hist_length IS NOT NULL
GROUP  BY 
    CASE
        WHEN debt_to_income_ratio > 0.4 THEN 'High DTI'
        ELSE 'Low DTI'
    END,
    cb_person_default_on_file,
    CASE
        WHEN cb_person_cred_hist_length < 5 THEN 'Short History'
        WHEN cb_person_cred_hist_length < 15 THEN 'Medium History'
        ELSE 'Long History'
    END
ORDER  BY avg_risk_score DESC; 
```

## **Results**

| DTI Level | Previous Default | Credit History Level | Segment Size | Default Rate | Avg DTI | Avg Credit Years | Avg Risk Score 
|-----------|------------------|-----------------------|---------------|---------------|----------|------------------|-----------------
| High DTI  | 1                | Short History        | 1066          | 0.551         | 0.502    | 3                | 0.53            
| High DTI  | 1                | Medium History       | 733           | 0.514         | 0.502    | 8.1              | 0.50            
| Low DTI   | 1                | Short History        | 2029          | 0.303         | 0.282    | 3                | 0.47            
| High DTI  | 1                | Long History         | 95            | 0.611         | 0.521    | 17.5             | 0.46            
| High DTI  | 0                | Short History        | 4596          | 0.365         | 0.499    | 3                | 0.44            
| Low DTI   | 1                | Medium History       | 1639          | 0.297         | 0.279    | 8.3              | 0.44            
| High DTI  | 0                | Medium History       | 3136          | 0.335         | 0.497    | 8.2              | 0.40            
| Low DTI   | 1                | Long History         | 183           | 0.273         | 0.272    | 17.3             | 0.37            
| Low DTI   | 0                | Short History        | 10142         | 0.116         | 0.278    | 3                | 0.37            
| High DTI  | 0                | Long History         | 359           | 0.362         | 0.499    | 17.2             | 0.35            
| Low DTI   | 0                | Medium History       | 7661          | 0.104         | 0.275    | 8.2              | 0.34            
| Low DTI   | 0                | Long History         | 942           | 0.111         | 0.275    | 17.5             | 0.28            

</br>

![alt text](/Visualizations/Risk%20Assesment/risk_factor_analysis.png)

## **Statistical Analysis**

**Purpose:** Validate whether actual default patterns align with predetermined risk model weights
**Method:** Three-way ANOVA comparing factor importance in predicting observed defaults

### **Key Statistical Findings:**

| Factor | Sum of Squares | F-statistic | P-value | Effect Size Rank |
|--------|----------------|-------------|---------|------------------|
| **DTI Level** | 1960.96 | 259.82 | 0.004 | **#1 (Largest)** |
| **Previous Defaults** | 1113.61 | 147.55 | 0.007 | **#2** |
| **Credit History Length** | 15.97 | 1.06 | 0.486 | #3 (Not significant) |

- No interaction was found to be significant
- DTI explains 76% more variance than previous defaults (1960.96 vs 1113.61 sum of squares)
- Previous defaults still explains significant variance but much less than DTI
- Credit history length explains minimal variance (15.97) and isn't statistically significant

## **Business Recommendations**

- Place more emphasis on Debt to Income Ratio and less on a person Credit History
- Lower entry for people with no previous default and Low DTI

## **Next Steps**

- [ ] Validate findings with additional data collection
- [ ] Update Importance in Predictive Modelling