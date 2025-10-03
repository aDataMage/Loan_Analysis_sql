# Default Rate vs Countries: Market Expansion Promise

## Executive Summary

This country-level analysis evaluates default rates, borrower income, loan volume and a composite `risk_score` distribution to identify international markets with the strongest risk–return profiles. The UK, USA and Canada show very similar performance: default rates ≈ **21.7%–21.9%**, average incomes ≈ **$65–66K**, loan volumes > **$100M**, and ~**59%** of loans classified as low/very-low risk. All three markets are classified as **Moderate Promise** under the current rule set; the UK ranks slightly higher on portfolio quality and should be considered the top near-term expansion target for product scaling and targeted originations.

---

## Business Context

Country-level variation in borrower income, credit quality and default behaviour materially affects portfolio performance. A compact, data-driven view of default rate, borrower quality (risk bins), and market scale (volume & applications) helps prioritize markets for expansion, tighten underwriting where needed, and target product development to the most attractive segments.

---

## Business Question

How do default rates vary by country, and which international markets show the strongest potential for strategic expansion?

---

## SQL Query

```sql
-- How do default rates vary by country, and which international markets show promise?
USE creditrisk;

WITH risk_score AS (
    SELECT 
        client_id,
        (0.35 * loan_grade_score) + 
        (0.25 * debt_to_income_ratio) +
        (0.15 * credit_utilization_ratio) + 
        (0.15 * (1 - (cb_person_cred_hist_length / 25.0))) + 
        (0.10 * CASE
            WHEN (past_delinquencies / 3.0) < 1 THEN (past_delinquencies / 3.0)
            ELSE 1
        END) AS risk_score
    FROM (
        SELECT 
            client_id,
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
        FROM credit_risk
    ) t
),
risk_bin AS (
    SELECT 
        client_id,
        CASE
            WHEN risk_score <= 0.2 THEN 'Very Low'
            WHEN risk_score <= 0.4 THEN 'Low'
            WHEN risk_score <= 0.6 THEN 'Medium'
            WHEN risk_score <= 0.8 THEN 'High'
            ELSE 'Very High'
        END AS risk_bin
    FROM risk_score
)
SELECT 
    UPPER(c.country) AS Country,
    SUM(CASE WHEN r.risk_bin = 'Very Low' THEN 1 ELSE 0 END) AS very_low_risk,
    SUM(CASE WHEN r.risk_bin = 'Low' THEN 1 ELSE 0 END) AS low_risk,
    SUM(CASE WHEN r.risk_bin = 'Medium' THEN 1 ELSE 0 END) AS medium_risk,
    SUM(CASE WHEN r.risk_bin = 'High' THEN 1 ELSE 0 END) AS high_risk,
    SUM(CASE WHEN r.risk_bin = 'Very High' THEN 1 ELSE 0 END) AS very_high_risk,
    COUNT(*) AS total_applications,
    ROUND(AVG(c.person_income), 0) AS avg_income,
    ROUND(AVG(CAST(c.loan_status AS FLOAT)), 3) AS default_rate,
    SUM(c.loan_amnt) AS total_loan_volume,
    ROUND(
        CAST((SUM(CASE WHEN r.risk_bin IN ('Very Low', 'Low') THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS FLOAT),
        1
    ) AS low_risk_percentage,
    CASE 
        WHEN AVG(CAST(c.loan_status AS FLOAT)) < 0.15 
             AND AVG(c.person_income) > 50000 
             AND COUNT(*) > 100 THEN 'High Promise'
        WHEN AVG(CAST(c.loan_status AS FLOAT)) < 0.25 
             AND AVG(c.person_income) > 40000 THEN 'Moderate Promise'
        ELSE 'Low Promise'
    END AS market_potential
FROM Credit_Risk c
INNER JOIN risk_bin r ON r.client_ID = c.client_ID
GROUP BY c.country
ORDER BY default_rate ASC, avg_income DESC;
```

---

## Results

