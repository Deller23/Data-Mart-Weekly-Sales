# 📊 Data Mart Project – Weekly Sales Analysis

This project builds a focused **sales data mart** using SQL. It demonstrates my ability to clean, transform, and analyze real-world transactional data to extract business insights. All logic is implemented using pure SQL, with no external tools or programming.

---

## 🧠 What This Project Demonstrates

-  End-to-end SQL-based data transformation and analysis
-  Data cleaning and enrichment using string and date functions
-  Customer segmentation by age and demographic
-  Business metric analysis (sales, transactions, platform performance)
-  Use of **CTEs**, **window functions**, **aggregations**, and **subqueries**

---

## 📁 Project Structure

 File Name                               Description                                 

 `01_create_and_load_weekly_sales.sql`   Creates the `weekly_sales` table and inserts 1000+ rows of data              
 `02_weekly_sales_analysis.sql`          Cleans the raw data and performs 7 key business analyses                       
 `README.md`                             Project documentation (you’re reading it)                                   

---

## 🔍 Key Business Insights Analyzed

This project answers real-world business questions such as:

1. **Which week numbers are missing from the sales records?**
2. **How do transactions vary by year?**
3. **What are the total sales by region and month?**
4. **How do Retail and Shopify platforms compare in monthly sales?**
5. **What percentage of sales is contributed by different demographics?**
6. **Which age and demographic groups contribute the most to Retail sales?**

---

## 🧹 Data Cleaning Highlights

- Replaced missing values in the `segment` column with `'Unknown'`
- Derived new columns:
  - `week_number`, `month_number`, `calendar_year` from `week_date`
  - `age_band` using `RIGHT(segment, 1)`
  - `demographic` using `LEFT(segment, 1)`
- Created a `clean_weekly_sales` table with cleaned and enriched data
- Calculated average transaction value per row

---

## ⚙️ SQL Concepts Used

- `CASE` statements for classification and segmentation
- String functions like `LEFT()`, `RIGHT()`
- Date functions like `WEEK()`, `MONTH()`, `YEAR()`
- Aggregations (`SUM()`, `GROUP BY`)
- Common Table Expressions (CTEs)
- Window functions (`OVER(PARTITION BY ...)`)
- NULL handling and derived metrics

---

## 🚀 How to Run This Project

1. Open **MySQL Workbench**
2. Run the file `01_create_and_load_weekly_sales.sql`  
   → This will create the base table and load data
3. Run the file `02_weekly_sales_analysis.sql`  
   → This will create a cleaned table and perform all analysis queries
4. Explore the results from each query block

---

## 🧑‍💻 About Me

I'm an aspiring **Data Analyst** with skills in:

- SQL and relational database systems
- Business logic and metrics interpretation
- Data cleaning and reporting
- End-to-end problem solving using structured query language

This project is one of the ways I showcase my practical understanding of real-world sales data analytics.

---



