/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Fact: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE OR ALTER VIEW gold.fact_sales AS
SELECT 
    Date AS transaction_date,
    Time AS transaction_time,
    [Itemization Type] AS product_type,
    Category AS product_category,
    Item AS product_name,
    [Product Sales] AS product_price,
    [Discounts] AS discount_amount,
    [Net Sales] AS sales_amount,
    Qty AS quantity
FROM silver.pos_prd_sales
GO