| Country | very_low_risk | low_risk | medium_risk | high_risk | very_high_risk | total_applications | avg_income | default_rate | total_loan_volume | low_risk_percentage | market_potential |
| ------: | ------------: | -------: | ----------: | --------: | -------------: | -----------------: | ---------: | -----------: | ----------------: | ------------------: | ---------------: |
|      UK |            70 |     6460 |        4108 |       305 |              0 |             10,943 |     66,294 |        0.217 |       104,758,350 |                59.7 | Moderate Promise |
|     USA |            62 |     6314 |        4186 |       289 |              1 |             10,852 |     66,040 |        0.219 |       103,666,300 |                58.8 | Moderate Promise |
|  CANADA |            60 |     6280 |        4172 |       271 |              1 |             10,784 |     65,875 |        0.219 |       103,951,650 |                58.8 | Moderate Promise |

---

## Insights & Analysis

1. **Default Rate Stability**

   * Default rates for the three largest markets are tightly clustered between **21.7% and 21.9%**, implying broadly similar credit behaviour across markets.

2. **Portfolio Quality**

   * Approximately **59%** of borrowers in each market fall into the **Very Low / Low** risk bins. High and Very High risk borrowers are negligible (<3%), indicating a portfolio tilted toward acceptable risk profiles.

3. **Market Scale & Depth**

   * Each market has **>10k applications** and loan volumes **> $100M**, confirming they are large, mature markets rather than fringe or noisy samples.

4. **Top Candidate — UK**

   * The UK slightly outperforms peers on default rate and low-risk share while also having the largest loan volume — making it the most attractive near-term target for scaled product rollouts.

5. **USA & Canada — Secondary Targets**

   * Both show comparable credit metrics to the UK and are suitable for increased originations focused on low/medium-risk cohorts.

6. **Model Validation Signal**

   * Because `risk_score` / `risk_bin` and empirical `default_rate` are aligned at a portfolio level (high low-risk share aligns with moderate default rates), the composite risk score appears directionally useful. Still, country-level calibration of score thresholds is advisable.

---

## Next Steps & Recommendations (merged)

### Tactical execution (0–3 months)

1. **Targeted Origination: UK first, then USA & Canada**

   * Prioritize **scaled marketing, pre-approved campaigns and simplified underwriting** for low/very-low risk segments in the UK.
   * Roll out similar, smaller pilots in the USA/Canada focused on cohorts with comparable risk profiles.

2. **Incorporate `risk_score` into automated decisioning**

   * Use the composite `risk_score` as a primary gating metric for automated approvals; require manual review for *High* and *Very High* bins.

3. **Adjust pricing & product mixes**

   * Offer **competitive pricing** (lower rates or fees) for verified low-risk segments to increase share of wallet.
   * Test premium products for higher-income subsegments while keeping tighter terms for medium/high risk.

### Analytical & governance (1–6 months)

1. **Calibrate market scoring and thresholds**

   * Replace absolute income/default cutoffs with **percentile-based** or **z-score** thresholds to avoid geographic bias.
   * Recompute `market_potential` with a numeric **Market Attractiveness Score** (risk, income, low-risk %) for continuous ranking.

2. **Cohort & vintage analysis**

   * Run vintage analysis (origination quarter cohorts) per country to validate whether default rates are stable or shifting, and to detect early warning signs.

3. **Refine model & feature importance**

   * Conduct a multivariate model (logistic regression / tree-based) to quantify marginal predictive power of `loan_grade`, `person_income`, `debt_to_income_ratio` and `credit_utilization_ratio` by country — adapt feature weights if needed.

4. **Monitor actionable KPIs**

   * Set and monitor KPIs: approval rate by risk bin, default rate by vintage and country, loss given default (LGD) and risk-adjusted return on capital (RAROC) by country.

### Strategic (6–12 months)

1. **Product and channel optimization**

   * Design country-specific product bundles and channel strategies (digital vs. branch) driven by the most responsive low-risk segments.

2. **Regulatory & operational readiness**

   * Ensure compliance readiness (data privacy, local lending rules) before any large-scale expansion.

3. **A/B test market-level interventions**

    * Run controlled experiments on pricing, underwriting thresholds, and customer acquisition to measure lift and inform full-scale rollouts.

---

## Visualization suggestions (for dashboard / presentation)

* **Market Attractiveness Score**: bar chart ranking countries by the composite score (risk ↓, income ↑, low-risk % ↑).
* **Default Rate vs Avg Income scatter**: bubble size = total_loan_volume; bubble color = low_risk_percentage.
* **Risk bin distribution**: stacked bar for each country (Very Low → Very High).
