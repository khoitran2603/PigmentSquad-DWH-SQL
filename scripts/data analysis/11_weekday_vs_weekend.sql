/* Weekday vs Weekend mix */
WITH by_day AS (
  SELECT
    CASE WHEN weekday_dn IN ('Saturday','Sunday') THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    SUM(total_transactions) AS txn,
    SUM(total_sales) AS sales
  FROM gold.sales_hours
  WHERE product_category <> 'Refund'
  GROUP BY CASE WHEN weekday_dn IN ('Saturday','Sunday') THEN 'Weekend' ELSE 'Weekday' END
)
SELECT day_type, txn, sales,
       CAST(sales / NULLIF(txn,0) AS FLOAT) AS atv
FROM by_day;