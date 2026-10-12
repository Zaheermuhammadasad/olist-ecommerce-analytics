# Business Insights — Olist E-Commerce

These findings were calculated from the supplied Olist CSV files using a reproducible Pandas workflow. They are descriptive, not causal.

## 1. Late delivery increased over the observed years

**Finding:** Late delivery rates for eligible delivered orders were 1.50% in 2016, 6.63% in 2017, and 9.37% in 2018.

**Evidence:** 4/267 eligible delivered orders were late in 2016; 2,878/43,426 in 2017; and 4,944/52,777 in 2018. Overall, 7,826/96,470 were late (8.11%).

**Implication:** The delivery experience became less reliable over the period with the largest order volume; these data alone do not identify the cause.

**Recommendation:** Monitor late rate and absolute late-order volume by month, customer state and seller. Investigate promise accuracy and carrier performance.

## 2. Late deliveries are associated with lower review scores

**Finding:** Late-delivered orders had a lower average review score than on-time/early deliveries.

**Evidence:** Average review score was 4.294 for 88,163 on-time/early reviewed eligible orders and 2.567 for 7,661 late reviewed eligible orders.

**Implication:** Timeliness and satisfaction are associated; this comparison does not prove that lateness alone caused the rating difference.

**Recommendation:** Test proactive communication and at-risk shipment interventions and measure changes in late rate and satisfaction.

## 3. Delivery risk differs by customer state

**Evidence:** Among states with at least 100 eligible delivered orders, AL had 23.93% late (95/397), MA 19.67% (141/717), PI 15.97% (76/476), CE 15.32% (196/1,279), and BA 14.04% (457/3,256), compared with 8.11% overall.

**Implication:** A nationwide average hides geographic variation.

**Recommendation:** Investigate routes, seller/carrier coverage and promised delivery dates for the highest-risk states; use minimum-volume thresholds.

## 4. Health & Beauty and Watches & Gifts lead category GMV

**Evidence:** Item-price GMV was approximately 1.259 million for health_beauty, 1.205 million for watches_gifts, and 1.037 million for bed_bath_table. Freight is excluded.

**Implication:** Category revenue concentration may guide merchandising, but GMV is not profit or marketing return.

**Recommendation:** Compare category GMV with contribution margin, marketing cost and returns before reallocating spend.

## 5. Credit cards dominate payment value

**Evidence:** Credit-card payment value totalled approximately 12.542 million across 76,505 distinct orders; boleto totalled approximately 2.869 million across 19,784 orders.

**Implication:** Payment preference and installments matter to checkout; payment record value is not directly interchangeable with item-price GMV.

**Recommendation:** Monitor conversion and payment failure rates by type and evaluate installment use alongside basket size and margin.

## Data-quality caveats

- 99,441 order rows and 99,441 unique order IDs.
- 112,650 item rows and 112,650 unique (order_id, order_item_id) keys.
- Delivery KPI eligibility requires delivered status and non-null actual and estimated timestamps. It has 96,470 eligible orders; eight rows marked delivered lack an actual delivery date and are excluded.
- Delay is actual delivery timestamp minus estimated delivery timestamp; strictly positive means late.
- Reviews are averaged per order before comparing delivery performance.
