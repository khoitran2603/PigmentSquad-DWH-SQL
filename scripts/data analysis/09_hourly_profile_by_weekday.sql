/* Hour-of-day x Weekday transaction matrix (exclude refunds) */
WITH base AS (
  SELECT weekday_dn,
         CAST(transaction_time AS time) AS txn_time,
         SUM(total_transactions) AS txn
  FROM gold.sales_hours
  WHERE product_category <> 'Refund'
  GROUP BY weekday_dn, CAST(transaction_time AS time)
)
SELECT weekday_dn, txn_time, txn
FROM base
ORDER BY 
  CASE weekday_dn
    WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7 END,
  txn_time;