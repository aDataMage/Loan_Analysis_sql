# Income and Credit Grade vs Default Rate Analysis

## **Business Context**

Credit grade has historically been one of the strongest predictors of default risk, reflecting a borrower’s creditworthiness, repayment history, and financial reliability. Income level, on the other hand, is often assumed to influence repayment capacity — but its predictive strength relative to credit grade is less clear.

This analysis explores how **default probability varies across credit grades and income brackets**, with the aim of identifying where income meaningfully contributes to risk assessment and where credit grade alone is sufficient. The results will guide **risk model optimization, pricing strategies, and underwriting policies**.

---

## **Question**

What is the default rate by credit grade, and how does it vary across income brackets?

---

## **SQL Query**

```sql
USE CreditRisk;

WITH incomeBin AS (
    SELECT
        loan_grade,
        loan_status,
        CASE
            WHEN person_income <= 25000 THEN '< 25k'
            WHEN person_income <= 50000 THEN '25k - 50k'
            WHEN person_income <= 100000 THEN '50k - 100k'
            WHEN person_income <= 150000 THEN '100k - 150k'
            WHEN person_income <= 200000 THEN '150k - 200k'
            ELSE '200k+'
        END AS income_bin
    FROM Credit_Risk
)

SELECT 
    total.loan_grade,
    total.income_bin,
    total.total_loans,
    defaults.total_default,
    ROUND(CAST(defaults.total_default AS FLOAT) / total.total_loans, 2) AS default_rate
FROM (
    SELECT 
        loan_grade,
        income_bin,
        COUNT(*) AS total_loans
    FROM incomeBin
    GROUP BY loan_grade, income_bin
) AS total
INNER JOIN (
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
ORDER BY default_rate DESC;
```

---

## **Results**

| loan\_grade | income\_bin | total\_loans | total\_defaults | defaults\_rate |
| ----------- | ----------- | ------------ | --------------- | -------------- |
| G           | 150k - 200k | 2            | 2               | 1.00           |
| G           | 100k - 150k | 14           | 14              | 1.00           |
| G           | 200k+       | 1            | 1               | 1.00           |
| G           | < 25k       | 1            | 1               | 1.00           |
| G           | 50k - 100k  | 26           | 26              | 1.00           |
| G           | 25k - 50k   | 20           | 19              | 0.95           |
| E           | < 25k       | 58           | 53              | 0.91           |
| F           | 25k - 50k   | 61           | 52              | 0.85           |
| D           | < 25k       | 299          | 237             | 0.79           |
| E           | 25k - 50k   | 307          | 234             | 0.76           |
| F           | < 25k       | 17           | 12              | 0.71           |
| F           | 50k - 100k  | 117          | 80              | 0.68           |
| D           | 25k - 50k   | 1377         | 929             | 0.67           |
| E           | 50k - 100k  | 442          | 268             | 0.61           |
| F           | 150k - 200k | 7            | 4               | 0.57           |
| E           | 200k+       | 23           | 13              | 0.57           |
| F           | 100k - 150k | 30           | 17              | 0.57           |
| F           | 200k+       | 9            | 5               | 0.56           |
| D           | 50k - 100k  | 1501         | 796             | 0.53           |
| B           | < 25k       | 802          | 383             | 0.48           |
| A           | < 25k       | 730          | 344             | 0.47           |
| C           | < 25k       | 562          | 259             | 0.46           |
| E           | 150k - 200k | 24           | 11              | 0.46           |
| D           | 100k - 150k | 310          | 128             | 0.41           |
| D           | 150k - 200k | 68           | 27              | 0.40           |
| E           | 100k - 150k | 110          | 42              | 0.38           |
| D           | 200k+       | 70           | 23              | 0.33           |
| C           | 25k - 50k   | 2469         | 674             | 0.27           |
| B           | 25k - 50k   | 3711         | 803             | 0.22           |
| A           | 25k - 50k   | 3668         | 503             | 0.14           |
| C           | 50k - 100k  | 2672         | 365             | 0.14           |
| B           | 50k - 100k  | 4554         | 460             | 0.10           |
| C           | 100k - 150k | 535          | 35              | 0.07           |
| B           | 200k+       | 150          | 8               | 0.05           |
| B           | 150k - 200k | 251          | 9               | 0.04           |
| A           | 50k - 100k  | 4979         | 208             | 0.04           |
| B           | 100k - 150k | 983          | 38              | 0.04           |
| C           | 200k+       | 97           | 3               | 0.03           |
| C           | 150k - 200k | 123          | 3               | 0.02           |
| A           | 100k - 150k | 1088         | 15              | 0.01           |
| A           | 150k - 200k | 214          | 2               | 0.01           |
| A           | 200k+       | 97           | 1               | 0.01           |

