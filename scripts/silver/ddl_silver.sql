/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
IF OBJECT_ID('silver.pos_prd_sales') IS NOT NULL
    DROP TABLE silver.pos_prd_sales;
GO
CREATE TABLE silver.pos_prd_sales (
    Date date,
    Time time,
    Category NVARCHAR(50),
    Item NVARCHAR(255),
    Qty INT,
    [Product Sales] FLOAT,
    [Discounts] FLOAT,
    [Net Sales] FLOAT,
    [Itemization Type] NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

