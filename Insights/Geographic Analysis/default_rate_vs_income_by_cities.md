# City-Level Risk & Income Analysis: Identifying Expansion Opportunities"

## **Business Context**

City-level differences in income and repayment behaviour significantly influence credit performance. Understanding how default rates vary with income across cities helps identify high-potential markets for expansion and areas requiring stricter risk controls. This insight supports smarter resource allocation, targeted growth strategies, and more precise credit decisioning.

---

## **Business Question**

What cities represent the best expansion opportunities based on income levels and default rates?

---

## **SQL Query**

```sql
-- Which states have the lowest default rates and highest loan volumes?
-- What cities represent the best expansion opportunities based on income levels and default rates?
use CreditRisk;

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
                 FROM   credit_risk)
     t),
     risk_bin
     AS (SELECT *,
                CASE
                  WHEN risk_score <= 0.2 THEN 'Very Low'
                  WHEN risk_score <= 0.4 THEN 'Low'
                  WHEN risk_score <= 0.6 THEN 'Medium'
                  WHEN risk_score <= 0.8 THEN 'High'
                  ELSE 'Very High'
                END AS risk_bin
         FROM   risk_score)

SELECT 
    c.city,
    COUNT(*) AS total_applications,
    Format(ROUND(AVG(c.person_income), 0), 'C') AS avg_income,
    ROUND(AVG(CAST(c.loan_status AS FLOAT)), 3) AS default_rate,
    ROUND(AVG(r.risk_score), 3) AS avg_risk_score,
    Format(SUM(c.loan_amnt), 'C') AS loan_amount
FROM Credit_Risk AS c
INNER JOIN risk_score AS r ON r.client_ID = c.client_ID
WHERE c.city IS NOT NULL
GROUP BY c.city
HAVING COUNT(*) >= 50
ORDER BY default_rate ASC, avg_income DESC;
```

---

## **Results**

| **city**  | **total_applications** | **avg_income** | **default_rate**| **avg_risk_score**| **loan_amount**
| ---------- | --------------------- | -------------------- |---------|-------|--------
|Swansea| 1810| $65,307.00| 0.204| 0.388| $16,886,800.00
|Quebec City| 1754| $65,909.00 |0.205| 0.389| $16,749,975.00
|Buffalo| 1796| $65,876.00| 0.205 |0.386| $17,344,825.00
|Victoria| 1852| $64,440.00| 0.208| 0.391| $17,782,675.00
|Houston| 1811| $69,028.00 |0.209| 0.388| $17,663,450.00
|London| 1851| $67,033.00| 0.211| 0.385| $17,720,125.00
|Cardiff| 1831| $66,732.00 |0.213| 0.389| $17,409,600.00
|New York City| 1769 |$67,941.00| 0.214| 0.388| $16,965,075.00
|Glasgow| 1841| $65,621.00| 0.216 |0.386| $17,340,075.00
|Ottawa| 1802| $66,259.00| 0.218 |0.393| $17,325,050.00
|San Francisco| 1841| $64,364.00 |0.218 |0.39| $17,189,600.00
|Montreal| 1799| $67,065.00| 0.219| 0.388| $17,602,425.00
|Toronto| 1750 |$66,023.00| 0.219 |0.392| $16,994,975.00
|Manchester| 1803| $66,670.00| 0.225| 0.392| $17,759,550.00
|Los Angeles |1838 |$64,137.00 |0.229| 0.395| $17,351,050.00
|Edinburgh| 1807| $66,392.00 |0.235| 0.393| $17,642,200.00
|Dallas| 1797| $64,984.00 |0.236| 0.39| $17,152,300.00
|Vancouver |1827 |$65,603.00 |0.242 |0.391| $17,496,550.00

</br>

![alt text](/Visualizations/Geographic%20Analysis/city_risk_analysis.png)

---

## **Analysis & Insights**

* London and Victoria stand out as top expansion targets — both exhibit below-portfolio default rates (~21%) and competitive income levels ($64–67k), suggesting strong borrower repayment capacity.

* Houston and New York City show exceptionally high income but slightly higher default, implying they could support premium product tiers with stricter underwriting.

* Manchester and Edinburgh combine above-average default rates with strong demand, indicating risk concentration zones where portfolio diversification or credit tightening is warranted.

* Several mid-tier cities (e.g., Swansea, Quebec City) exhibit low risk but moderate scale, representing potential “build” markets if supported by marketing and tailored products.

---

## **Business Recommendations**

1. Double Down on Rising Stars (London, Victoria, Swansea):
    * Expand presence with targeted acquisition campaigns.

    * Explore product differentiation for high-income, low-risk borrowers.

2. Premiumize High-Income / Mid-Risk Markets (Houston, NYC):

    * Maintain exposure but apply higher credit score cutoffs or dynamic pricing.

3. Mitigate Risk in High-Volume Hotspots (Manchester, Edinburgh):

    * Conduct loan vintage analysis to identify structural risk drivers.

    * Consider portfolio rebalancing or enhanced monitoring.

4. Unlock Growth in Underpenetrated Safe Zones (Quebec City, Swansea):

    * Test lower-margin, high-turnover products to build scale.

---

### 📊 Executive Summary

> City-level credit performance reveals nuanced growth opportunities. High-income, low-default cities like London and Victoria represent the strongest expansion prospects, combining repayment resilience with scalable demand. Markets like Houston and New York City show income-driven potential but require careful risk-based pricing. Meanwhile, Manchester and Edinburgh highlight zones of concentrated risk where underwriting discipline is crucial. By aligning product strategy, pricing, and risk appetite with these geographic patterns, the portfolio can achieve more profitable growth with controlled default exposure.
