# BI Dashboard Specification

## Page 1 — Executive Overview

KPI cards: total orders, GMV, average order value, unique customers, average review score and late-delivery rate.

Visuals: monthly orders/GMV trend, order-status distribution and geographic order concentration.

## Page 2 — Sales & Products

- Monthly GMV trend
- Top product categories by GMV
- Top sellers by GMV
- Orders vs average order value
- Category share of GMV

## Page 3 — Customers & Payments

- One-time vs repeat customers
- Customer order-frequency distribution
- Top customers by GMV
- Payment-method mix
- Installment distribution

## Page 4 — Operations & Customer Experience

- On-time vs late delivery
- Delay-bucket distribution
- Late-delivery rate by customer state
- Average review score: on-time vs late
- Average review score by delay bucket

## KPI Definitions

**GMV:** Sum of `price + freight_value` across order items.

**AOV:** GMV divided by distinct orders included in the analysis.

**Late delivery:** `order_delivered_customer_date > order_estimated_delivery_date`.

**Repeat customer:** A `customer_unique_id` with more than one distinct order.

**Average review score:** Mean review score at order level. If multiple review rows exist, aggregate to one order-level score before joining to delivery data.

## Design Principle

Keep the dashboard decision-oriented. Every visual should answer a business question; avoid decorative charts that do not change a decision.
