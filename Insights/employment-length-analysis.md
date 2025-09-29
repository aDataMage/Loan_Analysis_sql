# Employment Length vs Default Rate Analysis

## **Business Context**

Employment tenure is a direct indicator of financial stability and repayment capacity. Borrowers with longer, stable employment histories typically demonstrate stronger income reliability, which can significantly reduce their likelihood of default. However, the nature of this relationship can vary across employment types (e.g., full-time vs. self-employed), potentially influencing how risk is assessed.

This analysis investigates how **employment length correlates with default probability across different job types**. The findings aim to refine credit risk scoring, improve underwriting precision, and support more accurate pricing strategies.

---

## **Question**

How does employment length correlate with default rates across different job types?

---

## **SQL Query**

```sql
DELETE FROM Credit_Risk WHERE person_emp_length > 100;

-- Create Bin for Employment Length
WITH emp_categories AS (
    SELECT *,
        CASE
            WHEN person_emp_length < 5 THEN 'Short'
            WHEN person_emp_length < 12 THEN 'Medium'
            WHEN person_emp_length < 20 THEN 'Long'
            ELSE 'Very Long'
        END AS employment_length
    FROM Credit_Risk
    WHERE person_emp_length IS NOT NULL
)

SELECT 
    employment_length,
    employment_type,
    COUNT(*) AS total_loans,
    ROUND(AVG(CAST(loan_status AS FLOAT)), 3) AS default_rate
FROM emp_categories
WHERE employment_length IS NOT NULL
GROUP BY employment_type, employment_length
ORDER BY default_rate ASC;
```

---

## **Results**

| employment\_length | employment\_type | total\_loans | default\_rate |
| ------------------ | ---------------- | ------------ | ------------- |
| Long               | Full-time        | 1246         | 0.140         |
| Long               | Self-employed    | 302          | 0.146         |
| Very Long          | Unemployed       | 6            | 0.167         |
| Long               | Part-time        | 401          | 0.170         |
| Long               | Unemployed       | 87           | 0.172         |
| Medium             | Part-time        | 2438         | 0.173         |
| Medium             | Full-time        | 7356         | 0.182         |
| Medium             | Self-employed    | 1857         | 0.183         |
| Medium             | Unemployed       | 647          | 0.215         |
| Very Long          | Full-time        | 83           | 0.217         |
| Short              | Unemployed       | 895          | 0.240         |
| Very Long          | Part-time        | 29           | 0.241         |
| Short              | Full-time        | 10248        | 0.243         |
| Short              | Part-time        | 3460         | 0.252         |
| Short              | Self-employed    | 2596         | 0.256         |
| Very Long          | Self-employed    | 33           | 0.333         |

</br>

![alt text](/Visualizations/employment-length-analysis.png)

---

## **Statistical Analysis**

### **Methodology**

* **Test Used:** One-Way ANOVA + Tukey HSD Post-hoc
* **Significance Level:** α = 0.05
* **Sample Size:** 31,679 loans across all employment categories
* **Data Cleaning:** Removed unrealistic values (>100 years employment length)

---

### **Key Statistical Findings**

| Comparison              | Mean Difference | P-value | Significant? | Interpretation                                             |
| ----------------------- | --------------- | ------- | ------------ | ---------------------------------------------------------- |
| **Long vs Medium**      | 3.125%          | 0.643   | **No**       | No significant difference                                  |
| **Long vs Short**       | 9.075%          | 0.021   | **Yes** ✅    | Short employment significantly increases default risk      |
| **Long vs Very Long**   | 8.25%           | 0.037   | **Yes** ✅    | Very Long employment has significantly higher default risk |
| **Medium vs Short**     | 5.95%           | 0.160   | **No**       | No significant difference                                  |
| **Medium vs Very Long** | 5.125%          | 0.258   | **No**       | No significant difference                                  |
| **Short vs Very Long**  | -0.825%         | 0.989   | **No**       | No significant difference                                  |

---

### **Statistical Significance Overview**

**Employment Length:**

* **F-statistic:** 5.40
* **Overall ANOVA p-value:** 0.01 ✅
* **Effect Size:** Long tenure reduces default risk by \~9.08 percentage points vs. short tenure.

**Employment Type:**

* **F-statistic:** 0.32
* **Overall ANOVA p-value:** 0.81 ❌
* Employment type alone does not significantly impact default risk.

---

## **Key Insights**

* **Employment length is a significant predictor of default risk.** Borrowers with **longer tenures (5–20 years)** show substantially lower default rates than those with shorter employment histories.
* **Employment type alone is not a reliable risk indicator**, but when combined with tenure, it can help refine risk assessment.
* **Very long tenure (20+ years)** unexpectedly correlates with **higher risk**, possibly linked to age, retirement, or career transition factors — this warrants deeper investigation.

---

## **Business Recommendations**

### **Immediate Actions**

1. **Integrate Employment Tenure into Risk Scoring:**

   * Long tenure (5–20 yrs): **-0.5 risk points**
   * Short tenure (<5 yrs): **+0.5 risk points**

2. **Adopt Tenure-Based Pricing Strategies:**

   * Long tenure: **0.25% rate reduction**
   * Short tenure: **0.25% rate premium**

3. **Enhance Underwriting Rules:**

   * Automatically **flag borrowers with <5 years** of employment for additional review or income verification.

---

### **Cautionary Notes**

* **Very long tenure risk:** Investigate potential correlations with retirement or reduced earning capacity.
* **Sample size limitations:** Categories with small counts (e.g., “Very Long” + “Unemployed”) should be monitored as the portfolio expands.

---

## **Next Steps**

* [ ] Validate results with additional historical and cross-market data.
* [ ] Integrate employment tenure as a weighted feature in the predictive risk model.
* [ ] Investigate the drivers of increased risk among “Very Long” tenure borrowers.
* [ ] Conduct A/B testing on tenure-based pricing strategies.
* [ ] Monitor ongoing performance for employment type × tenure interactions.