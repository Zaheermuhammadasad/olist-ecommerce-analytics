-- 03_customer_analysis.sql
USE olist_ecommerce;

-- Customer value, person-level repeat behavior; GMV excludes freight.
WITH order_value AS (
  SELECT o.order_id, c.customer_unique_id, SUM(oi.price) AS order_gmv
  FROM olist_orders_dataset o
  JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
  LEFT JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
  GROUP BY o.order_id, c.customer_unique_id
), customer_value AS (
  SELECT customer_unique_id, COUNT(DISTINCT order_id) AS orders,
         SUM(COALESCE(order_gmv, 0)) AS lifetime_gmv
  FROM order_value GROUP BY customer_unique_id
)
SELECT COUNT(*) AS unique_customers,
       SUM(orders > 1) AS repeat_customers,
       ROUND(100.0 * SUM(orders > 1) / COUNT(*), 2) AS repeat_customer_pct,
       ROUND(AVG(lifetime_gmv), 2) AS avg_customer_gmv
FROM customer_value;

-- Top 20 customer identities by lifetime GMV
WITH order_value AS (
  SELECT o.order_id, c.customer_unique_id, SUM(oi.price) AS order_gmv
  FROM olist_orders_dataset o
  JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
  LEFT JOIN olist_order_items_dataset oi ON o.order_id = oi.order_id
  GROUP BY o.order_id, c.customer_unique_id
)
SELECT customer_unique_id, COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(COALESCE(order_gmv, 0)), 2) AS lifetime_gmv
FROM order_value GROUP BY customer_unique_id
ORDER BY lifetime_gmv DESC LIMIT 20;
