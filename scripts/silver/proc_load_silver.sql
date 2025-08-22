/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    BEGIN TRY
        PRINT '==============================';
        PRINT 'Loading Silver Layer';
        PRINT '=============================';

        PRINT '-----------------------------';
        PRINT 'Loading POS Product Sales Data';
        PRINT '-----------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: silver.pos_prd_sales';
        TRUNCATE TABLE silver.pos_prd_sales

        PRINT '>> Inserting Data Into: silver.pos_prd_sales';
        INSERT INTO silver.pos_prd_sales (
            [Date],
            [Time],
            [Category],
            [Item],
            [Qty],
            [Product Sales],
            [Discounts],
            [Net Sales],
            [Itemization Type]
            )
        SELECT
            CAST(
                CONCAT(
                REPLACE(SUBSTRING([Date], 6, LEN([Date])), '/', ''), '-',
                REPLACE(SUBSTRING([Date], 3, 3), '/',''), '-',
                REPLACE(SUBSTRING([Date], 1, 2), '/',''))
                AS date) AS [Date], -- convert date string format to date sql format
            CAST([Time] AS time) AS [Time], -- convert time from string to time
            CASE 
                WHEN CAST(REPLACE([Net Sales], '$', '') AS FLOAT) < 0 OR CAST(Qty AS INT) < 0 THEN 'Refund'
                WHEN [Itemization Type] IS NULL AND Item != 'Custom Amount' THEN 'Service'
                WHEN Item = 'Custom Amount' THEN 'Figurines'
                WHEN Item LIKE '%Gift%Card%' THEN 'Gift Card'
                ELSE 
                    CASE
                        WHEN Item IN ('Imperfect', 'Damaged Item') THEN 'Figurines'
                        WHEN Item = 'Soy Milk' THEN 'Beverages'
                        WHEN Item = 'Booking' THEN 'Service'
                        WHEN Item = 'Bottle - Sting' THEN 'Beverages'
                        WHEN Item LIKE 'Drink%' THEN 'Beverages'
                        WHEN Item LIKE 'Energy Drink%' THEN 'Beverages'
                        WHEN Item = 'Extra - Colour Tube' THEN 'Accessories'
                        WHEN Item = 'Return to Paint' THEN 'Service'
                        WHEN Item LIKE 'Tea %' THEN 'Beverages'
                        WHEN Item IN ('Extra Paints','Take-home kit','Glow Serum') THEN 'Accessories'
                        WHEN Item IN ('Gloss Varnish','Gloss','Repeat painting') THEN 'Service'
                        ELSE 
                            CASE 
                                WHEN Category NOT IN ('Accessories','Service','Beverages') THEN 'Figurines'
                                ELSE Category
                            END
                    END
            END AS Category, -- Category override
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(Item, '- DIY Figurine Painting Kit', ''), 
                                    '- DIY Figurine Painting', ''), 
                                    '- DIY  Figurine Painting Kit', ''), 
                                    '-DIY Figurine Painting Kit', ''), 
                                    '- DIY Plaster Figurine Painting Kit', ''),
                                    '-  DIY Figurine Painting Kit',''),
                'Custom Amount', 'New Product') AS Item, -- Cleaned Item name
            CAST(Qty AS INT) AS Qty, -- convert qty to integer
            CAST(REPLACE([Product Sales], '$', '') AS FLOAT) AS [Product Sales], -- convert product sales to float
            CAST(REPLACE([Discounts], '$', '') AS FLOAT) AS [Discounts], -- convert discount to float
            CAST(REPLACE([Net Sales], '$', '') AS FLOAT) AS [Net Sales], -- convert net sales to float
            CASE
                WHEN ABS(CAST(REPLACE([Product Sales], '$', '') AS FLOAT)) - ABS(CAST(REPLACE([Discounts], '$', '') AS FLOAT)) = 0 AND CAST(Qty AS INT) > 0 THEN 'Cash Payment'
                WHEN Item LIKE 'Order%' THEN 'Physical Good'
                WHEN [Itemization Type] IS NULL AND Item != 'Custom Amount' THEN 'Booking'
                WHEN Item = 'Custom Amount' THEN 'Physical Good'
                WHEN [Itemization Type] IS NULL AND Item NOT LIKE '%Gift%Card%' THEN 'Service'
                ELSE [Itemization Type]
            END AS [Itemization Type] -- Itemization Type override
        FROM bronze.pos_prd_sales
        WHERE LEN(Qty) < 3 -- Qty's values that make sense
        SET @end_time = GETDATE();
        PRINT '------------------------------';
        PRINT 'Loading Completed';
        PRINT 'Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '------------------------------';
    END TRY
    BEGIN CATCH
        PRINT '======================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT '======================================';
    END CATCH
END;
GO

EXEC silver.load_silver;
GO