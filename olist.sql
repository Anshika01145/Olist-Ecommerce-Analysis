CREATE VIEW v_order_revenue AS
SELECT
  order_id,
  SUM(price) AS total_revenue
FROM order_items
GROUP BY order_id;
USE olist;
SHOW TABLES;
show tables;
CREATE VIEW olist.v_order_revenue AS
SELECT
  order_id,
  SUM(price) AS total_revenue
FROM olist.order_items
GROUP BY order_id;
CREATE VIEW v_order_revenue AS
SELECT
  order_id,
  SUM(price) AS total_revenue
FROM olist_order_items_dataset
GROUP BY order_id;
SHOW DATABASES;
CREATE OR REPLACE VIEW v_order_review AS
SELECT
  order_id,
  AVG(review_score) AS avg_review_score
FROM olist_order_reviews_dataset
GROUP BY order_id;
CREATE OR REPLACE VIEW v_order_review AS
SELECT
  order_id,
  AVG(review_score) AS avg_review_score
FROM olist_order_reviews_dataset
GROUP BY order_id;
CREATE OR REPLACE VIEW v_order_master AS
SELECT
  o.order_id,
  c.customer_unique_id,
  c.customer_state,
  o.order_purchase_timestamp,
  DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_days,
  DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days,
  r.total_revenue,
  rv.avg_review_score
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
  ON c.customer_id = o.customer_id
LEFT JOIN v_order_revenue r
  ON r.order_id = o.order_id
LEFT JOIN v_order_review rv
  ON rv.order_id = o.order_id;
SELECT
  COUNT(DISTINCT order_id) AS total_orders,
  ROUND(SUM(total_revenue),2) AS total_revenue,
  ROUND(AVG(total_revenue),2) AS avg_order_value
FROM v_order_master;
CREATE OR REPLACE VIEW v_order_master AS
SELECT
  o.order_id,
  c.customer_unique_id,
  c.customer_state,
  o.order_purchase_timestamp,
  DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp) AS delivery_days,
  DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days,
  r.total_revenue,
  rv.avg_review_score
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
  ON c.customer_id = o.customer_id
LEFT JOIN v_order_revenue r
  ON r.order_id = o.order_id
LEFT JOIN v_order_review rv
  ON rv.order_id = o.order_id;
SELECT
  DATE_FORMAT(order_purchase_timestamp,'%Y-%m') AS month,
  ROUND(SUM(total_revenue),2) AS revenue
FROM v_order_master
GROUP BY month
ORDER BY month;
WITH customer_orders AS (
  SELECT customer_unique_id, COUNT(DISTINCT order_id) AS order_count
  FROM v_order_master
  GROUP BY customer_unique_id
)
SELECT
  ROUND(SUM(order_count > 1) / COUNT(*) * 100, 2) AS repeat_customer_percentage
FROM customer_orders;
SELECT
  CASE
    WHEN delay_days IS NULL THEN 'No Delivery Date'
    WHEN delay_days <= 0 THEN 'On Time'
    WHEN delay_days BETWEEN 1 AND 3 THEN '1-3 Days Late'
    ELSE '3+ Days Late'
  END AS delay_category,
  COUNT(*) AS orders,
  ROUND(AVG(avg_review_score),2) AS avg_rating
FROM v_order_master
WHERE avg_review_score IS NOT NULL
GROUP BY delay_category
ORDER BY orders DESC;
SELECT
  p.product_category_name,
  ROUND(SUM(oi.price),2) AS revenue,
  COUNT(*) AS items_sold
FROM olist_order_items_dataset oi
LEFT JOIN olist_products_dataset p
  ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;
SELECT
  p.product_category_name,
  ROUND(SUM(oi.price),2) AS revenue,
  COUNT(*) AS items_sold
FROM olist_order_items_dataset oi
LEFT JOIN olist_products_dataset p
  ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;
SELECT
  p.product_category_name,
  ROUND(SUM(oi.price),2) AS revenue,
  COUNT(*) AS items_sold
FROM olist_order_items_dataset oi
LEFT JOIN olist_products_dataset p
  ON p.product_id = oi.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;
FROM newschema.olist_order_items_dataset
SELECT
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT customer_unique_id) AS total_customers,
  ROUND(SUM(total_revenue),2) AS total_revenue,
  ROUND(AVG(total_revenue),2) AS avg_order_value,
  ROUND(AVG(delivery_days),2) AS avg_delivery_days,
  ROUND(AVG(delay_days > 0)*100,2) AS delay_rate_pct,
  ROUND(AVG(avg_review_score),2) AS avg_rating
FROM v_order_master;
SELECT DATABASE();
SHOW TABLES;




