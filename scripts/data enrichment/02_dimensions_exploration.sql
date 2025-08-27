
/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT 
    product_category
FROM gold.fact_sales
ORDER BY product_category;

-- Retrieve a list of unique categories, subcategories, and products
SELECT DISTINCT 
    product_type, 
    product_category, 
    product_name 
FROM gold.fact_sales
ORDER BY  product_type, product_category, product_name 