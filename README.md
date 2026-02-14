# Olympics Data Analysis & ETL (SQL)



## Project Overview
This project involves a comprehensive analysis of the historical Olympics dataset (1896–2016) using **PostgreSQL**. The goal was to transform raw, messy CSV data into actionable insights regarding athlete performance, country-wise medal trends, and seasonal participation.



## Technical Skills Demonstrated
* **ETL & Data Cleaning:** Handled inconsistent data types and missing values using `NULLIF`, `TRIM`, and `ALTER TABLE` commands.
* **Advanced SQL Logic:** Utilized **Common Table Expressions (CTEs)** to create modular, readable queries for multi-step analysis.
* **Window Functions:** Implemented `RANK()` and `PARTITION BY` to identify top-performing athletes for every participating nation.
* **Data Pivoting:** Used **Conditional Aggregations** (`CASE WHEN`) to compare Summer vs. Winter Games performance in a single view.



## Key Insights
* **Top Nations:** Identified the top 10 countries by total medal count, with a deep dive into their seasonal strengths.
* **Gold Medal Efficiency:** Calculated the "Gold Medal Ratio" to find which countries have the highest percentage of first-place finishes.
* **Multi-Sport Mastery:** Isolated athletes who successfully competed in more than one distinct sport.



## How to Run
1.  Import the `athlete_events.csv` and `noc_regions.csv` into a PostgreSQL database.
2.  Execute the queries in `SAGAR R SQL final eval project.sql` to replicate the analysis.
