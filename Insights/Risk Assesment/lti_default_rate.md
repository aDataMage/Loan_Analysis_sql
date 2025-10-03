# Loan to Income Ratio by Default Probability Analysis

## **Business Context**

A critical step in credit risk management is understanding how borrower repayment capacity relates to the likelihood of default. Among the many variables used in underwriting, the **loan-to-income (LTI) ratio** is one of the most fundamental — it directly measures how much of a borrower’s income is committed to servicing debt. A higher LTI ratio typically signals greater financial strain, increasing the risk of missed payments or default.

This analysis focuses specifically on exploring the relationship between **loan-to-income ratio and default probability**, providing clear, data-driven insights to support credit policy decisions. The findings will guide the setting of LTI thresholds, refine risk scoring models, and help prioritize underwriting resources toward applicants with higher default risk profiles.

---

## **Question**

What's the relationship between loan-to-income ratio and default probability?

---

## **SQL Query**

```sql
-- What's the relationship between loan-to-income ratio and default probability?
WITH lti_bin
     AS (SELECT *,
                CASE
                  WHEN loan_to_income_ratio < 0.1 THEN '< 10%'
                  WHEN loan_to_income_ratio < 0.3 THEN '10% - 30%'
                  WHEN loan_to_income_ratio < 0.5 THEN '30% - 50%'
                  WHEN loan_to_income_ratio < 0.7 THEN '50% - 70%'
                  ELSE '70% >'
                END AS lti_bin
         FROM   credit_risk)

SELECT lti_bin,
       Count(*)                                  AS total_loans,
       Round(Avg(Cast(loan_status AS FLOAT)), 3) AS default_rate
FROM   lti_bin
GROUP  BY lti_bin
ORDER  BY default_rate DESC 
```

---

## **Results**

| **Loan to Income Bin** | **Number of Loans** | **Default Rate** |
| ---------------------- | ------------------- | ---------------- |
| 70% >                  | 9                   | 0.778            |
| 50% - 70%              | 316                 | 0.763            |
| 30% - 50%              | 3831                | 0.665            |
| 10% - 30%              | 18948               | 0.170            |
| < 10%                  | 9475                | 0.115            |

</br>

### **Insights**

* Borrowers with **LTI ratios above 70%** show the **highest default probability (77.8%)**, though they represent a small portion of the portfolio — interpret with caution due to low sample size.
* Borrowers with **LTI below 10%** show the **lowest default probability (11.5%)**, indicating strong repayment capacity.
* The difference between **< 30%** and **> 30%** is substantial — defaults more than triple beyond the 30% mark.
* **30%** emerges as a meaningful **risk threshold**, above which default risk accelerates sharply.

---

## **Business Recommendations**

* Implement a **30% loan-to-income threshold** as a key underwriting guideline. Borrowers above this level should be subjected to enhanced risk assessment or stricter lending criteria.
* Use loan-to-income segmentation as an early-stage screening tool in credit scoring models to quickly flag high-risk applications.

---

## **Next Steps**

* [ ] Conduct deeper analysis comparing borrower characteristics within the two critical categories: **< 30%** and **> 30%** LTI.
* [ ] Update predictive risk models to assign greater weight to LTI, reflecting its strong predictive relationship with default probability.
