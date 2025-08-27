/*
===============================================================================
Detecting Refund Transactions (within 5 mins since first purchase)
===============================================================================
Purpose:
    - Identify transactions that are effectively refunds due to customer
      change of mind.
    - A refund is defined as a pair of transactions where:
         • Same date
         • Same product name
         • Same absolute sales amount
         • Opposite quantity (1 vs -1)
         • Second transaction occurs within 5 minutes after the first
===============================================================================
*/

-- Step 1: Create a view of expanded refund events
CREATE OR ALTER VIEW gold.refund_events_expanded AS
WITH sales AS (
    -- Pull only the key columns needed from fact_sales
    SELECT
        transaction_date,
        transaction_time,
        product_category,
        product_name,
        quantity,
        sales_amount
    FROM gold.fact_sales
),
pairs AS (
    -- Join sales table to itself to find candidate sale/refund pairs
    SELECT
        s1.transaction_date,
        s1.product_name,
        s1.product_category AS product_category_1,
        s2.product_category AS product_category_2,
        s1.transaction_time AS time_1,
        s2.transaction_time AS time_2,
        s1.quantity         AS qty_1,  -- positive sale
        s2.quantity         AS qty_2,  -- negative refund
        s1.sales_amount     AS amount_1,
        s2.sales_amount     AS amount_2
    FROM sales s1
    JOIN sales s2
      ON s1.transaction_date = s2.transaction_date
     AND s1.product_name     = s2.product_name
     -- one positive (+1) and one negative (-1) quantity
     AND s1.quantity =  1
     AND s2.quantity = -1
     -- same absolute sales value
     AND ABS(s1.sales_amount) = ABS(s2.sales_amount)
     -- refund happens within 0–5 minutes of original purchase
     AND ABS(DATEDIFF(MINUTE, s1.transaction_time, s2.transaction_time)) BETWEEN 0 AND 5
     -- enforce ordering so we only keep sale→refund direction
     AND s1.transaction_time < s2.transaction_time
)
-- Step 2: Expand out to transaction-level rows for both sides
SELECT 
    transaction_date,
    product_name,
    product_category_1 AS product_category,
    qty_1 AS quantity,
    amount_1 AS sales_amount,
    time_1 AS transaction_time
FROM pairs
UNION ALL
SELECT 
    transaction_date,
    product_name,
    product_category_2 AS product_category,
    qty_2 AS quantity,
    amount_2 AS sales_amount,
    time_2 AS transaction_time
FROM pairs;
GO

-- Step 3: Quick validation check
-- Count how many refund events per product (excluding 'Refund' category label)
SELECT 
    product_name,
    COUNT(*) AS refund_event_count
FROM gold.refund_events_expanded
WHERE product_category != 'Refund'
GROUP BY product_name
ORDER BY refund_event_count DESC;



