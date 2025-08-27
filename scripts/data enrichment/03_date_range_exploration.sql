/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data.

SQL Functions Used:
    - MIN(), MAX()
===============================================================================
*/

-- Determine the first and last transaction time in a day
SELECT
    MIN(transaction_time) as first_transaction_time,
    MAX(transaction_time) as last_transaction_time,
    MIN(transaction_date) as first_transaction_date,
    MAX(transaction_date) as last_transaction_date
FROM gold.fact_sales

