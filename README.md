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
├── README.md
├── data/
│   └── data-dictionary.md
├── sql/
│   ├── risk-assessment/
│   │   ├── 01-credit-grade-income-analysis.sql
│   │   ├── 02-risk-factor-combinations.sql
│   │   └── 03-employment-length-analysis.sql
│   └── geographic-analysis/
│       ├── 01-country-performance.sql
│       └── 02-regional-stability.sql
├── insights/
│   ├── risk-assessment/
│   │   ├── credit-grade-income-analysis.md
│   │   ├── risk-factor-combinations.md
│   │   └── employment-length-analysis.md
│   └── geographic-analysis/
│       └── country-market-analysis.md
└── visualizations/
    ├── income-and-credit_grade-analysis.png
    ├── risk_factor_analysis.png
    └── employment_analysis_dashboard.png
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

**Statistical Validation:** One-way ANOVA with Tukey HSD post-hoc testing (α=0.05)

**Business Impact:** Established 4-tier risk classification system for automated underwriting

[View Full Analysis](./insights/risk-assessment/credit-grade-income-analysis.md)

---

#### 2. Risk Factor Combination Analysis

**Business Question:** Which combination of factors (debt-to-income ratio, previous defaults, credit history length) creates the highest risk segments?

**Key Findings:**

- **DTI Level:** Strongest predictor (F=259.82, p=0.004) - explains 64% of variance
- **Previous Defaults:** Secondary predictor (F=147.55, p=0.007) - explains 36% of variance
- **Credit History Length:** Not statistically significant (F=1.06, p=0.486)
- High DTI customers have 25.6% higher default rates than low DTI (p=0.002)

**Statistical Validation:** Three-way ANOVA with interaction effects testing

**Business Impact:** Recommended 64:36 weight ratio for DTI vs previous defaults in risk scoring; removed credit history length from models

[View Full Analysis](./insights/risk-assessment/risk-factor-combinations.md)

---

#### 3. Employment Length Correlation Analysis

**Business Question:** How does employment length correlate with default rates across different job types?

**Key Findings:**

- Long employment tenure (5-20 years) shows significantly lower default rates
- 9.075% lower default rate vs short employment (p=0.021)
- Employment type showed no significant contribution to default rates
- Very long tenure (20+ years) paradoxically shows higher risk (small sample issue)

**Statistical Validation:** One-way ANOVA with Tukey HSD comparisons

**Business Impact:** Prioritize borrowers with 5-20 years employment history; adjust interest rates based on tenure

[View Full Analysis](./insights/risk-assessment/employment-length-analysis.md)

---

### Geographic Market Analysis

#### 4. International Market Performance

**Business Question:** How do default rates vary by country, and which international markets show promise?

**Key Findings:**

- [Your findings here after completing the analysis]

**Business Impact:** [Impact statement]

[View Full Analysis](./insights/geographic-analysis/country-market-analysis.md)

---

## Technical Skills Demonstrated

### SQL Techniques

- Complex CTEs with multiple nesting levels
- Window functions (ROW_NUMBER, RANK, NTILE)
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

## Future Enhancements

- [ ] Develop customer lifetime value segmentation
- [ ] Build predictive machine learning model for default probability

## Contact

**Adejori Eniola**

- LinkedIn: [Your LinkedIn]
- Email: [Your Email]
- Portfolio: [Your Portfolio Website]
