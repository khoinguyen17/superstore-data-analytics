-- Superstore Data Analytics
-- 01_data_quality.sql
-- Purpose: Validate the imported Superstore dataset before analysis.

USE superstore_analysis;


-- 1. Row Count
SELECT COUNT(*) AS total_rows
FROM orders;


-- 2. Date Range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    MIN(ship_date) AS first_ship_date,
    MAX(ship_date) AS last_ship_date
FROM orders;


-- 3. Missing Values
SELECT
    COUNT(*) AS total_rows,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(order_date IS NULL) AS missing_order_date,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(sales IS NULL) AS missing_sales,
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(discount IS NULL) AS missing_discount,
    SUM(profit IS NULL) AS missing_profit
FROM orders;


-- 4. Duplicate Row IDs
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT row_id) AS unique_row_ids
FROM orders;


-- 5. Unusual Values
SELECT
    MIN(sales) AS minimum_sales,
    MAX(sales) AS maximum_sales,
    MIN(quantity) AS minimum_quantity,
    MAX(quantity) AS maximum_quantity,
    MIN(discount) AS minimum_discount,
    MAX(discount) AS maximum_discount,
    MIN(profit) AS minimum_profit,
    MAX(profit) AS maximum_profit
FROM orders;