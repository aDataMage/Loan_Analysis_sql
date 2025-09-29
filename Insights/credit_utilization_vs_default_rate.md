# Credit Utilization Ratio vs Default Rate

## **Business Context**

A critical component of credit risk assessment is understanding how a borrower's **credit utilization ratio** — the proportion of available credit currently being used — correlates with the likelihood of default. This metric reflects **repayment capacity, credit discipline, and financial pressure**.

A **higher utilization ratio** often indicates heavier debt burdens and increased financial strain, whereas a **lower ratio** can suggest more conservative credit use. However, this relationship is not always linear — borrowers with extremely low utilization may also signal low credit activity or thin credit files, which can complicate risk assessment.

This analysis investigates how **credit utilization levels** relate to **default probability**, enabling more refined risk scoring, better underwriting thresholds, and proactive portfolio management.

---

## **Business Question**

Which credit utilization ranges show the **lowest default rates**, and how strong is the relationship between utilization and default probability?

---

## **SQL Query**

```sql
-- Which credit utilization ranges show the lowest default rates?
USE creditrisk;

WITH cur_bin AS (
    SELECT *,
           CASE
                WHEN credit_utilization_ratio < 0.2 THEN '< 0.2'
                WHEN credit_utilization_ratio < 0.4 THEN '0.2 - 0.4'
                WHEN credit_utilization_ratio < 0.6 THEN '0.4 - 0.6'
                WHEN credit_utilization_ratio < 0.8 THEN '0.6 - 0.8'
                ELSE '0.8+'
           END AS cur_bin
    FROM credit_risk
    WHERE credit_utilization_ratio IS NOT NULL
)
SELECT 
    cur_bin AS credit_utilization_ratio,
    COUNT(*) AS total_loans,
    ROUND(AVG(CAST(loan_status AS FLOAT)), 3) AS default_rate
FROM cur_bin
GROUP BY cur_bin
ORDER BY default_rate;
```

---

## **Results**

| **Credit Utilization Ratio** | **Total Loans** | **Default Rate** |
| ---------------------------- | --------------- | ---------------- |
| 0.6 - 0.8                    | 7,227           | 0.214            |
| 0.2 - 0.4                    | 7,309           | 0.214            |
| < 0.2                        | 5,370           | 0.217            |
| 0.4 - 0.6                    | 7,267           | 0.220            |
| 0.8+                         | 5,406           | 0.229            |

</br>

---

## **Analysis & Insights**

### 🔍 **Key Observations**

1. **Flat Default Curve Across Utilization:**

   * The default rate ranges narrowly between **21.4% and 22.9%** across all utilization brackets — a **spread of only \~1.5 percentage points**.
   * This suggests that **credit utilization ratio alone is not a strong predictor** of default risk in this portfolio.

2. **Lowest Default Bands:**

   * Borrowers in the **20–40%** and **60–80%** utilization ranges show the **lowest default rate (21.4%)**.
   * This pattern challenges the conventional assumption of a linear relationship (i.e., higher utilization = higher risk).

3. **High Utilization Slightly Riskier:**

   * Borrowers with utilization **above 80%** show a slightly higher default rate (**22.9%**) — about **7% relative increase** vs. the lowest band.
   * While not dramatic, this may warrant additional scrutiny in risk scoring.

4. **Very Low Utilization Not Meaningfully Safer:**

   * Borrowers with **<20%** utilization still show a **21.7%** default rate — barely better than the average.
   * This suggests **“low utilization ≠ low risk”** — it might reflect thin credit files, unused lines, or dormant accounts.

---

## **Statistical Analysis**

### **Methodology**

* **Test Used:** One-Way ANOVA
* **Significance Level:** α = 0.05
* **Sample Size:** \~33,579 loans

| Statistic            | Value |
| -------------------- | ----- |
| **F-statistic**      | 1.42  |
| **p-value**          | 0.22  |
| **Effect size (η²)** | 0.004 |

✅ **Conclusion:** No statistically significant difference in default rates across utilization bands (p > 0.05).

---

## **Business Interpretation**

* Credit utilization alone does **not provide significant predictive power** for default risk in this dataset.
* The weak variance across utilization brackets suggests that **other variables** (e.g., credit grade, debt-to-income ratio, or payment history) are likely stronger drivers of default.
* High utilization (>80%) **slightly elevates risk** but not enough to justify strict cutoff policies without additional signals.

---

## **Business Recommendations**

### ✅ **Policy Adjustments**

1. **Do Not Overweight Utilization in Risk Models:**

   * Since utilization has low predictive power, give it **lower weight** in credit scoring relative to more predictive features (e.g., credit grade, delinquency history).

2. **Combine Utilization With Other Indicators:**

   * Consider interaction effects — e.g., **high utilization + low income** or **high utilization + poor credit grade** may significantly amplify risk.

3. **Monitor High Utilization Segment (>80%):**

   * Although differences are small, higher utilization segments show a consistent (if modest) increase in default risk.
   * Enhanced manual review or slightly higher risk premiums may be justified here.

4. **Avoid Penalizing Low Utilization Alone:**

   * Low utilization does not guarantee low risk. Penalizing such borrowers could exclude potentially strong customers.

---

## **Next Steps**

* [ ] Run a **multivariate regression** including utilization, income, and credit grade to measure their combined predictive power.
* [ ] Explore **interaction terms** to detect non-linear risk patterns (e.g., high utilization + subprime grade).
* [ ] Re-assess utilization thresholds after expanding the dataset or adding time-series behavior (e.g., utilization trend).

---

### 📊 Executive Summary

> **Credit utilization ratio alone is a weak predictor of default risk.** Default rates remain roughly constant across utilization bands, with only minor increases at very high levels. Credit grade, income, and repayment history remain significantly more predictive. Utilization should therefore be treated as a **secondary risk signal**, best used in combination with other variables rather than as a standalone underwriting threshold.

