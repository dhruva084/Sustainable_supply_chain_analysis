# Sustainable Supply Chain & E-Commerce Logistics Analysis (PostgreSQL)
This project uses PostgreSQL to analyze e-commerce logistics and supply chain data from the Brazilian Olist dataset 2016-2018. 
The analysis explores delivery performance, freight costs across product categories, and the relationship between delivery delays and customer review scores.

The goal is to identify operational patterns and potential areas for improving logistics efficiency and supporting more sustainable supply chain practices.

# Tools & Technologies Used

* PostgreSQL
* SQL

# Dataset

The project uses the Olist Brazilian E-Commerce Public Dataset, including:
* Orders
* Order Items
* Products
* Order Reviews

# Analysis Performed

1. Delivery Performance:
* Calculated average delivery duration.
* Identified late deliveries by comparing actual and estimated delivery dates.
* Calculated the late delivery rate.

2. Freight Cost Analysis:
* Joined order items with product information.
* Calculated total and average freight costs by product category.
* Examined differences in freight cost patterns across categories.

3. Customer Review Analysis:
* Compared average customer review scores for late and on-time deliveries.
* Counted review records for each delivery status.

4. Data Validation:
* Checked table relationships using SQL joins.
* Investigated missing values and duplicate review identifiers.
* Used a generated surrogate primary key to preserve review records with duplicate review IDs.

# Key Findings
* Average delivery duration was approximately 12.56 days.
* Approximately 8.11% of delivered orders were classified as late.
* Bed, bath, and table products had the highest total freight cost among product categories.
* Computers had the highest average freight cost per order item, at approximately 48.45.
* On-time deliveries had an average review score of 4.29/5, compared with 2.57/5 for late deliveries.

These findings suggest an association between delivery delays and lower customer review scores.

# Sustainability Perspective

Freight costs and delivery performance can help identify areas for further investigation into supply chain efficiency. Potential opportunities include examining shipment consolidation, delivery planning, and transportation practices.
The dataset does not include shipment distance, vehicle type, fuel consumption, or transportation emissions. Therefore, this project does not calculate actual logistics-related greenhouse gas emissions or claim measured emissions reductions.

# Limitations
* The analysis is based on the available fields in the Olist dataset.
* Some source data contains missing values and duplicate review identifiers.
* Customer review records are not necessarily unique to individual orders.
* Freight cost is not a direct measurement of environmental impact.

# Repository Contents
* `Sustainable_supplychain_analysis.sql` — SQL scripts for table creation, data preparation, analysis, and validation.

# Conclusion
This project demonstrates the use of PostgreSQL for relational data analysis, data validation, aggregation, and joining multiple datasets to investigate e-commerce logistics performance and potential supply chain efficiency improvements.
