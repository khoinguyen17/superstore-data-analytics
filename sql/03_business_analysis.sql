-- Retail Store Sales Data Analytics
-- 03_business_analysis.sql
--
-- Purpose:
-- Analyze cleaned retail sales data to answer
-- key business questions.
--
-- Data source:
-- retail_sales_clean

USE retail_sales_analysis;


-- =========================================================
-- 1. SALES OVERVIEW
-- =========================================================

SELECT
    COUNT(*) AS total_transactions,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(total_spent) AS total_sales,
    AVG(total_spent) AS average_transaction_value
FROM retail_sales_clean;