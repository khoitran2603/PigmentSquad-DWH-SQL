/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For day segmentation, shift categorization, or time analysis.

SQL Functions Used:
    - CASE: Defines day & time segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*
    - Segment transactio date into day of the week.
    - Establishing store open/close hours 
    - Count how many transactions fall into each segment
*/
WITH day_segments AS (
SELECT
    transaction_date,
    DATENAME(WEEKDAY, transaction_date) AS weekday_dn,
    CAST('11:00' AS TIME) AS opening_hour,
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
                ELSE NULL
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
                ELSE NULL
            END
    END AS closing_hour
FROM gold.fact_sales
)
SELECT
    weekday_dn,
    opening_hour,
    closing_hour,
    COUNT(transaction_date) as total_transactions
FROM day_segments
WHERE DATEPART(YEAR, transaction_date) = 2024 
    AND DATEPART(MONTH, transaction_date) < 8 -- Before change in closing hour
GROUP BY weekday_dn, opening_hour, closing_hour
ORDER BY weekday_dn, total_transactions desc;

/*
    - Convert transaction time to hour
    - Count how many transactions fall into each time of the day
*/
WITH time_segments AS (
SELECT 
    transaction_time,
    CASE 
        WHEN DATEPART(HOUR, transaction_time) = 10 
            AND DATEPART(MINUTE, transaction_time) >= 0 
            AND DATEPART(MINUTE, transaction_time) < 60 
        THEN CAST('11:00' AS TIME)
        ELSE CAST(CONCAT(DATEPART(HOUR, transaction_time), ':00') AS TIME)
    END AS transaction_time_rounded --i.e, 14:00-14:59 --> 14
FROM gold.fact_sales
)
SELECT
    transaction_time_rounded,
    COUNT(transaction_time) as total_transactions
FROM time_segments
GROUP BY transaction_time_rounded
ORDER BY total_transactions DESC;

/*
    - Segment transaction time into day & evening
    - Count how many transactions fall into each segments
*/
WITH day_segments1 AS (
SELECT
    transaction_date,
    transaction_time,
    CAST('11:00' AS TIME) AS opening_hour,
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
                ELSE NULL
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
                ELSE NULL
            END
    END AS closing_hour
FROM gold.fact_sales
),
shift_segments AS (
SELECT
    transaction_time,
    CASE WHEN transaction_time >= opening_hour AND transaction_time < CAST('16:00' AS TIME) THEN 'Day' -- opening hour to 3:59:59pm
         WHEN transaction_time >= CAST('16:00' AS TIME) AND transaction_time < closing_hour THEN 'Evening' -- 4:00pm to closing hour
         ELSE 'Outside Hours'
    END AS time_of_day
FROM day_segments1
)
SELECT 
    time_of_day,
    COUNT(transaction_time) as total_transactions
FROM shift_segments
GROUP BY time_of_day
ORDER BY total_transactions;

/*
    - Segment sales amount into value ranges
    - Count how many transactions fall into each segments
*/
WITH lines AS (
  SELECT CAST(ABS(sales_amount) AS FLOAT) AS line_value
  FROM gold.fact_sales
  WHERE quantity > 0
),
bands AS (
  SELECT CASE 
           WHEN line_value < 10 THEN '<$10'
           WHEN line_value < 20 THEN '$10-19'
           WHEN line_value < 30 THEN '$20-29'
           WHEN line_value < 50 THEN '$30-49'
           ELSE '$50+' END AS price_band,
         COUNT(*) AS lines_cnt
  FROM lines GROUP BY CASE 
           WHEN line_value < 10 THEN '<$10'
           WHEN line_value < 20 THEN '$10-19'
           WHEN line_value < 30 THEN '$20-29'
           WHEN line_value < 50 THEN '$30-49'
           ELSE '$50+' END
)
SELECT * FROM bands ORDER BY 
  CASE price_band WHEN '<$10' THEN 1 WHEN '$10-19' THEN 2 WHEN '$20-29' THEN 3 WHEN '$30-49' THEN 4 ELSE 5 END;
