/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/
/* Top/bottom items by sales & transactions */
-- Top 20 by sales
SELECT TOP 20 product_name, SUM(sales_amount) AS sales, SUM(CASE WHEN quantity>0 THEN 1 ELSE 0 END) AS txn
FROM gold.fact_sales
WHERE quantity > 0
GROUP BY product_name
ORDER BY sales DESC;

-- Bottom 20 by sales (that still sold > 0 times)
WITH agg AS (
  SELECT product_name, SUM(sales_amount) AS sales, SUM(CASE WHEN quantity>0 THEN 1 ELSE 0 END) AS txn
  FROM gold.fact_sales
  WHERE quantity > 0
  GROUP BY product_name
)
SELECT TOP 20 * FROM agg
WHERE txn > 0
ORDER BY sales ASC, txn ASC;