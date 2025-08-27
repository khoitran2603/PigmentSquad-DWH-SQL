/*
===============================================================================
Store Hours Metrics Report
===============================================================================
Purpose:
  Consolidate hour-level store metrics for analysis & decision-making.

Pipeline (all safe to re-run):
  1) Create/refresh refund detection view (sale↔refund within 5 minutes)
  2) Create/refresh filtered fact view (excludes detected refunds)
  3) Create/refresh sales_hours metrics view (hour bucket, KPIs)
===============================================================================
*/

-- ============================================================================
-- 1) Refund detection (view)
--    Logic: same date + same product + same abs(amount) + (+1 vs -1 qty)
--           and refund occurs 0–5 minutes after original sale
-- ============================================================================
CREATE OR ALTER VIEW gold.refund_events_expanded AS
WITH sales AS (
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
    SELECT
        s1.transaction_date,
        s1.product_name,
        s1.product_category AS product_category_1,
        s2.product_category AS product_category_2,
        s1.transaction_time AS time_1,
        s2.transaction_time AS time_2,
        s1.quantity         AS qty_1,  -- original sale (+1)
        s2.quantity         AS qty_2,  -- refund (-1)
        s1.sales_amount     AS amount_1,
        s2.sales_amount     AS amount_2
    FROM sales s1
    JOIN sales s2
      ON s1.transaction_date = s2.transaction_date
     AND s1.product_name     = s2.product_name
     AND s1.quantity         =  1
     AND s2.quantity         = -1
     AND ABS(s1.sales_amount) = ABS(s2.sales_amount)
     AND ABS(DATEDIFF(MINUTE, s1.transaction_time, s2.transaction_time)) BETWEEN 0 AND 5
     AND s1.transaction_time < s2.transaction_time  -- enforce sale→refund direction
)
-- expand both sides so we can anti-join easily
SELECT
    transaction_date,
    time_1 AS transaction_time,
    product_category_1 AS product_category,
    product_name,
    qty_1   AS quantity,
    amount_1 AS sales_amount
FROM pairs
UNION ALL
SELECT
    transaction_date,
    time_2 AS transaction_time,
    product_category_2 AS product_category,
    product_name,
    qty_2   AS quantity,
    amount_2 AS sales_amount
FROM pairs;
GO

-- ============================================================================
-- 2) Filtered fact (view)
--    Keep everything except rows identified as refund events above.
--    Using a VIEW (not SELECT INTO) makes this re-runnable & always fresh.
-- ============================================================================
CREATE OR ALTER VIEW gold.fact_sales_filtered AS
SELECT f.*
FROM gold.fact_sales f
WHERE NOT EXISTS (
    SELECT 1
    FROM gold.refund_events_expanded r
    WHERE f.transaction_date  = r.transaction_date
      AND f.transaction_time  = r.transaction_time
      AND f.product_name      = r.product_name
      AND f.product_category  = r.product_category
      AND f.quantity          = r.quantity
      AND f.sales_amount      = r.sales_amount
);
GO

