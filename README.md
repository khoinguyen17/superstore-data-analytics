# Superstore Data Analytics

End-to-end Superstore sales and profitability analysis using MySQL
and Tableau Public.

## Objective

Analyze sales, profitability, customers, products, regions, and
discounts to identify trends and business opportunities.

## Tools

- MySQL / MySQL Workbench
- Tableau Public
- Excel
- Git / GitHub

## Dataset

Retail Store Sales dataset containing 12,575 transaction records.

The dataset contains intentionally messy data, including missing and invalid values that were identified and cleaned using SQL.

The raw dataset is not included in this repository. It is kept locally because the raw data is not required for the analysis repository.

## Data Quality

The raw dataset was profiled before cleaning.

Data quality checks included:

- Row counts
- Missing values
- Blank text values
- Duplicate transaction IDs
- Numeric range checks
- Invalid zero prices
- Total Spent calculation consistency

Key issues identified:

- 1,213 blank item values
- 609 invalid `price_per_unit` values recorded as 0
- 604 missing quantity values represented as 0
- 604 missing total spent values represented as 0

Cleaning steps included:

- Recovering invalid prices using `Total Spent / Quantity`
- Converting missing quantity and total spent values from 0 to NULL
- Replacing blank item values with `Unknown`
- Preserving the original raw table for reproducibility

## Analysis

Key questions include:

- Which product categories generate the most sales?
- Which products generate the most revenue?
- Which payment methods are most commonly used?
- How do sales vary by store location?
- How do sales change over time?
- How does discount usage relate to sales?
- Which customers generate the most revenue?

## Dashboard

Tableau Public dashboard: [link will be added later]

## Key Findings

To be added after the SQL analysis and Tableau dashboard are completed.