</br>

![alt text](/Visualizations/Risk%20Assesment/income-and-credit_grade-analysis.png)

---

## **Statistical Analysis**

### **Methodology**

* **Test Used:** One-Way ANOVA + Tukey HSD Post-hoc
* **Significance Level:** α = 0.05
* **Sample Size:** 31,679 loans

---

## **Key Statistical Findings**

### **Grade A vs Other Grades**

| Comparison | Mean Difference | P-value    | Significant? | Risk Increase    |
| ---------- | --------------- | ---------- | ------------ | ---------------- |
| A vs B     | 4.17%           | 0.999      | **No**       | Similar risk     |
| A vs C     | 5.17%           | 0.997      | **No**       | Similar risk     |
| A vs D     | **40.83%**      | **0.001**  | ✅            | Significant jump |
| A vs E     | **50.17%**      | **<0.001** | ✅            | High risk        |
| A vs F     | **54.33%**      | **<0.001** | ✅            | Very high risk   |
| A vs G     | **87.83%**      | **<0.001** | ✅            | Extreme risk     |

---

## **Recommended Risk Tiers**

| Tier       | Grades  | Risk Level   | Business Action                       |
| ---------- | ------- | ------------ | ------------------------------------- |
| **Tier 1** | A, B, C | Low Risk     | Standard pricing, automated approval  |
| **Tier 2** | D       | Medium Risk  | Manual review, moderate premium       |
| **Tier 3** | E, F    | High Risk    | High premium, enhanced due diligence  |
| **Tier 4** | G       | Extreme Risk | Decline or offer specialized products |

---

## **Critical Business Insights**

### 🎯 **Prime Credit (A, B, C)**

* No significant difference between A, B, and C — all perform similarly well.
* These can be **treated as a single low-risk segment** for pricing and automation.

### 📈 **Risk Escalation Point**

* A major risk inflection occurs at **Grade D** — with default rates jumping **40.8% higher** than Grade A.
* This marks a clear **tier boundary** and an underwriting decision point.

### 🚨 **High-Risk Grades (E, F, G)**

* G-rated borrowers default **\~88% more often** than A-rated borrowers.
* Even within high-risk grades, significant variance exists — suggesting the need for differentiated treatment, not a one-size-fits-all policy.

---

## **Statistical Significance: Income vs Default**

* **Loan Grade:**

  * **F-statistic:** 25.91
  * **Overall ANOVA p-value:** 1.64e-11 ✅ (highly significant)
  * **Effect Size:** Grade A reduces default risk by \~87.3 percentage points vs G

* **Income Bracket:**

  * **F-statistic:** 1.12
  * **Overall ANOVA p-value:** 0.37 ❌ (not significant)

📊 **Interpretation:** Income alone does not significantly predict default. However, **within a given grade**, higher income tends to correlate with lower risk — but this effect is secondary to credit grade.

Examples:

* Grade A: 47% default rate at <25k vs **1%** above 100k
* Grade B: 48% at <25k vs **4–5%** above 100k

---

## **Business Recommendations**

### **Immediate Actions**

1. **Prioritize Credit Grade in Risk Models:**

   * Use grade as the dominant predictor of default probability.
   * Weight income as a secondary feature only within-grade.

2. **Revise Underwriting Policy by Risk Tier:**

   * **Tier 1 (A–C):** Streamline approvals, competitive rates.
   * **Tier 2 (D):** Introduce manual review and price premium.
   * **Tier 3–4 (E–G):** Limit exposure, require collateral, or reject.

3. **De-emphasize Income Thresholds:**

   * Income alone is not statistically significant.
   * Avoid rigid income-based eligibility requirements.

---

## **Caution**

* Some income bins (especially in Grade G) have small sample sizes — monitor as data grows.
* Conduct cohort analysis to explore if income plays a stronger predictive role over time.

---

## **Next Steps**

* [ ] Validate findings with additional data and external credit bureau records.
* [ ] Refine risk scoring model to reflect dominant role of credit grade.
* [ ] Investigate intra-grade income effects for potential fine-tuning.
* [ ] A/B test underwriting policies using new risk tiers.