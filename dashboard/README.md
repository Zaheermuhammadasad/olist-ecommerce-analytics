# BI Dashboard Specification

This document specifies the report design and KPI definitions. Build the native report in Power BI Desktop or Tableau; generated CSVs and charts are included in the downloadable project ZIP.

## Page 1 — Executive Overview

KPI cards: orders, item-price GMV, AOV, delivered orders, late-delivery rate and average review score. Charts: monthly GMV, order status and yearly delivery performance.

## Page 2 — Sales & Products

Top categories by GMV, monthly GMV and order volume, top sellers by GMV, category orders versus GMV. Slicers: purchase month, category and seller state.

## Page 3 — Customers & Payments

One-time versus repeat customers, customer lifetime GMV distribution, payment value by type and installments. Use `customer_unique_id` for person-level repeat metrics.

## Page 4 — Operations & Customer Experience

Late-delivery rate by customer state (with volume), delay buckets, yearly delivery trend and average review score for late versus on-time/early deliveries.

## KPI definitions

| KPI | Definition | Caution |
|---|---|---|
| Orders | Distinct order IDs | Do not use item rows as orders |
| GMV | Sum of item price | Freight excluded; not profit |
| AOV | GMV / distinct orders | Keep population consistent |
| Eligible delivered orders | Delivered status plus both actual and estimated timestamps | Eight delivered-status rows lack actual dates |
| Late-delivery rate | Late / eligible delivered orders | Actual must be strictly later than estimate |
| Average review score | Average review score | Aggregate review rows to order grain before joining |
| Repeat customer | More than one order by a person key | Use customer_unique_id |

## Relationships

Orders to order items by order_id; customers to orders by customer_id; products and sellers to order items by their IDs; orders to payments and reviews by order_id. Aggregate geolocation before using it because ZIP prefixes repeat.

## Validation

Validate order, GMV and delivery totals against the Python outputs. Annotate the order-status population and eligibility filters used in each visual.
