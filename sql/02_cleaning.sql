-- Retail Store Sales Data Analytics
-- 02_cleaning.sql
--
-- Purpose:
-- Create and maintain a cleaned version of the raw retail sales data.
--
-- Cleaning decisions:
-- 1. Replace invalid price_per_unit values of 0 with a calculated price
--    when quantity and total_spent are available.
-- 2. Convert quantity = 0 and total_spent = 0 into NULL because these
--    values represent missing data rather than actual zero-value purchases.
-- 3. Replace blank item values with 'Unknown' because the original item
--    cannot be reliably determined from the available data.
--
-- Raw table:
--     retail_sales
--
-- Cleaned table:
--     retail_sales_clean
--
-- The raw table is preserved so that the cleaning process is reproducible.


USE retail_sales_analysis;


-- =========================================================
-- 1. CREATE CLEANED TABLE
-- =========================================================
--
-- Create a separate table so the original raw data remains unchanged.
--
-- NOTE:
-- This section was run once to create the cleaned table.
-- Do not run CREATE TABLE again after the table already exists.


CREATE TABLE retail_sales_clean AS
SELECT
    transaction_id,
    customer_id,
    category,

    -- Replace blank item values with 'Unknown'
    CASE
        WHEN TRIM(item) = '' THEN 'Unknown'
        ELSE item
    END AS item,

    -- Recover invalid zero prices
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


-- =========================================================
-- 2. CONVERT INVALID ZERO VALUES TO NULL
-- =========================================================
--
-- In the raw data, 604 rows contained:
--     quantity = 0
--     total_spent = 0
--
-- These values were treated as missing rather than genuine
-- zero-value transactions.


SET SQL_SAFE_UPDATES = 0;

UPDATE retail_sales_clean
SET
    quantity = NULL,
    total_spent = NULL
WHERE quantity = 0
  AND total_spent = 0;

SET SQL_SAFE_UPDATES = 1;


-- =========================================================
-- 3. REPLACE REMAINING BLANK ITEMS
-- =========================================================
--
-- 1,213 rows had blank item values.
-- The exact item could not be reliably inferred from the
-- available fields, so the values were labeled 'Unknown'
-- rather than guessing.


SET SQL_SAFE_UPDATES = 0;

UPDATE retail_sales_clean
SET item = 'Unknown'
WHERE TRIM(item) = '';

SET SQL_SAFE_UPDATES = 1;


-- =========================================================
-- 4. CLEANING VALIDATION
-- =========================================================
--
-- Verify that invalid zero prices have been corrected.


SELECT COUNT(*) AS remaining_zero_prices
FROM retail_sales_clean
WHERE price_per_unit = 0;


-- Verify that Total Spent matches:
-- Quantity × Price Per Unit
--
-- Rows with missing quantity/total are excluded from this check.


SELECT COUNT(*) AS remaining_mismatches
FROM retail_sales_clean
WHERE quantity IS NOT NULL
  AND price_per_unit IS NOT NULL
  AND total_spent IS NOT NULL
  AND ABS(total_spent - (quantity * price_per_unit)) > 0.01;


-- Verify that blank item values have been removed.


SELECT COUNT(*) AS remaining_blank_items
FROM retail_sales_clean
WHERE TRIM(item) = '';


-- Count values labeled as Unknown.


SELECT COUNT(*) AS unknown_items
FROM retail_sales_clean
WHERE item = 'Unknown';


-- Verify that missing quantities and totals are now represented
-- as NULL rather than misleading zero values.


SELECT
    SUM(quantity IS NULL) AS missing_quantity,
    SUM(total_spent IS NULL) AS missing_total_spent
FROM retail_sales_clean;