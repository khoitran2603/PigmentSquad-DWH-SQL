/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

/* Baseline totals & data recency */
SELECT 
  COUNT(*)              AS rows_fact,
  SUM(CASE WHEN quantity > 0 THEN 1 ELSE 0 END) AS sale_rows,
  SUM(CASE WHEN quantity < 0 THEN 1 ELSE 0 END) AS refund_rows,
  SUM(sales_amount)     AS total_sales,
  SUM(quantity)         AS total_units
FROM gold.fact_sales;

SELECT 
  year(transaction_date) as year_dp, 
  month(transaction_date) as month_dp,
  COUNT(*) AS total_transactions,
  SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY 
  year(transaction_date), 
  month(transaction_date)
ORDER BY year_dp, month_dp;

-- Generate a Report that shows all key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM gold.fact_sales
UNION ALL
SELECT 'Total Transactions', COUNT(*) FROM gold.fact_sales;




