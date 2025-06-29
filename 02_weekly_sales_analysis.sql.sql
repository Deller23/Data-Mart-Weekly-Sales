-- ==========================================
-- Data Mart Project: Weekly Sales Analysis
-- ==========================================
-- Description: Cleansing and exploration of weekly sales data.
-- ==========================================
-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS case1;

-- Use the case1 database for all operations
USE case1;
-- ==========================================
-- Section 1: Data Cleansing
-- ==========================================

-- Create a cleaned version of the weekly_sales table
CREATE TABLE clean_weekly_sales AS
SELECT
  week_date,
  WEEK(week_date) AS week_number,
  MONTH(week_date) AS month_number,
  YEAR(week_date) AS calendar_year,
  region,
  platform,
  CASE
    WHEN segment = 'null' THEN 'Unknown'
    ELSE segment
  END AS segment,
  CASE
    WHEN RIGHT(segment, 1) = '1' THEN 'Young Adults'
    WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
    WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees'
    ELSE 'Unknown'
  END AS age_band,
  CASE
    WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
    WHEN LEFT(segment, 1) = 'F' THEN 'Families'
    ELSE 'Unknown'
  END AS demographic,
  customer_type,
  transactions,
  sales,
  ROUND(sales / transactions, 2) AS avg_transaction
FROM weekly_sales;

-- Preview cleaned data
SELECT * FROM clean_weekly_sales LIMIT 10;

-- ==========================================
-- Section 2: Data Exploration
-- ==========================================

-- 1. Identify missing week numbers (1-52)
-- Generate sequence of 1 to 52 using a reliable method
DROP TABLE IF EXISTS seq52;
CREATE TEMPORARY TABLE seq52 (x INT);

INSERT INTO seq52 (x)
SELECT ROW_NUMBER() OVER () AS x
FROM (
  SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
  UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
) t1,
(
  SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
  UNION ALL SELECT 6
) t2
LIMIT 52;

SELECT x AS missing_week
FROM seq52
WHERE x NOT IN (
  SELECT DISTINCT week_number FROM clean_weekly_sales
);

-- 2. Total transactions per year
SELECT
  calendar_year,
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY calendar_year;

-- 3. Total sales by region and month
SELECT
  month_number,
  region,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
GROUP BY month_number, region
ORDER BY month_number, region;

-- 4. Total transactions by platform
SELECT
  platform,
  SUM(transactions) AS total_transactions
FROM clean_weekly_sales
GROUP BY platform;

-- 5. Monthly percentage of sales: Retail vs Shopify
WITH cte_monthly_platform_sales AS (
  SELECT
    month_number,
    calendar_year,
    platform,
    SUM(sales) AS monthly_sales
  FROM clean_weekly_sales
  GROUP BY month_number, calendar_year, platform
)
SELECT
  month_number,
  calendar_year,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Retail' THEN monthly_sales ELSE 0 END) /
    SUM(monthly_sales), 2
  ) AS retail_percentage,
  ROUND(
    100 * MAX(CASE WHEN platform = 'Shopify' THEN monthly_sales ELSE 0 END) /
    SUM(monthly_sales), 2
  ) AS shopify_percentage
FROM cte_monthly_platform_sales
GROUP BY month_number, calendar_year
ORDER BY month_number, calendar_year;

-- 6. Percentage of sales by demographic per year
SELECT
  calendar_year,
  demographic,
  SUM(sales) AS yearly_sales,
  ROUND(
    100 * SUM(sales) / SUM(SUM(sales)) OVER (PARTITION BY calendar_year), 2
  ) AS percentage
FROM clean_weekly_sales
GROUP BY calendar_year, demographic
ORDER BY calendar_year, demographic;

-- 7. Top demographic + age_band segments for Retail sales
SELECT
  age_band,
  demographic,
  SUM(sales) AS total_sales
FROM clean_weekly_sales
WHERE platform = 'Retail'
GROUP BY age_band, demographic
ORDER BY total_sales DESC;
