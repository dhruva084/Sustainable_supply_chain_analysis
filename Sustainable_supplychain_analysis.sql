--Create Table for Orders.csv---
Create Table orders(
order_id VARCHAR(50) PRIMARY KEY,
order_status VARCHAR(30),
order_purchase_timestamp TIMESTAMP,
order_approved_at TIMESTAMP,
order_delivered_carrier_date TIMESTAMP,
order_delivered_customer_date TIMESTAMP,
order_estimated_delivery_date TIMESTAMP
);

ALTER Table orders
ADD COLUMN customer_id 

SELECT * FROM orders;

--Create Table for order_items.csv---
CREATE Table order_items(
order_id VARCHAR(50),
order_item_id INTEGER,
product_id VARCHAR(50),
seller_id VARCHAR(50),
shipping_limit_date TIMESTAMP,
price NUMERIC(10,2),
freight_value NUMERIC(10,2),
PRIMARY KEY(order_id, order_item_id),
FOREIGN KEY (order_id)
);
REFERENCES orders(order_id)

SELECT * FROM orders
WHERE order_status = 'delivered'
LIMIT 5;

SELECT * FROM orders
ORDER BY order_purchase_timestamp DESC 
LIMIT 5;

--Grouping different order statuses and displaying 
SELECT order_status, COUNT(*)
FROM orders
GROUP BY order_status
ORDER BY COUNT(*) DESC;

--Delivery time calculation and assigning null values in the end---
SELECT order_delivered_customer_date - order_purchase_timestamp AS Delivery_time
FROM orders 
WHERE order_status = 'delivered'
ORDER BY Delivery_time DESC NULLS last;

--Average delivery time calculation----
SELECT AVG(order_delivered_customer_date - order_purchase_timestamp) AS Average_delivery_time
FROM orders
WHERE order_status = 'delivered';

--Average delivery days calculation by converting the intervals to days using 86400 seconds----
SELECT AVG(EXTRACT(EPOCH FROM order_delivered_customer_date - order_purchase_timestamp)/86400.0) AS Average_delivery_days
FROM orders
WHERE order_status = 'delivered';

-- Total count of late orders----
SELECT COUNT(*) AS late_orders FROM orders
WHERE order_status = 'delivered' AND order_delivered_customer_date > order_estimated_delivery_date;

--Percentage of late deliveries with CAST() function to convert data type INTEGER to NUMERIC---
SELECT
CAST(
(SELECT COUNT(*) 
FROM orders
WHERE order_status = 'delivered' 
AND order_delivered_customer_date > order_estimated_delivery_date)
AS NUMERIC
)
/ 
(
SELECT COUNT(*)
FROM orders
WHERE order_status = 'delivered'
)* 100.0 AS late_delivery_rate;

--CREATE Products.csv Table---
CREATE table Products(
product_id VARCHAR(50) PRIMARY KEY,
product_category_english VARCHAR(150),
product_category_name VARCHAR(150)
);

SELECT COUNT(*) FROM products;

--Selects rows that have blank rows---
SELECT COUNT(*) AS Product_portuguese_NULL
FROM products
WHERE product_category_name = '';

--Updated products table where blank rows in product_category_name column are set to NULL string---
UPDATE products
SET product_category_name = NULL
WHERE product_category_name = '';


SELECT COUNT(*) AS Product_portuguese_NULL
FROM products
WHERE product_category_name IS NULL;

--Freight cost for each order item (matched records by product_id)---
SELECT freight_value, product_category_english
FROM order_items
INNER JOIN products
ON order_items.product_id = products.product_id;

--Count, SUM and Average freight cost for each product category---
SELECT 
product_category_english,
COUNT(*) AS order_item_count,
SUM(freight_value) AS Total_freight_cost,
AVG(freight_value) AS Average_freight_cost
FROM order_items
INNER JOIN products
ON order_items.product_id = products.product_id
GROUP BY product_category_english
ORDER BY Total_freight_cost DESC
LIMIT 5;

--Create Table for customer scores---
CREATE Table order_reviews(
review_id VARCHAR(50) PRIMARY KEY,
order_id VARCHAR(50), 
review_score INTEGER,
FOREIGN KEY(order_id)
REFERENCES orders(order_id)
);

SELECT COUNT(*)
FROM order_reviews;

--Dropped initial order_reviews table because review_id contained duplicate values---
DROP table order_reviews;

--Create table for order_reviews.csv but with newly generated column: review_record_id---
CREATE table order_reviews(
review_record_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
review_id VARCHAR(50),
order_id VARCHAR(50),
review_score INTEGER,
FOREIGN KEY(order_id)
REFERENCES orders(order_id)
);

SELECT * FROM order_reviews
LIMIT 5;

SELECT COUNT(*) AS total_reviews
FROM order_reviews;

--Count of Missing review scores--- 
SELECT COUNT(*) AS missing_review_scores
FROM order_reviews
WHERE review_score IS NULL;

--Match review records to an order---
SELECT COUNT(*) AS matched_reviews
FROM order_reviews
INNER JOIN orders
ON order_reviews.order_id = orders.order_id;

--Deliveries that are labelled late and on time ensuring a delivery date exists and is not NULL---
SELECT order_id, order_delivered_customer_date, order_estimated_delivery_date,
CASE
	WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late' 
	ELSE 'On Time'
END AS delivery_status
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL 
AND order_estimated_delivery_date IS NOT NULL;

--Average review scores by 'on time' and 'late' orders and no. of review records for each average---
SELECT AVG(order_reviews.review_score) AS average_review_score,
COUNT(*) AS review_count,
CASE
	WHEN orders.order_delivered_customer_date > orders.order_estimated_delivery_date 
	THEN 'Late' 
	ELSE 'On Time'
END AS delivery_status
FROM orders
INNER JOIN order_reviews
ON orders.order_id = order_reviews.order_id
WHERE orders.order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL 
AND order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_status;

--Checking unmatched records---
SELECT COUNT(*) AS unmatched_order_items
FROM order_items
LEFT JOIN products
ON order_items.product_id = products.product_id
WHERE products.product_id IS NULL;


SELECT COUNT(*) AS unmatched_orders
FROM order_items
LEFT JOIN orders
ON order_items.order_id = orders.order_id
WHERE orders.order_id IS NULL;

--Whether delivery orders have missing actual or estimated delivery dates---
SELECT 
COUNT(CASE
WHEN order_delivered_customer_date IS NULL THEN 1
END) AS missing_actual_dates,
COUNT(CASE
WHEN order_estimated_delivery_date IS NULL THEN 1
END) AS missing_estimated_dates
FROM orders
WHERE order_status = 'delivered';