-- ============================================================================
-- 3) sales_hours metrics (view)
--    - Snap raw timestamps to hour buckets
--    - Derive opening/closing hours by weekday & period
--    - Tag Day/Evening/Outside Hours
--    - Calculate KPIs (transactions, sales, qty, AOR, hours_since_opening/closing)
-- ============================================================================
CREATE OR ALTER VIEW gold.sales_hours AS
WITH CTE_base_query AS (
    SELECT 
        transaction_date,
        transaction_time,
        product_type,
        product_category,
        product_name,
        product_price,
        discount_amount,
        sales_amount,
        quantity
    FROM gold.fact_sales_filtered
),
CTE_sales_aggregation AS (
    SELECT 
        transaction_date,
        /* Snap 10:00–10:59 to 11:00 (business rule); else use HH:00 */
        CASE 
            WHEN DATEPART(HOUR, transaction_time) = 10 
                 AND DATEPART(MINUTE, transaction_time) BETWEEN 0 AND 59
            THEN CAST('11:00' AS TIME)
            ELSE CAST(CONCAT(DATEPART(HOUR, transaction_time), ':00') AS TIME)
        END AS transaction_time,
        product_type,
        product_category,
        product_name,
        DATEPART(YEAR,  transaction_date) AS year_dp,
        DATENAME(WEEKDAY, transaction_date) AS weekday_dn,
        DATEPART(MONTH, transaction_date) AS month_dp,
        ((DAY(transaction_date) - 1) / 7) + 1 AS week_of_month,
        /* Opening hour is fixed at 11:00 */
        CAST('11:00' AS TIME) AS opening_hour,
        /* Closing-hour calendar:
           - Before Aug 2024: Mon–Thu/Sun 22:00; Fri/Sat 23:00
           - Aug 2024 onward: Mon–Thu/Sun 21:00; Fri/Sat 22:00
        */
        CASE 
            WHEN DATEPART(YEAR, transaction_date) = 2024 AND DATEPART(MONTH, transaction_date) < 8 THEN 
                CASE DATENAME(WEEKDAY, transaction_date)
                    WHEN 'Monday' THEN CAST('22:00' AS TIME)
                    WHEN 'Tuesday' THEN CAST('22:00' AS TIME)
                    WHEN 'Wednesday' THEN CAST('22:00' AS TIME)
                    WHEN 'Thursday' THEN CAST('22:00' AS TIME)
                    WHEN 'Friday' THEN CAST('23:00' AS TIME)
                    WHEN 'Saturday' THEN CAST('23:00' AS TIME)
                    WHEN 'Sunday' THEN CAST('22:00' AS TIME)
                END
            ELSE
                CASE DATENAME(WEEKDAY, transaction_date)
                    WHEN 'Monday' THEN CAST('21:00' AS TIME)
                    WHEN 'Tuesday' THEN CAST('21:00' AS TIME)
                    WHEN 'Wednesday' THEN CAST('21:00' AS TIME)
                    WHEN 'Thursday' THEN CAST('21:00' AS TIME)
                    WHEN 'Friday' THEN CAST('22:00' AS TIME)
                    WHEN 'Saturday' THEN CAST('22:00' AS TIME)
                    WHEN 'Sunday' THEN CAST('21:00' AS TIME)
                END
        END AS closing_hour,
        SUM(sales_amount) AS total_sales,
        SUM(quantity)     AS total_quantity,
        COUNT(*)          AS total_transactions
    FROM CTE_base_query
    GROUP BY
        transaction_date,
        CASE 
            WHEN DATEPART(HOUR, transaction_time) = 10 
                 AND DATEPART(MINUTE, transaction_time) BETWEEN 0 AND 59
            THEN CAST('11:00' AS TIME)
            ELSE CAST(CONCAT(DATEPART(HOUR, transaction_time), ':00') AS TIME)
        END,
        product_type,
        product_category,
        product_name
)
SELECT 
    transaction_date,
    transaction_time,
    product_type,
    product_category,
    product_name,
    year_dp,
    weekday_dn,
    month_dp,
    week_of_month,
    opening_hour,
    closing_hour,
    /* Business segmentation */
    CAST(time_of_day AS NVARCHAR(255)) AS time_of_day,
    /* KPIs */
    total_sales,
    total_quantity,
    total_transactions,
    /* Average Order Revenue (AOR) */
    CASE WHEN total_transactions = 0 THEN 0
         ELSE total_sales / total_transactions
    END AS avg_order_revenue,
    /* Position relative to open/close windows */
    CASE WHEN time_of_day = 'Day'
         THEN DATEDIFF(HOUR, opening_hour, transaction_time)
         ELSE NULL
    END AS hours_since_opening,
    CASE WHEN time_of_day = 'Evening'
         THEN DATEDIFF(HOUR, transaction_time, closing_hour)
         ELSE NULL
    END AS hours_until_closing
FROM (
    SELECT
        *,
        CASE 
            WHEN transaction_time >= opening_hour
             AND transaction_time <  CAST('16:00' AS TIME) THEN 'Day'      -- 11:00 to 15:59
            WHEN transaction_time >= CAST('16:00' AS TIME)
             AND transaction_time <  closing_hour          THEN 'Evening'  -- 16:00 to < closing
            ELSE 'Outside Hours'
        END AS time_of_day
    FROM CTE_sales_aggregation
) t;
GO
