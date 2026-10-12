-- 05_payment_review_analysis.sql
USE olist_ecommerce;

-- Payments are record-level; one order can have multiple payment rows.
SELECT payment_type, COUNT(*) AS payment_records,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(payment_value), 2) AS total_payment_value,
       ROUND(AVG(payment_installments), 2) AS avg_installments
FROM olist_order_payments_dataset
GROUP BY payment_type ORDER BY total_payment_value DESC;

-- Review score distribution
SELECT review_score, COUNT(*) AS review_records,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM olist_order_reviews_dataset), 2) AS pct_reviews
FROM olist_order_reviews_dataset
GROUP BY review_score ORDER BY review_score;

-- Aggregate reviews to order grain before joining delivery metrics.
WITH order_review AS (
 SELECT order_id, AVG(review_score) AS avg_review_score
 FROM olist_order_reviews_dataset GROUP BY order_id
), delivery AS (
 SELECT order_id,
        DATEDIFF(order_delivered_customer_date, order_estimated_delivery_date) AS delay_days
 FROM olist_orders_dataset
 WHERE order_status = 'delivered'
   AND order_delivered_customer_date IS NOT NULL
   AND order_estimated_delivery_date IS NOT NULL
)
SELECT CASE WHEN d.delay_days > 0 THEN 'Late' ELSE 'On time or early' END AS delivery_group,
       COUNT(*) AS orders, ROUND(AVG(r.avg_review_score), 2) AS avg_review_score
FROM delivery d JOIN order_review r ON d.order_id = r.order_id
GROUP BY delivery_group;
