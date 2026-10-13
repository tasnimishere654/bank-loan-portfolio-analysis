-- ====================================================================
-- BANK LOAN RISK & PERFORMANCE ANALYTICS PIPELINE
-- Database Dialect: SQLite / MySQL
-- Objective: Extract macro portfolio KPIs and dimensional distributions
-- ====================================================================

-- --------------------------------------------------------------------
-- LAYER 1: EXECUTIVE KEY PERFORMANCE INDICATORS (KPIs)
-- --------------------------------------------------------------------

-- 1. Total Historical Portfolio Metrics
SELECT 
    COUNT(id) AS total_loan_applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Received_Amount,
    ROUND(AVG(int_rate), 4) * 100 AS AVG_Interest_Rate,
    AVG(dti) * 100 AS AVG_DTI 
FROM financial_loan;

-- 2. Month-to-Date (MTD) Volume Velocity (December 2021)
SELECT COUNT(id) AS MTD_total_loan_applications
FROM financial_loan
WHERE strftime('%m', issue_date) = '12'
  AND strftime('%Y', issue_date) = '2021';

-- 3. Previous Month-to-Date (PMTD) Volume Velocity (November 2021)
SELECT COUNT(id) AS PMTD_total_loan_applications
FROM financial_loan
WHERE strftime('%m', issue_date) = '11'
  AND strftime('%Y', issue_date) = '2021';

-- 4. Capital Allocation Variance (MTD vs PMTD Funding)
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount FROM financial_loan
WHERE strftime('%m', issue_date) = '12' AND strftime('%Y', issue_date) = '2021';

SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount FROM financial_loan
WHERE strftime('%m', issue_date) = '11' AND strftime('%Y', issue_date) = '2021';

-- 5. Liquidity Recovery Variance (MTD vs PMTD Cash Inflows)
SELECT SUM(total_payment) AS MTD_Total_Received_Amount FROM financial_loan
WHERE strftime('%m', issue_date) = '12' AND strftime('%Y', issue_date) = '2021';

SELECT SUM(total_payment) AS PMTD_Total_Received_Amount FROM financial_loan
WHERE strftime('%m', issue_date) = '11' AND strftime('%Y', issue_date) = '2021';


-- --------------------------------------------------------------------
-- LAYER 2: PORTFOLIO CREDIT QUALITY SEGMENTATION (Good vs. Bad Loans)
-- --------------------------------------------------------------------

-- 1. Percentage Profiles of Portfolio Risk
SELECT 
    ROUND(COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN id END) * 100.0 / COUNT(id), 2) AS Good_Loan_Percentage,
    ROUND(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0 / COUNT(id), 2) AS Bad_Loan_Percentage
FROM financial_loan;

-- 2. Macro Metrics Segregated by Loan Health Tier
SELECT
    loan_status,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received,
    AVG(int_rate * 100) AS Interest_Rate,
    AVG(dti * 100) AS DTI
FROM financial_loan
GROUP BY loan_status;


-- --------------------------------------------------------------------
-- LAYER 3: DIMENSIONAL DISTRIBUTIONS FOR TABLEAU REPORTING
-- --------------------------------------------------------------------

-- 1. Chronological Volume Trends (MoM Layer)
SELECT
    CAST(strftime('%m', issue_date) AS INTEGER) AS Month_Number,
    CASE strftime('%m', issue_date)
        WHEN '01' THEN 'January'   WHEN '02' THEN 'February'  WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'     WHEN '05' THEN 'May'       WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'      WHEN '08' THEN 'August'    WHEN '09' THEN 'September'
        WHEN '10' THEN 'October'   WHEN '11' THEN 'November'  WHEN '12' THEN 'December'
    END AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY strftime('%m', issue_date)
ORDER BY Month_Number;

-- 2. Regional Density Performance Map
SELECT 
    address_state AS State, 
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY address_state
ORDER BY address_state;

-- 3. Structural Amortization Term Analysis
SELECT 
    term,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY term
ORDER BY term;

-- 4. Socioeconomic Segmentation: Employment Tenure & Home Ownership
SELECT 
    emp_length,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY emp_length
ORDER BY emp_length;

SELECT 
    home_ownership,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY home_ownership
ORDER BY COUNT(id) DESC;

-- 5. Credit Intent Profiling (Purpose Mapping)
SELECT 
    purpose,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM financial_loan
GROUP BY purpose
ORDER BY COUNT(id) DESC;
