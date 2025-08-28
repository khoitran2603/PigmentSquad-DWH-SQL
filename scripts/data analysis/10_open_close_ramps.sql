/* Ramps within 2h after open & 2h before close (exclude refunds) */
-- After opening
SELECT weekday_dn, hours_since_opening AS hours_from_open,
       SUM(total_transactions) AS txn, SUM(total_sales) AS sales
FROM gold.sales_hours
WHERE product_category <> 'Refund' AND time_of_day = 'Day' AND hours_since_opening BETWEEN 0 AND 2
GROUP BY weekday_dn, hours_since_opening
ORDER BY weekday_dn, hours_from_open;

-- Before closing
SELECT weekday_dn, hours_until_closing AS hours_to_close,
       SUM(total_transactions) AS txn, SUM(total_sales) AS sales
FROM gold.sales_hours
WHERE product_category <> 'Refund' AND time_of_day = 'Evening' AND hours_until_closing BETWEEN 0 AND 2
GROUP BY weekday_dn, hours_until_closing
ORDER BY weekday_dn, hours_to_close;