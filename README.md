# Loan Default Analysis - SQL Portfolio Project

## Project Overview

This project analyzes loan application data to identify patterns in loan defaults and provide actionable insights for risk assessment and business decision-making. Using advanced SQL techniques and statistical analysis, I explored key factors that influence loan approval outcomes and default rates across different customer segments.

**Key Focus Areas:**

- Risk assessment and credit analysis
- Geographic market analysis
- Statistical validation of risk factors

## Dataset Description

The dataset contains 32,000+ loan application records with 28 features covering:

- **Demographics:** Age, income, education, marital status, location
- **Financial Metrics:** Debt-to-income ratio, credit utilization, loan amounts
- **Credit History:** Credit grade, previous defaults, credit history length, delinquencies
- **Loan Characteristics:** Loan purpose, interest rate, loan term, repayment status

**Target Variable:** Binary loan default outcome (0 = repaid, 1 = defaulted)

## Repository Structure

```tree
loan-default-analysis/
│   README.md
│
├───Data
│   │   Credit_Risk_Dataset_Onyx_Data_September_25.csv
│   │
│   ├───Geographic Analysis
│   │       default_rates_vs_income.csv
│   │       default_rates_vs_loan_volumes.csv
│   │       stability_analysis.csv
│   │
│   └───Risk Assesment
│           credit_utilization_vs_default_rate.csv
│           employment-length-analysis.csv
│           income-and-credit_grade-analysis.csv
│           lti_default_rate.csv
│           risk_factor_analysis.csv
│
├───Insights
│   ├───Geographic Analysis
│   │       default_rates_vs_loan_volumes.md
│   │       default_rate_vs_income_by_cities.md
│   │       market_promise_analysis.md
│   │
│   └───Risk Assesment
│           credit_utilization_vs_default_rate.md
│           employment-length-analysis.md
│           income-and-credit_grade-analysis.md
│           lti_default_rate.md
│           risk_factor_analysis.md
│
├───Questions
│       advanced-analytics.md
│       customer-segmentation.md
│       geographic-analysis.md
│       product-performance.md
│       risk-assessment.md
│
├───Solutions
├───SQL
│   ├───Geographic Analysis
│   │       Default_rates_vs_Income.sql
│   │       Default_rates_vs_Loan_volumes.sql
│   │       SQLQuery2.sql
│   │       Stability Analysis.sql
│   │
│   └───Risk_Assesments
│           Credit Utilization Ratio and Default Rate.sql
│           Employment Length vs Default Rate Analysis.sql
│           Income and Credit Grade Analysis.sql
│           Loan to Income vs Default Rate.sql
│           Risk Factor Analysis.sql
│
├───Statistical Tests
│   ├───Geographic Analysis
│   │       city_risk_analysis_6segments.png
│   │       default_rates_vs_income.ipynb
│   │       default_rates_vs_loan_volumes.ipynb
│   │       stability_analysis.ipynb
│   │       state_risk_analysis.png
│   │
│   └───Risk Assesment
│           credit_utilization_vs_default_rate.ipynb
│           employment-length-analysis.ipynb
│           income-and-credit_grade-analysis.ipynb
│           lti_default_rate.ipynb
│           risk_factor_analysis.ipynb
│
└───Visualizations
    ├───Geographic Analysis
    │       city_risk_analysis.png
    │       state_risk_analysis.png
    │
    └───Risk Assesment
            employment-length-analysis.png
            income-and-credit_grade-analysis.png
            risk_factor_analysis.png
```


## Key Analyses Completed

### Risk Assessment & Credit Analysis

#### 1. Credit Grade vs Income Bracket Analysis

**Business Question:** What is the default rate by credit grade and how does it vary across income brackets?

**Key Findings:**

- Credit grade is the dominant predictor of default risk
- Grade G loans show 95-100% default rates across all income levels
- Grades A-C show statistically similar performance (no significant difference)
- Income level has minimal impact compared to credit grade
- Income Level <50k shows difference in credit grade A-C and D-E from 50k>

