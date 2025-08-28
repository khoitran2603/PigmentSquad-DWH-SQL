/* Product category mix by hour (share of transactions) */
WITH base AS (
  SELECT CAST(transaction_time AS time) AS txn_time,
         product_category,
         SUM(total_transactions) AS txn
  FROM gold.sales_hours
  WHERE product_category <> 'Refund' AND transaction_time <= closing_hour
  GROUP BY CAST(transaction_time AS time), product_category
),
tot AS (
  SELECT txn_time, SUM(txn) AS total_txn FROM base GROUP BY txn_time
)
SELECT b.txn_time, b.product_category, b.txn,
       ROUND(100.0 * b.txn / NULLIF(t.total_txn,0), 2) AS pct_of_hour
FROM base b
JOIN tot t ON t.txn_time = b.txn_time
ORDER BY b.txn_time, pct_of_hour DESC;