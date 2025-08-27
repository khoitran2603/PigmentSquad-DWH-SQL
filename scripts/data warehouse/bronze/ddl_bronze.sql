/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/
IF OBJECT_ID('bronze.pos_prd_sales') IS NOT NULL
    DROP TABLE bronze.pos_prd_sales;
GO
CREATE TABLE bronze.pos_prd_sales (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20250101_20250901') IS NOT NULL
    DROP TABLE bronze.items_20250101_20250901;
GO
CREATE TABLE bronze.items_20250101_20250901 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20241201_20250101') IS NOT NULL
    DROP TABLE bronze.items_20241201_20250101;
GO
CREATE TABLE bronze.items_20241201_20250101 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20241101_20241201') IS NOT NULL
    DROP TABLE bronze.items_20241101_20241201;
GO
CREATE TABLE bronze.items_20241101_20241201 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20241001_20241101') IS NOT NULL
    DROP TABLE bronze.items_20241001_20241101;
GO
CREATE TABLE bronze.items_20241001_20241101 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20240901_20241001') IS NOT NULL
    DROP TABLE bronze.items_20240901_20241001;
GO
CREATE TABLE bronze.items_20240901_20241001 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20240801_20240901') IS NOT NULL
    DROP TABLE bronze.items_20240801_20240901;
GO
CREATE TABLE bronze.items_20240801_20240901 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20240701_20240801') IS NOT NULL
    DROP TABLE bronze.items_20240701_20240801;
GO
CREATE TABLE bronze.items_20240701_20240801 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20240601_20240701') IS NOT NULL
    DROP TABLE bronze.items_20240601_20240701;
GO
CREATE TABLE bronze.items_20240601_20240701 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20240501_20240601') IS NOT NULL
    DROP TABLE bronze.items_20240501_20240601;
GO
CREATE TABLE bronze.items_20240501_20240601 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.items_20240101_20240501') IS NOT NULL
    DROP TABLE bronze.items_20240101_20240501;
GO
CREATE TABLE bronze.items_20240101_20240501 (
    [Date] NVARCHAR(50),
    [Time] NVARCHAR(50),
    [Category] NVARCHAR(100),
    [Item] NVARCHAR(255),
    [Qty] NVARCHAR(50),
    [Product Sales] NVARCHAR(50),
    [Discounts] NVARCHAR(50),
    [Net Sales] NVARCHAR(50),
    [Itemization Type] NVARCHAR(50)
);
GO


