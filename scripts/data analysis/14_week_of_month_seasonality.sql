/* Week-of-month seasonality (1..5) */
WITH base AS (
  SELECT transaction_date,
         ((DAY(transaction_date)-1)/7)+1 AS week_of_month,
         SUM(total_transactions) AS txn,
         SUM(total_sales) AS sales
  FROM gold.sales_hours
  WHERE product_category <> 'Refund'
  GROUP BY transaction_date, ((DAY(transaction_date)-1)/7)+1
)
SELECT year(transaction_date) AS year_dp,
       month(transaction_date) AS month_dp,
       week_of_month,
       SUM(txn) AS total_txn,
       SUM(sales) AS total_sales
FROM base
GROUP BY year(transaction_date), month(transaction_date), week_of_month
ORDER BY year_dp, month_dp, week_of_month;