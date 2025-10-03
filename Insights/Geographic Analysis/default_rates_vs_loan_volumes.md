# Default Rate vs Loan Volumes by State

## **Business Context**

Geographic variation in credit performance is a powerful — and often underestimated — driver of portfolio risk. Regional economic conditions, employment patterns, consumer behavior, and regulatory environments can all significantly influence both **loan demand** and **default probability**.

By examining how **default rates** and **loan volumes** vary across states, we can identify where lending strategies are most effective and where portfolio risk is concentrated. This insight enables more precise **geographic risk segmentation**, better resource allocation, and data-driven decision-making for expansion, risk pricing, and loss provisioning.

---

## **Business Question**

Which states combine **low default risk** with **high loan volumes** — and which require closer monitoring due to unfavorable risk–volume dynamics?

---

## **SQL Query**

```sql
-- Which states have the lowest default rates and highest loan volumes?
USE creditrisk;

SELECT 
    UPPER(state) AS state,
    FORMAT(SUM(loan_amnt), 'C') AS loan_amount,
    ROUND(AVG(CAST(loan_status AS FLOAT) * 100), 3) AS default_rate
FROM credit_risk
GROUP BY state
ORDER BY default_rate ASC, loan_amount DESC;
```

---

## **Results**

| **State**  | **Total Loan Volume** | **Default Rate (%)** |
| ---------- | --------------------- | -------------------- |
| WALES      | $34,296,400.00        | 20.873               |
| NEW YORK   | $34,309,900.00        | 20.982               |
| QUEBEC     | $34,352,400.00        | 21.193               |
| ENGLAND    | $35,479,675.00        | 21.812               |
| ONTARIO    | $34,320,025.00        | 21.875               |
| TEXAS      | $34,815,750.00        | 22.228               |
| CALIFORNIA | $34,540,650.00        | 22.343               |
| BC         | $35,279,225.00        | 22.479               |
| SCOTLAND   | $34,982,275.00        | 22.505               |

</br>

![alt text](/Visualizations/Geographic%20Analysis/state_risk_analysis.png)

---

## **Analysis & Insights**

### 🧭 1. No State Currently Hits the “Ideal” Quadrant

* None of the states fall into the **Low Risk / High Volume** category — the “sweet spot” for lending growth.
* This suggests that portfolio risk is **relatively evenly distributed**, and **volume growth has not yet translated into risk efficiency**.

---

### 📍 2. England: The Best Current Trade-off

* **England** emerges as the strongest performer, with **$35.48M in loan volume** and a **default rate of 21.8%** — the **best combination of scale and risk**.
* It represents a **strategic benchmark** for optimizing both volume and credit quality.

---

### 📈 3. Risk–Volume Correlation: Positive but Imperfect

* A moderate **positive correlation (r ≈ 0.61)** between **loan volume** and **default rate** suggests that **higher exposure tends to bring higher risk**.
* However, this also indicates potential inefficiency: **scale is not currently translating into proportionate risk control**.

---

### 🚩 4. Monitoring Hotspots

* States like **BC (22.48%)** and **Scotland (22.50%)** exhibit **both above-average default rates and high volumes**, indicating **risk concentration zones** that warrant enhanced monitoring and stricter underwriting standards.

---

## **Strategic Framework: State-Level Risk–Volume Matrix**

| **Quadrant**                   | **Characteristics**                     | **Example States**  | **Business Action**                   |
| ------------------------------ | --------------------------------------- | ------------------- | ------------------------------------- |
| 🟢 **Low Risk / High Volume**  | Ideal — efficient growth                | *None yet*          | Target state — invest and expand      |
| 🟡 **Low Risk / Low Volume**   | Underexploited opportunity              | Wales, New York, Quebec     | Increase marketing / lending capacity |
| 🟠 **High Risk / High Volume** | Profit potential but concentrated risk  | BC, Scotland, Texas | Tighten underwriting, raise pricing   |
| 🔴 **High Risk / Low Volume**  | Poor performance — unattractive profile | California, Ontario               | Exit or redesign product strategy     |

---

## **Business Recommendations**

1. **Prioritize “Rising Stars” like England and New York:**

   * They show competitive default rates with strong or scalable loan demand.
   * Consider targeted campaigns, pre-approved offers, and optimized pricing here.

2. **Intensify Monitoring in High-Risk States (BC, Scotland, Texas):**

   * Conduct granular portfolio reviews to identify drivers (e.g., borrower mix, economic factors).
   * Apply stricter underwriting thresholds or higher risk premiums.

3. **Invest in Growth in Low-Risk, Low-Volume Regions:**

   * Wales and Quebec show below-average risk but haven’t scaled yet.
   * Potential to **turn them into Tier-1 markets** with focused acquisition strategies.

4. **Integrate Geography into Credit Scoring:**

   * Add a **state-level risk weight** into existing credit models.
   * This improves pricing precision and enhances early warning systems.

---

## **Next Steps**

* [ ] **Drill down** into regional borrower profiles to uncover structural differences in default behavior.
* [ ] Perform **time-series analysis** to check whether state-level risk dynamics are stable or cyclical.
* [ ] Layer geographic data with **credit grade and income** to build a multi-dimensional risk segmentation model.

---

### 📊 Executive Summary

> Default risk varies moderately across states, but no geography yet achieves both **low risk** and **high scale**. England offers the most attractive balance, while several high-volume regions (e.g., BC, Scotland) exhibit above-average risk that requires close oversight. By integrating geographic risk into credit strategy and targeting under-penetrated low-risk markets, the portfolio can be steered toward **more profitable and risk-efficient growth.**
