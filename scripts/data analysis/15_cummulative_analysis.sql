/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

/* Cumulative contribution across the day (for each weekday) */
WITH hour_roll AS (
  SELECT weekday_dn,
         CAST(transaction_time AS time) AS txn_time,
         SUM(total_transactions) AS txn
  FROM gold.sales_hours
  WHERE product_category <> 'Refund' AND transaction_time <= closing_hour
  GROUP BY weekday_dn, CAST(transaction_time AS time)
),
ranked AS (
  SELECT weekday_dn, txn_time, txn,
         SUM(txn) OVER (PARTITION BY weekday_dn ORDER BY txn_time
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cum_txn,
         SUM(txn) OVER (PARTITION BY weekday_dn) AS total_txn
  FROM hour_roll
)
SELECT weekday_dn, txn_time, txn,
       ROUND(100.0 * cum_txn / NULLIF(total_txn,0), 2) AS cum_pct_of_day
FROM ranked
ORDER BY 
  CASE weekday_dn
    WHEN 'Monday' THEN 1 WHEN 'Tuesday' THEN 2 WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4 WHEN 'Friday' THEN 5 WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7 END,
  txn_time;