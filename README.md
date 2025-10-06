# Loan Default Analysis: A Data-Driven Approach to Risk Management and Market Strategy

## Executive Summary

This project analyzed over 32,000 loan applications to identify the primary drivers of default, providing actionable intelligence to refine risk assessment models, streamline underwriting processes, and guide strategic market expansion.

Our analysis revealed that **Credit Grade** is the most dominant predictor of default, far outweighing the influence of income. We also identified **Debt-to-Income (DTI) ratio** and **previous defaults** as the two most critical secondary risk factors, while finding that credit history length was not statistically significant. Geographically, the **UK** emerges as the most promising market for expansion, balancing high loan volume with stable, predictable default rates.

Based on these findings, we recommend immediate updates to the credit scoring model, including a **64:36 weighting for DTI versus previous defaults** and the consolidation of Credit Grades A-C into a single low-risk tier. Strategically, we advise prioritizing the UK for growth and developing targeted origination strategies for high-potential cities like London and Victoria. Implementing these data-driven recommendations will enhance portfolio profitability, reduce default rates, and improve underwriting efficiency.

-----

## 1\. Project Introduction

### 1.1. Problem Statement

The goal of this project is to analyze a comprehensive loan application dataset to identify key patterns and factors that correlate with loan defaults. By understanding these drivers, the business can improve its risk assessment framework, make more informed credit approval decisions, and optimize its market strategy for sustainable growth.

### 1.2. Key Objectives

  * **Risk Assessment:** Identify the most predictive demographic and financial factors for loan default.
  * **Geographic Analysis:** Evaluate market performance across different countries, states, and cities to identify opportunities and risks.
  * **Statistical Validation:** Use rigorous statistical methods to validate findings and ensure recommendations are based on significant relationships.
  * **Business Strategy:** Translate analytical insights into actionable recommendations for underwriting policies, risk scoring, and market expansion.

-----

## 2\. Data and Methodology

### 2.1. Dataset Description

The analysis was performed on a dataset of over 32,000 loan application records, containing 28 features that include:

  * **Demographics:** Age, income, education, marital status, location.
  * **Financial Metrics:** Debt-to-income ratio, credit utilization, loan amounts.
  * **Credit History:** Credit grade, previous defaults, credit history length, delinquencies.
  * **Loan Characteristics:** Loan purpose, interest rate, term, and the binary target variable: **loan default status** (0 = Repaid, 1 = Defaulted).

### 2.2. Methodology

The project followed an end-to-end analytical workflow, starting with data cleaning and exploration using advanced SQL queries. Key risk factors and customer segments were analyzed using statistical tests in Python, primarily **Analysis of Variance (ANOVA)** with **Tukey HSD post-hoc tests** to validate the significance of observed differences. The resulting insights were then used to formulate strategic business recommendations.

-----

## 3\. Key Analyses and Findings

### 3.1. Risk Assessment & Credit Analysis

#### Finding 1: Credit Grade is the Dominant Predictor of Default

Credit grade is the single most powerful indicator of risk. Grade G loans have a near-certain default rate (95-100%), while Grades A-C perform similarly with low default rates. Income level has a minimal impact on default probability compared to the applicant's credit grade.

<img alt="alt text" height="500" src="/Visualizations/Risk%20Assesment/income-and-credit_grade-analysis.png" title="Heatmap of Credit Grade vs Income Bracket" width="500"/>

#### Finding 2: DTI and Previous Defaults are the Primary Risk Indicators

A three-way ANOVA revealed that Debt-to-Income (DTI) ratio and a history of previous defaults are the strongest combined predictors of risk. DTI explains 64% of the variance in default rates, while previous defaults explain 36%. In contrast, **credit history length was found to be statistically insignificant** and can be removed from primary risk models.

 <img alt="alt text" height="500" src="/Visualizations/Risk%20Assesment/risk_factor_analysis.png" title="Contingency Table" width="500"/>

#### Finding 3: Stable Employment (5-20 Years) Significantly Lowers Risk

Borrowers with an employment tenure between 5 and 20 years have a **9.1% lower default rate** than those with shorter tenures. The applicant's specific job type did not show a significant correlation with default risk.

 <img alt="alt text" height="500" src="/Visualizations/Risk%20Assesment/employment-length-analysis.png" title="Heatmap of Employment Length vs Type" width="500"/>

#### Finding 4: Loan-to-Income (LTI) Ratio Above 30% is a Critical Threshold

