# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **fact tables** for specific business metrics.

---

### **gold.fact_sales**
- **Purpose:** Stores transactional sales data for analytical purposes.
- **Columns:**

| Column Name        | Data Type      | Description                                                                                   |
|--------------------|----------------|-----------------------------------------------------------------------------------------------|
| transaction_date   | DATE           | The date when the transaction occurred.                                                       |
| transaction_time   | TIME           | The time of day when the transaction occurred.                                                |
| product_type       | NVARCHAR(50)   | The classification of the item based on how it was sold (e.g., Service, Physical Good).       |                             
| product_category   | NVARCHAR(50)   | The business category of the product (e.g., Figurines, Accessories, Beverages, Service).      |                                                     
| product_name       | NVARCHAR(255)  | The cleaned name of the product sold.                                                         |
| product_price      | FLOAT          | The gross sales value before discounts for this item.                                         |             
| discount_amount    | FLOAT          | The discount applied to the item, if any.                                                     |
| sales_amount       | FLOAT          | The final net sales amount after discount                                                     |
| quantity           | INT            | The number of units sold in the transaction (can be negative for refunds).                    |
