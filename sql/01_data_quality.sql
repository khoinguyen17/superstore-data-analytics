-- Retail Store Sales Data Analytics
-- 01_data_quality.sql
-- Purpose: Identify data quality issues before cleaning.

USE retail_sales_analysis;


-- =========================================================
-- 1. ROW COUNT
-- =========================================================

SELECT COUNT(*) AS total_rows
FROM retail_sales;


-- =========================================================
-- 2. DATE RANGE
-- =========================================================

SELECT
    MIN(transaction_date) AS first_transaction_date,
    MAX(transaction_date) AS last_transaction_date
FROM retail_sales;


-- =========================================================
-- 3. MISSING VALUES (NULL)
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(transaction_id IS NULL) AS missing_transaction_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(category IS NULL) AS missing_category,
    SUM(item IS NULL) AS missing_item,
    SUM(price_per_unit IS NULL) AS missing_price,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(total_spent IS NULL) AS missing_total_spent,
    SUM(payment_method IS NULL) AS missing_payment_method,
    SUM(transaction_date IS NULL) AS missing_transaction_date,
    SUM(discount_applied IS NULL) AS missing_discount,
    SUM(store_location IS NULL) AS missing_location
FROM retail_sales;


-- =========================================================
-- 4. BLANK TEXT VALUES
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    SUM(TRIM(item) = '') AS blank_item,
    SUM(TRIM(category) = '') AS blank_category,
    SUM(TRIM(payment_method) = '') AS blank_payment_method,
    SUM(TRIM(store_location) = '') AS blank_location,
    SUM(TRIM(discount_applied) = '') AS blank_discount
FROM retail_sales;


-- =========================================================
-- 5. DUPLICATE TRANSACTION IDs
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS unique_transaction_ids
FROM retail_sales;


-- Find transaction IDs that appear more than once

SELECT
    transaction_id,
    COUNT(*) AS row_count
FROM retail_sales
GROUP BY transaction_id
HAVING COUNT(*) > 1
ORDER BY row_count DESC;


-- =========================================================
-- 6. NUMERIC RANGE CHECKS
-- =========================================================

SELECT
    MIN(price_per_unit) AS minimum_price,
    MAX(price_per_unit) AS maximum_price,
    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity,
    MIN(total_spent) AS minimum_total_spent,
    MAX(total_spent) AS maximum_total_spent
FROM retail_sales;


-- =========================================================
-- 7. ZERO PRICE CHECK
-- =========================================================

-- A price of 0 may represent an invalid/missing price.

SELECT COUNT(*) AS zero_price_rows
FROM retail_sales
WHERE price_per_unit = 0;


-- =========================================================
-- 8. TOTAL SPENT CALCULATION CHECK
-- =========================================================

-- Total Spent should equal Quantity × Price Per Unit.

SELECT COUNT(*) AS total_spent_mismatches
FROM retail_sales
WHERE ABS(total_spent - (quantity * price_per_unit)) > 0.01;


-- =========================================================
-- 9. EXAMINE TOTAL SPENT MISMATCHES
-- =========================================================

SELECT
    transaction_id,
    item,
    price_per_unit,
    quantity,
    total_spent,
    (quantity * price_per_unit) AS calculated_total
FROM retail_sales
WHERE ABS(total_spent - (quantity * price_per_unit)) > 0.01
LIMIT 20;