/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.
    - Combines all items data into a single table.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '==============================';
        PRINT 'Loading Bronze Layer';
        PRINT '=============================';

        PRINT '-----------------------------';
        PRINT 'Loading POS Product Sales Data';
        PRINT '-----------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.items_20250101_20250901';
        TRUNCATE TABLE bronze.items_20250101_20250901;

        PRINT '>> Inserting Data Into: bronze.items_20250101_20250901';
        BULK INSERT bronze.items_20250101_20250901
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2025-01-01-2026-01-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',              -- UTF-8
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';
        
        ---------------------------------
        
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: items_20241201_20250101';
        TRUNCATE TABLE bronze.items_20241201_20250101;

        PRINT '>> Inserting Data Into: bronze.items_20241201_20250101';
        BULK INSERT bronze.items_20241201_20250101
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2024-12-01-2025-01-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';
        
        ---------------------------------
        
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: items_20241101_20241201';
        TRUNCATE TABLE bronze.items_20241101_20241201;

        PRINT '>> Inserting Data Into: bronze.items_20241101_20241201';
        BULK INSERT bronze.items_20241101_20241201
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2024-11-01-2024-12-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';
        
        ---------------------------------
        
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: items_20241001_20241101';
        TRUNCATE TABLE bronze.items_20241001_20241101;

        PRINT '>> Inserting Data Into: bronze.items_20241001_20241101';
        BULK INSERT bronze.items_20241001_20241101
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2024-10-01-2024-11-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';
        
        ---------------------------------
        
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: items_20240901_20241001';
        TRUNCATE TABLE bronze.items_20240901_20241001;

        PRINT '>> Inserting Data Into: bronze.items_20240901_20241001';
        BULK INSERT bronze.items_20240901_20241001
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2024-09-01-2024-10-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';
        
        ---------------------------------
        
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: items_20240801_20240901';
        TRUNCATE TABLE bronze.items_20240801_20240901;

        PRINT '>> Inserting Data Into: bronze.items_20240801_20240901';
        BULK INSERT bronze.items_20240801_20240901
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2024-08-01-2024-09-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';
            
        ---------------------------------
        
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: items_20240701_20240801';
        TRUNCATE TABLE bronze.items_20240701_20240801;

        PRINT '>> Inserting Data Into: bronze.items_20240701_20240801';
        BULK INSERT bronze.items_20240701_20240801
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2024-07-01-2024-08-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';
            
        ---------------------------------
        
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: items_20240601_20240701';
        TRUNCATE TABLE bronze.items_20240601_20240701;

        PRINT '>> Inserting Data Into: bronze.items_20240601_20240701';
        BULK INSERT bronze.items_20240601_20240701
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2024-06-01-2024-07-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';
            
        ---------------------------------
        
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: items_20240501_20240601';
        TRUNCATE TABLE bronze.items_20240501_20240601;

        PRINT '>> Inserting Data Into: bronze.items_20240501_20240601';
        BULK INSERT bronze.items_20240501_20240601
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2024-05-01-2024-06-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';
                
        ---------------------------------
        
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: items_20240101_20240501';
        TRUNCATE TABLE bronze.items_20240101_20240501;

        PRINT '>> Inserting Data Into: bronze.items_20240101_20240501';
        BULK INSERT bronze.items_20240101_20240501
        FROM 'C:\Users\ASUS\OneDrive\Desktop\pigmentsquad-sql-data-analytics-project\datasets\source_pos\items-2024-01-01-2024-05-01.csv'
        WITH (
            FIRSTROW = 2,                    -- skip header row
            FIELDTERMINATOR = ',',           -- comma-separated
            ROWTERMINATOR = '\n',            -- end of line
            CODEPAGE = '65001',
            TABLOCK                          -- speeds up bulk insert
        );
        SET @end_time = GETDATE();
        PRINT '>> Loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR(10)) + ' seconds';
        PRINT '>> -----------------';

        SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Bronze Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='

        -----------------------------------
        PRINT '------------------------------';
        PRINT 'Combining All Items Data Into: bronze.pos_prd_sales';
        PRINT '------------------------------';

        PRINT '>> Truncating Table: bronze.pos_prd_sales';
        TRUNCATE TABLE bronze.pos_prd_sales;

        PRINT '>> Inserting Data Into: bronze.pos_prd_sales';
        INSERT INTO bronze.pos_prd_sales
        SELECT * FROM bronze.items_20250101_20250901
        UNION ALL
        SELECT * FROM bronze.items_20241201_20250101
        UNION ALL
        SELECT * FROM bronze.items_20241101_20241201
        UNION ALL
        SELECT * FROM bronze.items_20241001_20241101
        UNION ALL
        SELECT * FROM bronze.items_20240901_20241001
        UNION ALL
        SELECT * FROM bronze.items_20240801_20240901
        UNION ALL
        SELECT * FROM bronze.items_20240701_20240801
        UNION ALL
        SELECT * FROM bronze.items_20240601_20240701
        UNION ALL
        SELECT * FROM bronze.items_20240501_20240601
        UNION ALL
        SELECT * FROM bronze.items_20240101_20240501
    
    END TRY
    BEGIN CATCH
        PRINT '======================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT '======================================';
    END CATCH
END;