<img alt="alt text" height="500" src="/Visualizations/Risk%20Assesment/income-and-credit_grade-analysis.png" title="Heatmap of Credit Grade vs Income Bracket" width="500"/>

**Statistical Validation:** Two-way ANOVA with Tukey HSD post-hoc testing (α=0.05)

**Business Impact:** Established 4-tier risk classification system for automated underwriting

[View Full Analysis](/Insights/Risk%20Assesment/income-and-credit_grade-analysis.md)

---

#### 2. Risk Factor Combination Analysis

**Business Question:** Which combination of factors (debt-to-income ratio, previous defaults, credit history length) creates the highest risk segments?

**Key Findings:**

- **DTI Level:** Strongest predictor (F=259.82, p=0.004) - explains 64% of variance
- **Previous Defaults:** Secondary predictor (F=147.55, p=0.007) - explains 36% of variance
- **Credit History Length:** Not statistically significant (F=1.06, p=0.486)
- High DTI customers have 25.6% higher default rates than low DTI (p=0.002)

<img alt="alt text" height="500" src="/Visualizations/Risk%20Assesment/risk_factor_analysis.png" title="Contingency Table" width="500"/>

**Statistical Validation:** Three-way ANOVA with interaction effects testing

**Business Impact:** Recommended 64:36 weight ratio for DTI vs previous defaults in risk scoring; removed credit history length from models

[View Full Analysis](/Insights/Risk%20Assesment/risk_factor_analysis.md)

---

#### 3. Employment Length Correlation Analysis

**Business Question:** How does employment length correlate with default rates across different job types?

**Key Findings:**

- Long employment tenure (5-20 years) shows significantly lower default rates
- 9.075% lower default rate vs short employment (p=0.021)
- Employment type showed no significant contribution to default rates
- Very long tenure (20+ years) paradoxically shows higher risk (small sample issue)
- High variation across employment length in self-employed type

<img alt="alt text" height="500" src="/Visualizations/Risk%20Assesment/employment-length-analysis.png" title="Heatmap of Employment Length vs Type" width="500"/>

**Statistical Validation:** Two-way ANOVA with Tukey HSD comparisons

**Business Impact:** Prioritize borrowers with 5-20 years employment history; adjust interest rates based on tenure

[View Full Analysis](/Insights/Risk%20Assesment/employment-length-analysis.md)

#### 4. Credit Utilization Ratio Analysis

**Business Question:** Which credit utilization ranges show the lowest default rates, and how strong is the relationship
between utilization and default probability?

**Key Findings:**

- Credit utilization ratio alone is not a strong predictor of default risk in this portfolio.
- “low utilization ≠ low risk” — it might reflect thin credit files, unused lines, or dormant accounts.
- High utilization (>80%) slightly elevates risk but not enough to justify strict cutoff policies without additional signals.

**Statistical Validation:** One-Way Anova

**Business Impact:** Do Not Overweight Utilization in Risk Models, Avoid Penalizing Low Utilization Alone

[View Full Analysis](Insights/Risk%20Assesment/credit_utilization_vs_default_rate.md)

#### 5. Loan to Income ratio Analysis

**Business Question:** What's the relationship between loan-to-income ratio and default probability?

**Key Findings:**

- 30% emerges as a meaningful risk threshold, above which default risk speeds up sharply
- Borrowers with LTI below 10% show the lowest default probability (11.5%), indicating strong repayment capacity
**Statistical Validation:** One-Way Anova

**Business Impact:** Use loan-to-income segmentation as an early-stage screening tool in credit scoring models to quickly flag high-risk applications.

[View Full Analysis](Insights/Risk%20Assesment/lti_default_rate.md)

---

### Geographic Market Analysis

#### 6. International Market Performance

**Business Question:** How do default rates vary by country, and which international markets show the strongest potential for strategic expansion?

**Key Findings:**

