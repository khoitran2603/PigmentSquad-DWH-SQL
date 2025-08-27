Retail Data Warehouse & Analytics Project

Welcome to the **PigmentSquad Data Warehouse & Analytics** repository! 🚀  
This project showcases the end-to-end process of building a modern SQL Server data warehouse and applying analytics to retail POS sales. It demonstrates best practices in data engineering and exploratory analysis, designed as a portfolio project to highlight skills in ETL, data modelling, and insight generation.

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
![Data Architecture](docs/data_architecture.png)

1. **Bronze Layer**: Stores raw data as-is from the source systems. Data is ingested from CSV Files into SQL Server Database.
2. **Silver Layer**: This layer includes data cleansing, standardization, and normalization processes to prepare data for analysis.
3. **Gold Layer**: Houses business-ready data, structured around fact tables enriched with descriptive attributes for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.
4. **Analytics & Reporting**: Creating SQL-based reports and Power BI dashboards for actionable insights.

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a SQL Server–based data warehouse to consolidate POS sales transactions, enabling store-hour analysis, product mix insights, and data-driven staffing decisions.

#### Specifications
- **Data Sources**: Import sales exports from the POS system provided as monthly CSV files.
- **Data Quality**: Clean and standardize product names, categorize items consistently, and detect/refine refund transactions before reporting.
- **Integration**: Combine all exports into a unified fact-centric model, enriched with time and store-hour attributes to support analytical queries.
- **Scope**: Focus on transactions from Jan 2025 onwards; no historization of prior years is required.
- **Documentation**: Provide clear SQL scripts, schema definitions, and data enrichment to support both business stakeholders and analytics users.

---

### BI: Analytics & Reporting (Exploratory Analysis)

#### Objective
Develop SQL-based exploratory analysis on curated sales data (before enrichment) to uncover patterns in:
- **Transaction Volumes** (by day, time, and weekday)
- **Preliminary Sales Trends** (monthly and weekly variations)
- **Refund Detection** (customer change-of-mind events)

These exploratory insights provided stakeholders with an early understanding of sales dynamics and data quality, forming the basis for informed decision-making.  

## 📂 Repository Structure
```
PigmentSquad-DWH-SQL/
│
├── datasets/                          # Raw input files (monthly POS CSV exports from the store system)
│
├── docs/                              # Documentation & project artifacts
│   ├── data_architecture.png          # Visual diagram of the layered architecture (Bronze → Silver → Gold)
│   ├── data_catalog.md                # Data dictionary with field descriptions and metadata
│   ├── data_flow.png                  # End-to-end data flow (ingestion → transformation → reporting)
│   ├── data_models.png                # Data model diagram (fact-centric design)
│
├── scripts/                           # All SQL scripts grouped by purpose
│   ├── data warehouse/                # Core ETL pipeline for building the warehouse
│   │   ├── bronze/                    # Extract & load raw data (staging layer)
│   │   ├── silver/                    # Transform, clean, and standardise (business rules applied)
│   │   ├── gold/                      # Curated outputs for analytics (fact dataset, refund logic, sales-hour metrics)
│   ├── data enrichment/               # Exploratory & enrichment queries (segmentation, ranking)
│
├── tests/                             # Quality checks and validation scripts to ensure accuracy of transformations
│
├── README.md                          # Main project overview & user guide
├── LICENSE                            # Open-source license for project use
└── .gitignore                         # Files/folders excluded from Git (e.g., local cache, backups)

```
---
## 🗝️ Key Outputs
- **Cleaned fact dataset** with standardized transactions.
- **Refund detection report** to identify change-of-mind events.
- **Sales hour metric report** consolidating hourly KPIs and segmenting time into Day, Evening, and Outside Hours.
- **Exploratory SQL** reports on volumes, seasonality, segmentation, and product ranking.

---
## ⚙️ How to Reproduce
1. Set up the SQL Server database and schemas.
2. Run Bronze scripts to load raw CSVs.
3. Run Silver scripts to clean and standardize.
4. Run Gold scripts to generate business-ready outputs.
5. Validate results with enrichment scripts and tests.
