USE capstone;
SELECT*FROM customers;
SELECT*FROM products;
SELECT*FROM orders;
SELECT*FROM order_items;
SELECT*FROM fact_sales;

-- CHECK NULLS DATA
SELECT
SUM(customer_id IS NULL) AS customer_id__nulls, 
SUM(customer_name IS NULL) AS customer_name_nulls, 
SUM(segment IS NULL) AS segment_nulls, 
SUM(region IS NULL) AS region_nulls,
SUM(state IS NULL) AS state_nulls,
SUM(city IS NULL) AS city_nulls, 
SUM(signup_date IS NULL) AS signup_date_nulls
FROM customers;

SELECT
SUM(order_id IS NULL) AS order_id_nulls,
SUM(order_date IS NULL) AS order_date_nulls,
SUM(ship_date IS NULL) AS ship_date_nulls,
SUM(ship_mode IS NULL) AS ship_mode_nulls,
SUM(channel IS NULL) AS channel_nulls,
SUM(customer_id IS NULL) AS customer_id_nulls,
SUM(region IS NULL) AS region_nulls,
SUM(state IS NULL) AS state_nulls,
SUM(city IS NULL) AS city_nulls,
SUM(segment IS NULL) AS segment_nulls
FROM orders;


SELECT
SUM(order_item_id IS NULL) AS order_item_id_nulls,
SUM(order_id IS NULL) AS order_id_nulls,
SUM(product_id IS NULL) AS product_id_nulls,
SUM(quantity IS NULL) AS quantity_nulls,
SUM(discount IS NULL) AS discount_nulls,
SUM(sales IS NULL) AS sales_nulls,
SUM(shipping_cost IS NULL) AS shipping_cost_nulls,
SUM(cogs IS NULL) AS cogs_nulls,
SUM(profit IS NULL) AS profit_nulls,
SUM(returned IS NULL) AS returned_nulls
FROM order_items;


SELECT
SUM(product_id IS NULL) AS product_id_nulls,
SUM(sku IS NULL) AS sku_nulls,
SUM(brand IS NULL) AS brand_nulls,
SUM(category IS NULL) AS category_nulls,
SUM(sub_category IS NULL) AS dsub_category_nulls,
SUM(list_price IS NULL) AS list_price_nulls,
SUM(unit_cost IS NULL) AS unit_cost_nulls
FROM products;

-- CHECK DUPLICATES 
SELECT customer_id,COUNT(*) AS cnt
FROM customers
GROUP BY customer_id
HAVING COUNT(*)>1;

SELECT order_id,COUNT(*) AS cnt
FROM orders
GROUP BY order_id
HAVING COUNT(*)>1;

SELECT order_item_id,COUNT(*) AS cnt
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*)>1;


SELECT product_id,COUNT(*) AS cnt
FROM products
GROUP BY product_id
HAVING COUNT(*)>1;

-- DATA PROFILING - ROW COUNTS 
SELECT'customers't,COUNT(*)n FROM customers
UNION ALL SELECT'products',COUNT(*) FROM products
UNION ALL SELECT'orders',COUNT(*) FROM orders
UNION ALL SELECT'order_items',COUNT(*) FROM order_items
UNION ALL SELECT'fact_sales',COUNT(*) FROM fact_sales;

-- ENABLE SAFE MODE 
SET SQL_SAFE_UPDATES=0;

-- FIX CASING & SPACES-UPPERCASE + TRIMMING 
UPDATE customers
SET customer_name=UPPER(TRIM(customer_name))
WHERE customer_name IS NOT NULL;

UPDATE products
SET brand=UPPER(TRIM(brand)),
category=UPPER(TRIM(category)),
sub_category=UPPER(TRIM(sub_category))
WHERE brand IS NOT NULL; 


--  DUPLICATE SKUS IN PRODUCTS
SELECT sku,COUNT(*) cnt
FROM products
GROUP BY sku
HAVING COUNT(*)>1
ORDER BY cnt DESC;

-- CORE KPIS: TOTAL SALES,PROFIT,MARGIN 
SELECT 
ROUND(SUM(sales),2) AS total_sales,
ROUND(SUM(profit),2) AS total_profit,
ROUND(SUM(profit)/NULLIF(SUM(sales),0),4) AS profit_Margin
FROM fact_sales;

-- MONTHLY SALES TREND
SELECT
DATE_FORMAT(order_date,'%Y-%m') AS month,
ROUND(SUM(sales),2) AS sales
FROM fact_sales
GROUP BY DATE_FORMAT(order_date,'%Y-%m')
ORDER BY month;


-- REGION WISE PERFORMANCE
SELECT 
 region,
 ROUND(SUM(sales),2) As sales,
 ROUND(sum(profit),2) As profit,
 ROUND(sum(profit)/Nullif(sum(sales),0),4) As margin
 FROM fact_sales
 GROUP BY region
 ORDER BY sales DESC;
 
 -- TOP 10 CUSTOMERS
 SELECT customer_id,customer_name,
 ROUND(SUM(sales),2) As total_sales,
 ROUND(sum(profit),2) As total_profit
 FROM fact_sales
 GROUP BY customer_id,customer_name
 ORDER BY total_sales DESC
 LIMIT 10;
 
  -- TOP 10 PRODUCTS
   SELECT product_id,sku,brand,category,sub_category,
 ROUND(SUM(sales),2) As total_sales,
 ROUND(sum(profit),2) As total_profit
 FROM fact_sales
 GROUP BY product_id,sku,brand,category,sub_category
 ORDER BY total_sales DESC
 LIMIT 10;

 






