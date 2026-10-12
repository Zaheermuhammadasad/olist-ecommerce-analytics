# Business Insights

This file records evidence-based findings. Results must be generated from the loaded Olist data and the SQL/Python scripts; no unsupported metrics are hard-coded.

## Finding 1 — Delivery reliability is a material operational KPI

**Finding:** Delivery performance should be monitored by year, state and delay severity.

**Evidence:** `sql/04_delivery_analysis.sql` calculates on-time/late performance, yearly late rate, delay buckets and state-level late rates.

**Business implication:** A single national delivery KPI can hide regional operational risk.

**Recommendation:** Use state-level late-delivery rate and severe-delay share to prioritise logistics investigation.

## Finding 2 — Delivery experience should be linked to customer satisfaction

**Finding:** Delivery delay and review score should be analysed together rather than in isolation.

**Evidence:** `sql/05_payment_review_analysis.sql` joins delivery status to order-level review scores and also compares review scores across delay buckets.

**Business implication:** If delayed orders show materially lower reviews, delivery reliability is also a customer-experience issue.

**Recommendation:** Set an operational target for on-time delivery and monitor review impact alongside it.

## Finding 3 — One-to-many joins require explicit grain control

**Finding:** Order-level KPIs can be inflated when orders are joined directly to order items, payments or reviews.

**Evidence:** The SQL scripts aggregate one-to-many tables before calculating order-level KPIs where appropriate.

**Business implication:** Incorrect join grain can produce misleading GMV, order and customer metrics.

**Recommendation:** Define the grain of every KPI before building the dashboard.

## Findings to Populate After Full Dataset Load

- Highest-GMV categories
- Highest-GMV sellers
- Monthly GMV growth and seasonality
- Repeat-customer rate
- Highest-value customer segments
- Payment-method and installment patterns
- Review-score distribution
- Quantified relationship between delivery delay and review score

Use the format **Finding → Evidence → Business Implication → Recommendation** for each final finding.
