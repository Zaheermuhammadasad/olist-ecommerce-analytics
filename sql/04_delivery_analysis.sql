-- 04_delivery_analysis.sql
USE olist_ecommerce;

-- Strict eligibility: delivered status and both actual and estimated dates available.
WITH delivery AS (
  SELECT order_id,
         DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) AS delay_days,
         DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS delivery_days
  FROM olist_orders_dataset
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
)
SELECT COUNT(*) AS eligible_delivered_orders,
       SUM(delay_days > 0) AS late_orders,
       SUM(delay_days <= 0) AS on_time_or_early_orders,
       ROUND(100.0 * SUM(delay_days > 0) / COUNT(*), 2) AS late_delivery_pct,
       ROUND(AVG(delay_days), 2) AS avg_days_vs_estimated,
       ROUND(AVG(delivery_days), 2) AS avg_days_to_customer
FROM delivery;

-- Late delivery by customer state; require at least 100 eligible orders.
WITH delivery AS (
  SELECT o.order_id, c.customer_state,
         DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delay_days
  FROM olist_orders_dataset o
  JOIN olist_customers_dataset c ON o.customer_id = c.customer_id
  WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
    AND o.order_estimated_delivery_date IS NOT NULL
)
SELECT customer_state, COUNT(*) AS delivered_orders,
       SUM(delay_days > 0) AS late_orders,
       ROUND(100.0 * SUM(delay_days > 0) / COUNT(*), 2) AS late_pct
FROM delivery GROUP BY customer_state
HAVING COUNT(*) >= 100 ORDER BY late_pct DESC;

-- Mutually exclusive delivery-delay buckets
WITH delivery AS (
  SELECT DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) AS delay_days
  FROM olist_orders_dataset
  WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL
    AND order_estimated_delivery_date IS NOT NULL
)
SELECT CASE
 WHEN delay_days <= 0 THEN 'On time or early'
 WHEN delay_days BETWEEN 1 AND 7 THEN '1-7 days late'
 WHEN delay_days BETWEEN 8 AND 14 THEN '8-14 days late'
 WHEN delay_days BETWEEN 15 AND 30 THEN '15-30 days late'
 ELSE 'More than 30 days late' END AS delay_bucket,
 COUNT(*) AS orders
FROM delivery GROUP BY delay_bucket ORDER BY MIN(delay_days);

-- Year-over-year delivery performance
WITH delivery AS (
 SELECT YEAR(order_purchase_timestamp) AS purchase_year,
        DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) AS delay_days,
        DATEDIFF(order_delivered_customer_date, order_purchase_timestamp) AS delivery_days
 FROM olist_orders_dataset
 WHERE order_status = 'delivered'
   AND order_delivered_customer_date IS NOT NULL
   AND order_estimated_delivery_date IS NOT NULL
)
SELECT purchase_year, COUNT(*) AS delivered_orders,
       SUM(delay_days > 0) AS late_orders,
       ROUND(100.0 * SUM(delay_days > 0) / COUNT(*), 2) AS late_pct,
       ROUND(AVG(delay_days), 2) AS avg_days_vs_estimated,
       ROUND(AVG(delivery_days), 2) AS avg_delivery_days
FROM delivery GROUP BY purchase_year ORDER BY purchase_year;
