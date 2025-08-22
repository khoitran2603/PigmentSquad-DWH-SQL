/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or Invalid Quantity
    - Data standardization and consistency.
    - Invalid Sql date format.
    - Category Correctness
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- ====================================================================
-- Checking 'silver.pos_prd_sales'
-- ====================================================================
-- Data Standardization & Consistency
SELECT DISTINCT
    [Item],
    [Category],
    [Itemization Type]
FROM silver.pos_prd_sales
ORDER BY [Item]

-- Check for correct labelling transactions as 'Refund'
SELECT 
    Item,
    Category,
    Qty,
    [Net Sales]
FROM silver.pos_prd_sales
WHERE Category = 'Refund'
ORDER BY Item;

-- Check for NULLs or  Invalid Values in Quantity
-- Expectation: No Results
SELECT
    Qty
FROM silver.pos_prd_sales
WHERE LEN(Qty) > 2 OR Qty IS NULL;

-- Check for correct SQL date format ()
-- Expectation: Sorted in correct order
SELECT 
    DISTINCT [Date]
FROM silver.pos_prd_sales
ORDER BY [Date];

