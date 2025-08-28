/* Outside-hours contribution by weekday & category */
SELECT weekday_dn, product_category,
       SUM(total_transactions) AS txn, SUM(total_sales) AS sales
FROM gold.sales_hours
WHERE time_of_day = 'Outside Hours' AND product_category <> 'Refund'
GROUP BY weekday_dn, product_category
ORDER BY weekday_dn, sales DESC;

-- Share of total that is outside hours
WITH tot AS (
  SELECT SUM(total_transactions) AS all_txn, SUM(total_sales) AS all_sales
  FROM gold.sales_hours
  WHERE product_category <> 'Refund'
),
out_h AS (
  SELECT SUM(total_transactions) AS out_txn, SUM(total_sales) AS out_sales
  FROM gold.sales_hours
  WHERE product_category <> 'Refund' AND time_of_day = 'Outside Hours'
)
SELECT 
  ROUND(100.0 * out_txn / NULLIF(all_txn,0), 2) AS pct_txn_outside,
  ROUND(100.0 * out_sales / NULLIF(all_sales,0), 2) AS pct_sales_outside
FROM tot CROSS JOIN out_h;