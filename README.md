# 🏦 Bank Loan Risk & Performance Analytics Dashboard

## 📌 Project Overview
This repository contains an end-to-end data analytics project focused on evaluating financial asset quality, loan volume trends, and risk distributions for a retail lending institution. 

By executing a modular **SQL extraction pipeline** against a transactional database of **38,576 records**, macro KPIs were calculated alongside critical dynamic variances—including **Month-over-Month (MoM)** growths and **Month-to-Date (MTD)** velocity thresholds. These outputs directly validate the interactive **Multi-View Tableau Dashboard** published on my [Tableau Public Profile]([https://public.tableau.com/views/BANKLOANREPORT_17917287893440/SUMMARY?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link]).

---

## 🛠️ Tech Stack & Tools
*   **Database Engine:** SQL (utilizing SQLite/MySQL date formatting structures)
*   **Data Manipulation:** Aggregations, Groupings, Conditional Pivots (`CASE WHEN`), Date Parsing (`strftime`)
*   **Data Visualization:** Tableau Desktop (Storyboarding & Actions)
*   **Version Control:** Git & GitHub

---

## 📊 Core Portfolio Key Performance Indicators (KPIs)
Based on the aggregated SQL extraction layer, the institution's lending portfolio status is defined by the following metrics:

*   **Total Volume Dynamics:** **38,576** active loan applications processed, with a Month-to-Date (MTD) velocity peaking at **4,314** applications in December 2021.
*   **Capital Allocation vs. Liquidity Recovery:** Capital deployment reached **\$435,757,075** in total funded value, yielding a positive recovery threshold with **\$473,070,933** in total received cash inflows.
*   **Borrower Risk Thresholds:** Portfolio averages stabilized at an **12.05% Interest Rate** and an average **13.33% Debt-to-Income (DTI)** ratio.

---

## 🏗️ Repository Architecture
```text
Bank_Loan_Analytics/
├── data/              # Anonymized transactional loan history file (.csv)
├── sql/               # Production-ready pipeline scripts (.sql)
│   ├── summary_kpis.sql
│   └── overview_dimensions.sql
├── dashboards/        # Packaged Tableau Workbook file (.twbx)
└── README.md          # Portfolio documentation
```

---

## 💻 Sample SQL Scripts & Aggregation Layer

### 1. High-Level Macro Portfolio Overview
This query establishes the macro baseline indicators across the complete historical lending catalog.
```sql
SELECT 
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount,
    ROUND(AVG(int_rate), 4) * 100 AS AVG_Interest_Rate,
    AVG(dti) * 100 AS AVG_DTI 
FROM financial_loan;
```

### 2. Strategic Quality Classification (Good vs. Bad Loans)
To separate profitable accounts from toxic, non-performing assets, conditional aggregation was used to evaluate risk categories.
```sql
SELECT
    CASE 
        WHEN loan_status IN ('Fully Paid', 'Current') THEN 'Good Loan'
        WHEN loan_status = 'Charged Off' THEN 'Bad Loan'
    END AS Loan_Category,
    COUNT(id) AS Total_Loans,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount,
    ROUND(COUNT(id) * 100.0 / (SELECT COUNT(*) FROM financial_loan), 2) AS Portfolio_Percentage
FROM financial_loan
GROUP BY 1;
```
*Output Summary Metrics:*
*   **Good Loans (Fully Paid / Current):** **86.18%** of the portfolio (**33,243 applications**), accounting for **\$370,224,850** in funding.
*   **Bad Loans (Charged Off):** **13.82%** of the portfolio (**5,333 applications**), resulting in a write-off exposure of **\$65,532,225**.

### 3. Chronological Volume Trends (MoM Layer)
Extracting month-level intervals dynamically via string-format date mapping to isolate performance variations across calendar intervals.
```sql
SELECT
    CAST(strftime('%m', issue_date) AS INTEGER) AS Month_Number,
    CASE strftime('%m', issue_date)
        WHEN '01' THEN 'January' WHEN '02' THEN 'February' WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'   WHEN '05' THEN 'May'      WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'    WHEN '08' THEN 'August'   WHEN '09' THEN 'September'
        WHEN '10' THEN 'October' WHEN '11' THEN 'November' WHEN '12' THEN 'December'
    END AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY strftime('%m', issue_date)
ORDER BY Month_Number;
```

---

## 🎨 Tableau Dashboard Layout & Interactive Views
The dataset was exported to feed a multi-layered dashboard, engineered for fast insight extraction:

1.  **Executive Summary View:** Highlights primary KPIs, MTD/PMTD changes, and a clean breakdown of Good vs. Bad Loan portfolio spreads.
2.  **Granular Operational Overview:** Displays interconnected visual arrays plotting applications and funding across:
    *   **Geographic Splits:** Filterable state maps (identifying high-density regions like CA with 6,894 applications).
    *   **Structural Terms:** 36-month (**28,237 loans**) vs. 60-month (**10,339 loans**) comparison charts.
    *   **Socioeconomic Factors:** Employment length arrays and home-ownership classes (Rent vs. Mortgage vs. Own).
    *   **Intent Mapping:** Stacked lists breaking down use cases (Debt Consolidation leading at 18,214 applications).
3.  **Detailed Grid View:** A sortable database pane allowing credit risk officers to drill down into unique record matrices.

👉 **[Click Here to Explore the Live Interactive Dashboard on Tableau Public](https://public.tableau.com/views/BANKLOANREPORT_17917287893440/SUMMARY?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)**

---

## 💡 Key Business Insights Discovered
*   **High Default Interest Elasticity:** Defaulted loans (`Charged Off`) carry a significantly higher average interest rate (**13.88%**) compared to safely settled loans (**11.64%**), illustrating aggressive pricing matching extreme risk pools.
*   **Debt Consolidation Density:** Over **47.2%** of the entire application pool is localized in a single channel—**Debt Consolidation**. This marks it as the primary revenue generator but a concentrated risk vector.
*   **Term Structure Volatility:** While 36-month cycles represent the vast majority of volume, 60-month terms represent elevated risk, showing higher average DTI ratios on longer amortizations.

---

## 🤝 Contact & Connections
*   **Author:** Tasnim Khan
*   **LinkedIn:** https://www.linkedin.com/in/tasnimkhan17/
*   **Email:** cjtasnim5@gmail.com
