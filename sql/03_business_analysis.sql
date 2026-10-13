-- =========================================================
-- PROJECT: RETAIL STORE SALES DATA ANALYTICS
-- FILE: 03_business_analysis.sql
-- =========================================================
--
-- Purpose:
-- Analyze cleaned retail sales data to identify sales patterns
-- across categories, products, payment methods, store locations,
-- customers, time periods, and discount status.
--
-- Source table:
--     retail_sales_clean
--
-- Total dataset size:
--     12,575 transaction rows
--
-- Key metrics:
--     Total sales = SUM(total_spent)
--     Total transactions = COUNT(*)
--     Unique customers = COUNT(DISTINCT customer_id)
--     Average transaction value = AVG(total_spent)
--
-- Important data limitation:
--     Some transactions have missing quantity, total_spent,
--     or discount status values. Interpret totals and averages
--     with this limitation in mind.
--
-- Analysis sections:
-- 1. Sales overview
-- 2. Sales by category
-- 3. Sales by product
-- 4. Sales by payment method
-- 5. Sales by store location
-- 6. Sales by customer
-- 7. Monthly sales trend
-- 8. Sales by discount status

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

-- Findings:
-- Total transactions: 12,575
-- Unique customers: 25
-- Total sales: $1,552,071.00
-- Average transaction value: $129.652577
--
-- Interpretation:
-- The dataset contains 12,575 transaction records from
-- 25 distinct customer IDs.

-- =========================================================
-- 2. SALES BY CATEGORY
-- =========================================================

SELECT
    category,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    SUM(total_spent) AS total_sales,
    AVG(total_spent) AS average_transaction_value
FROM retail_sales_clean
GROUP BY category
ORDER BY total_sales DESC;

-- Findings, ordered by total sales:
-- 1. Butchers: $208,113.00
-- 2. Electric household essentials: $203,813.50
-- 3. Beverages: $197,047.50
-- 4. Furniture: $195,310.00
-- 5. Food: $194,812.00
-- 6. Computers and electric accessories: $190,692.50
-- 7. Patisserie: $182,165.50
-- 8. Milk Products: $180,112.00
--
-- Interpretation:
-- Butchers generated the highest total sales, while Milk
-- Products generated the lowest among the eight categories.

-- =========================================================
-- 3. SALES BY PRODUCT
-- =========================================================

SELECT
    item,
    category,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    SUM(total_spent) AS total_sales,
    AVG(total_spent) AS average_transaction_value
FROM retail_sales_clean
GROUP BY item, category
ORDER BY total_sales DESC;

-- Findings: Top five products by total sales in the query output:
-- 1. Item_25_FUR: $25,256.00
-- 2. Item_25_EHE: $23,083.00
-- 3. Item_25_BUT: $21,894.00
-- 4. Item_24_FUR: $21,172.00
-- 5. Item_25_FOOD: $20,541.00
--
-- Interpretation:
-- Item_25_FUR had the highest total sales in the displayed
-- results. The item names are coded, so the underlying product
-- identities cannot be determined from these labels alone.

-- =========================================================
-- 4. SALES BY PAYMENT METHOD
-- =========================================================

SELECT
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    SUM(total_spent) AS total_sales,
    AVG(total_spent) AS average_transaction_value
FROM retail_sales_clean
GROUP BY payment_method
ORDER BY total_sales DESC;

-- Findings:
-- Cash: $537,710.00 across 4,310 transactions.
-- Digital Wallet: $507,279.00 across 4,144 transactions.
-- Credit Card: $507,082.00 across 4,121 transactions.
--
-- Interpretation:
-- Cash had the highest total sales. Digital Wallet and
-- Credit Card sales were very close, differing by $197.

-- =========================================================
-- 5. SALES BY STORE LOCATION
-- =========================================================

SELECT
    store_location,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    SUM(total_spent) AS total_sales,
    AVG(total_spent) AS average_transaction_value
FROM retail_sales_clean
GROUP BY store_location
ORDER BY total_sales DESC;

-- Findings:
-- Online: $791,401.00 across 6,354 transactions.
-- In-store: $760,670.00 across 6,221 transactions.
--
-- Interpretation:
-- Online sales were $30,731.00 higher than in-store sales.
-- The average transaction value was also slightly higher online.

-- =========================================================
-- 6. SALES BY CUSTOMER
-- =========================================================

SELECT
    customer_id,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    SUM(total_spent) AS total_sales,
    AVG(total_spent) AS average_transaction_value
FROM retail_sales_clean
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Findings: Top five customers by total sales in the query output:
-- 1. CUST_24: $68,452.00
-- 2. CUST_08: $67,351.50
-- 3. CUST_05: $66,974.50
-- 4. CUST_16: $65,570.50
-- 5. CUST_13: $65,037.00
--
-- Interpretation:
-- The top five customers had similar total sales.
-- Customer IDs are anonymized identifiers, not customer names.

-- =========================================================
-- 7. MONTHLY SALES TREND
-- =========================================================

SELECT
    YEAR(transaction_date) AS sales_year,
    MONTH(transaction_date) AS sales_month,
    SUM(total_spent) AS total_sales,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold
FROM retail_sales_clean
WHERE transaction_date IS NOT NULL
GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date)
ORDER BY
    sales_year,
    sales_month;

-- Purpose:
-- Examine monthly sales, transaction counts, and units sold
-- using the transaction date.
--
-- Method:
-- Group transactions by calendar year and month.
--
-- Findings:
-- Monthly results are returned by the query.
-- Review the complete chronological output before identifying
-- peak months, seasonal patterns, or year-over-year changes.

-- =========================================================
-- 8. SALES BY DISCOUNT STATUS
-- =========================================================

SELECT
    discount_applied,
    COUNT(*) AS total_transactions,
    SUM(quantity) AS total_units_sold,
    SUM(total_spent) AS total_sales,
    AVG(total_spent) AS average_transaction_value
FROM retail_sales_clean
GROUP BY discount_applied
ORDER BY total_sales DESC;

-- Findings:
-- True: $524,443.50 across 4,219 transactions.
-- False: $515,135.00 across 4,157 transactions.
-- NULL: $512,492.50 across 4,199 transactions.
--
-- Interpretation:
-- Transactions marked True had the highest total sales.
-- Average transaction values were similar across the groups.
--
-- Data limitation:
-- NULL means discount status is unknown. These transactions
-- should not be classified as either discounted or not discounted.
-- The results show an association, not proof that discounts
-- caused higher sales.