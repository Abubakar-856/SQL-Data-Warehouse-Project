/*
===============================================================================
Exploratory Data Analysis (EDA) — Gold Layer
===============================================================================

Purpose:
    This script explores the Gold layer of the data warehouse to understand
    overall business performance, customer distribution, product distribution,
    sales performance, and customer purchasing behaviour.

Source Objects:
    • fact_sales
    • dim_customers
    • dim_products

===============================================================================
*/

USE dw_gold;

-- 1. Key Business Metrics
SELECT 'Total sales' measure_name, SUM(sales_amount) measure_value  FROM fact_sales
UNION ALL
SELECT 'Total quantity' measure_name, SUM(quantity) measure_value FROM fact_sales
UNION ALL
SELECT 'Average price' measure_name, CAST(AVG(price) AS SIGNED) measure_value FROM fact_sales
UNION ALL
SELECT 'Total orders' measure_name, COUNT(DISTINCT order_number) measure_value FROM fact_sales
UNION ALL
SELECT 'Total products' measure_name, COUNT(DISTINCT product_number) measure_value FROM dim_products
UNION ALL
SELECT 'Total customers' measure_name, COUNT(DISTINCT customer_number) measure_value FROM dim_customers;

-- 2. Customer Distribution by Country
SELECT
	country,
    COUNT(customer_id) total_customers
FROM dim_customers
GROUP BY country;

-- 3. Customer Distribution by Gender
SELECT 
	Gender,
    COUNT(customer_id) total_customers
FROM dim_customers
GROUP BY Gender;

-- 4. Product Distribution by Category
SELECT 
	COALESCE(category, 'Unknown') category,
    COUNT(product_key) total_products
FROM dim_products
GROUP BY category;

-- 5. Average Product Cost by Category
SELECT 
	COALESCE(category, 'Unknown') category,
    CAST(AVG(cost) AS SIGNED) average_cost
FROM dim_products
GROUP BY category;

-- 6. Total Revenue by Product Category
SELECT 
	p.category category,
    SUM(f.sales_amount)total_revenue
FROM fact_sales f
LEFT JOIN dim_products p
ON p.product_key = f.product_key
GROUP BY p.category;

-- 7. Customer Ranking by Revenue
SELECT 
    CONCAT(c.firs_tname, ' ', c.last_name) customer_name,
    SUM(sales_amount) total_revenue
FROM fact_sales f
LEFT JOIN dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.firs_tname, c.last_name
ORDER BY total_revenue DESC;

-- 8. Total Items Sold by Customer Country
SELECT 
    c.country country,
    SUM(f.quantity) total_sold_items
FROM fact_sales f
LEFT JOIN dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;

-- 9. Top Five Products by Revenue
SELECT
p.product_name,
SUM(f.sales_amount) total_revenue
FROM fact_sales f
LEFT JOIN dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- 10. Bottom Five Products by Revenue
SELECT
p.product_name,
SUM(f.sales_amount) total_revenue
FROM fact_sales f
LEFT JOIN dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue 
LIMIT 5;

-- 11. Top Ten Customers by Revenue
SELECT
	CONCAT(c.firs_tname, " ", c.last_name) customer_name,
    SUM(f.sales_amount) total_revenue
FROM fact_sales f
LEFT JOIN dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.firs_tname, c.last_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 12. Customers with three or less then three orders
WITH customers AS(
	SELECT
		CONCAT(c.firs_tname, " ", c.last_name) customer_name,
		COUNT(f.order_number) total_orders
	FROM fact_sales f
	LEFT JOIN dim_customers c
	ON c.customer_key = f.customer_key
	GROUP BY c.customer_key, c.firs_tname, c.last_name
	ORDER BY total_orders)
SELECT
		customer_name,
        total_orders
FROM(
	SELECT 
		customer_name,
		total_orders,
		DENSE_RANK() OVER(ORDER BY total_orders) ranking
	FROM customers)t
WHERE ranking <=3;
