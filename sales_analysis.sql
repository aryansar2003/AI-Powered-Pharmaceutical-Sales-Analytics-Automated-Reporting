CREATE DATABASE IF NOT EXISTS pharma_analytics;
USE pharma_analytics;

SELECT COUNT(*) FROM pharma_sales;

SELECT SUM(sales) AS total_sales
FROM pharma_sales;

SELECT 
    product_class,
    SUM(sales) AS total_sales
FROM pharma_sales
GROUP BY product_class
ORDER BY total_sales DESC;

SELECT COUNT(*) AS negative_transactions
FROM pharma_sales
WHERE quantity < 0;

SELECT 
    year,
    SUM(sales) AS total_sales
FROM pharma_sales
GROUP BY year
ORDER BY year;

SELECT
    product_class,
    SUM(sales) AS total_sales
FROM pharma_sales
GROUP BY product_class
ORDER BY total_sales DESC
LIMIT 1;