While low LTI ratios (\<10%) correspond to the lowest default rates (11.5%), the risk accelerates sharply once the LTI ratio exceeds 30%. This makes LTI a valuable early-stage screening metric.

#### Finding 5: Credit Utilization is Not a Strong Standalone Predictor

Contrary to common belief, credit utilization ratio alone was not a strong predictor of default in this portfolio. Low utilization does not necessarily indicate low risk, as it may reflect thin or dormant credit files.

### 3.2. Geographic Market Analysis

#### Finding 6: The UK is the Top Market for Balanced Growth

Among the top three markets (UK, USA, Canada), default rates are tightly clustered around 21.8%. However, the UK combines the largest loan volume with a slightly better risk profile, making it the most attractive target for expansion.

#### Finding 7: No "Sweet Spot" States Exist, but England Leads Performance

Analysis of US states and UK countries revealed a moderate positive correlation ($r \approx 0.61$) between loan volume and default rate. No region fell into the ideal "Low Risk / High Volume" category. England was the strongest performer, with $35.48M in loan volume at a 21.8% default rate.

#### Finding 8: London and Victoria are Prime City-Level Expansion Targets

At the city level, **London** and **Victoria** stand out with below-average default rates (\~21%) and high average incomes ($64k–$67k), indicating strong repayment capacity and market potential. Conversely, cities like Manchester and Edinburgh represent risk concentration zones.

-----

## 4\. Business Recommendations

### 4.1. Immediate Actions

1.  **Update Risk Models:** Re-weight the credit scoring algorithm to prioritize DTI and previous defaults using a **64:36 ratio**.
2.  **Simplify Underwriting:** Remove credit history length from primary risk factors to streamline the application and decisioning process.
3.  **Implement Employment-Based Pricing:** Introduce interest rate adjustments based on employment tenure, rewarding applicants with 5-20 years of stable employment.
4.  **Automate Low-Risk Approvals:** Consolidate Credit Grades A-C into a single "Tier 1" low-risk category and implement automated approvals for this segment.

### 4.2. Strategic Initiatives

1.  **Focus Geographic Expansion:** Prioritize marketing and capital deployment in the UK, with a specific focus on high-potential cities like London and Victoria.
2.  **Develop Niche Products:** Create specialized loan products with stricter terms or higher rates for high-risk segments (e.g., Credit Grades E-G) to safely capture a wider market.
3.  **Introduce State-Level Risk Weighting:** Add a state/regional risk adjustment factor into credit models to account for localized economic conditions.

-----

## 5\. Technical Implementation

### 5.1. Skills Demonstrated

  * **SQL:** Complex CTEs, advanced `CASE` statements, conditional aggregations, and subquery optimization for data transformation and feature engineering.
  * **Statistical Analysis:** One-way and multi-way ANOVA, Tukey HSD tests, effect size calculations, and confidence interval testing using Python (`statsmodels`, `scipy`).
  * **Business Intelligence:** Development of risk scoring logic, customer segmentation, market opportunity analysis, and creation of policy recommendation frameworks.

### 5.2. Tools and Technologies

  * **Database:** SQL Server / MySQL
  * **Analysis:** Python (Pandas, NumPy, SciPy, Statsmodels)
  * **Visualization:** Python (Matplotlib, Seaborn), Power BI
  * **Reporting:** Markdown

-----

## 6\. Conclusion and Future Work

This project successfully translated complex loan data into a clear, statistically validated framework for enhancing credit risk management. The findings provide a direct path to improving model accuracy, operational efficiency, and strategic decision-making.

### 6.1. Future Enhancements

  * [ ] Develop a predictive machine learning model (e.g., Logistic Regression, Gradient Boosting) to forecast default probability at the individual applicant level.
  * [ ] Conduct customer lifetime value (CLV) analysis to segment borrowers based on long-term profitability.

-----

## 7\. Project Resources

  * **Interactive Dashboard:** [View Power BI Report](https://app.powerbi.com/groups/me/reports/2ec52011-d429-492f-8323-48939cd57157/e344d92e99b5265b9c4d?experience=power-bi)
  * **Project Repository:** [GitHub Link](https://www.google.com/search?q=https://github.com/aDataMage/loan-default-analysis)
  * **Contact:** Adejori Eniola ([LinkedIn](https://www.linkedin.com/in/adatamage/) | adejorieniola@gmail.com)
