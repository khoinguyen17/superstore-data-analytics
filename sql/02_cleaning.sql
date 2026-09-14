-- Retail Store Sales Data Analytics
-- 02_cleaning.sql
-- Purpose: Create a cleaned version of the raw retail sales data.

USE retail_sales_analysis;


-- Create cleaned table
CREATE TABLE retail_sales_clean AS
SELECT
    transaction_id,
    customer_id,
    category,
    item,
    CASE
        WHEN price_per_unit = 0
             AND quantity > 0
        THEN total_spent / quantity
        ELSE price_per_unit
    END AS price_per_unit,
    quantity,
    total_spent,
    payment_method,
    transaction_date,
    discount_applied,
    store_location
FROM retail_sales;