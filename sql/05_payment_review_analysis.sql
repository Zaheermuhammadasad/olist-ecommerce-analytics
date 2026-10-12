-- Olist E-Commerce Analytics
-- 05 - Payments & Customer Satisfaction
-- MySQL 8+

USE olist_ecommerce;

-- 1. Payment method mix
SELECT
    payment_type,
    COUNT(*) AS payment_records,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(payment_value), 2) AS payment_value,
    ROUND(AVG(payment_installments), 2) AS avg_installments
FROM order_payments
GROUP BY payment_type
ORDER BY payment_value DESC;

-- 2. Installment distribution
SELECT
    payment_installments,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(payment_value), 2) AS payment_value
FROM order_payments
WHERE payment_type <> 'not_defined'
GROUP BY payment_installments
ORDER BY payment_installments;

-- 3. Review-score distribution
SELECT
    review_score,
    COUNT(*) AS reviews,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;

-- 4. Delivery delay vs review score
WITH delivery AS (
    SELECT
        order_id,
        CASE
            WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late'
            ELSE 'On time or early'
        END AS delivery_status
    FROM orders
    WHERE order_status = 'delivered'
      AND order_delivered_customer_date IS NOT NULL
      AND order_estimated_delivery_date IS NOT NULL
), review_per_order AS (
    SELECT order_id, AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    d.delivery_status,
    COUNT(*) AS orders_with_review,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM delivery d
JOIN review_per_order r ON r.order_id = d.order_id
GROUP BY d.delivery_status;

-- 5. Review score by delivery delay bucket
WITH base AS (
    SELECT
        o.order_id,
        CASE
            WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) <= 0 THEN 'On time or early'
            WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) BETWEEN 1 AND 7 THEN '1-7 days late'
            WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) BETWEEN 8 AND 14 THEN '8-14 days late'
            WHEN DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) BETWEEN 15 AND 30 THEN '15-30 days late'
            ELSE 'More than 30 days late'
        END AS delay_bucket
    FROM orders o
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
      AND o.order_estimated_delivery_date IS NOT NULL
), reviews AS (
    SELECT order_id, AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    b.delay_bucket,
    COUNT(*) AS reviewed_orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM base b
JOIN reviews r ON r.order_id = b.order_id
GROUP BY b.delay_bucket
ORDER BY FIELD(b.delay_bucket, 'On time or early', '1-7 days late', '8-14 days late', '15-30 days late', 'More than 30 days late');