- Default rates for the three largest markets are tightly clustered between **21.7% and 21.9%**, implying broadly similar credit behaviour across markets.
- The UK slightly outperforms peers on default rate and low-risk share while also having the largest loan volume — making it the most attractive near-term target for scaled product rollouts.


**Business Impact:** Targeted Origination: UK first, then USA & Canada

[View Full Analysis](/Insights/Geographic%20Analysis/market_promise_analysis.md)

#### 7. Default Rate vs Loan Volumes by State

**Business Question:** Which states combine **low default risk** with **high loan volumes** — and which require closer monitoring due to unfavorable risk–volume dynamics?

**Key Findings:**

- None of the states fall into the **Low Risk / High Volume** category — the “sweet spot” for lending growth.
-  **England** emerges as the strongest performer, with **$35.48M in loan volume** and a **default rate of 21.8%** — the **best combination of scale and risk**.
- A moderate **positive correlation (r ≈ 0.61)** between **loan volume** and **default rate** suggests that **higher exposure tends to bring higher risk**.

**Business Impact:** Add a **state-level risk weight** into existing credit models

[View Full Analysis](/Insights/Geographic%20Analysis/default_rates_vs_loan_volumes.md)

#### 7. City-Level Risk & Income Analysis: Identifying Expansion Opportunities"

**Business Question:** What cities represent the best expansion opportunities based on income levels and default rates?

**Key Findings:**

- London and Victoria stand out as top expansion targets — both exhibit below-portfolio default rates (~21%) and competitive income levels ($64–67k), suggesting strong borrower repayment capacity.
- Manchester and Edinburgh combine above-average default rates with strong demand, indicating risk concentration zones where portfolio diversification or credit tightening is warranted.

**Business Impact:** Explore product differentiation for high-income, low-risk borrowers.

[View Full Analysis](/Insights/Geographic%20Analysis/default_rate_vs_income_by_cities.md)


---

## Technical Skills Demonstrated

### SQL Techniques

- Complex CTEs with multiple nesting levels
- Advanced CASE logic for categorical binning
- Conditional aggregations
- Subquery optimization
- Data cleaning and outlier handling

### Statistical Analysis

- One-way and three-way ANOVA
- Tukey HSD multiple comparison tests
- Effect size calculations (sum of squares)
- Coefficient of variation for stability metrics
- Confidence intervals and significance testing

### Business Intelligence

- Risk scoring model development
- Customer segmentation analysis
- Market opportunity identification
- Predictive factor validation
- Policy recommendation frameworks

## Key Business Recommendations

### Immediate Actions

1. **Update Risk Models:** Implement 64:36 weighting for DTI vs previous defaults
2. **Simplify Underwriting:** Remove credit history length from primary risk factors
3. **Employment-Based Pricing:** Apply tenure-based interest rate adjustments
4. **Credit Grade Tiers:** Consolidate A-C grades into single low-risk category

### Strategic Initiatives

1. Focus expansion on low-risk geographic markets identified in analysis
2. Develop specialized products for high-risk segments (Grades E-G)
3. Streamline application process by reducing non-predictive data collection
4. Implement automated approval for Tier 1 borrowers (Grades A-C)

## Tools & Technologies

- **Database:** SQL Server / MySQL
- **Statistical Analysis:** Python (statsmodels, scipy)
- **Visualization:** Python (matplotlib, seaborn)
- **Documentation:** Markdown

## Project Highlights

- Analyzed 32,000+ loan records with 28 variables
- Conducted rigorous statistical testing with proper multiple comparison corrections
- Generated actionable insights with clear business impact
- Demonstrated end-to-end analytical workflow from SQL to business recommendations
- Created publication-quality visualizations for executive presentations
- Created a powerBI Dashboard - 
## Future Enhancements

- [ ] Develop customer lifetime value segmentation
- [ ] Build predictive machine learning model for default probability

## Contact

**Adejori Eniola**

- LinkedIn: https://www.linkedin.com/in/adatamage/
- Email: adejorieniola@gmail.com
- Portfolio: https://github.com/aDataMage
