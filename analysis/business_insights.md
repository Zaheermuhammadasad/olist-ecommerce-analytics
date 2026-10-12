# Business Insights — Olist E-Commerce

The results below were calculated from the supplied Olist CSV files. They are descriptive, not causal. The reproducible calculation script and exported tables are in the Python folder and project ZIP.

## 1. Late delivery rate increased over the observed years

**Finding:** Late delivery rates for eligible delivered orders were 1.50% in 2016, 6.63% in 2017, and 9.37% in 2018.

**Evidence:** 4/267 eligible delivered orders were late in 2016; 2,878/43,426 in 2017; and 4,944/52,777 in 2018. Overall, 7,826/96,470 were late (8.11%).

**Implication:** The delivery experience became less reliable across the period with the largest order volume; these data alone do not identify the cause.

**Recommendation:** Monitor late rate and absolute late-order volume together by month, customer state and seller; investigate shipping promises and carrier performance.

## 2. Late deliveries are associated with lower review scores

**Finding:** Late-delivered orders had a much lower average review score than on-time/early deliveries.

**Evidence:** Average review score was 4.294 for 88,163 on-time/early reviewed eligible orders and 2.567 for 7,661 late reviewed eligible orders.

**Implication:** Delivery timeliness and satisfaction are associated, but this comparison does not prove lateness alone caused lower ratings.

**Recommendation:** Test proactive communication and at-risk shipment interventions; measure their effect on lateness and satisfaction.

## 3. Delivery risk differs by customer state

**Evidence:** Among states with at least 100 eligible delivered orders, AL had 23.93% late (95/397), MA 19.67% (141/717), PI 15.97% (76/476), CE 15.32% (196/1,279), and BA 14.04% (457/3,256), compared with 8.11% overall.

**Implication:** A national average masks geographic variation.

**Recommendation:** Investigate routes, seller/carrier coverage and estimated delivery promise accuracy in the highest-risk states; use minimum-volume thresholds.

## 4. Health & Beauty and Watches & Gifts lead category GMV

**Evidence:** Item-price GMV was approximately 1.259 million for health_beauty, 1.205 million for watches_gifts, and 1.037 million for bed_bath_table. Freight is excluded.

**Implication:** Category sales concentration can guide merchandising, but GMV does not represent profit or marketing return.

**Recommendation:** Compare GMV against contribution margin, campaign cost and returns before changing spend.

## 5. Credit cards dominate payment value

**Evidence:** Credit-card payment value totalled approximately 12.542 million across 76,505 distinct orders; boleto totalled approximately 2.869 million across 19,784 orders.

**Implication:** Payment mix and installments matter to checkout design. Payment record value is not the same metric as item-price GMV.

**Recommendation:** Monitor conversion and payment failure rates by type, and evaluate installment use alongside margin and basket size.

## Data-quality caveats

- 99,441 order rows and 99,441 distinct order IDs.
- 112,650 order-item rows and 112,650 unique (order_id, order_item_id) keys.
- Delivery KPI eligibility requires delivered status and non-null actual and estimated timestamps. There are 96,470 eligible orders; eight delivered-status rows lack an actual delivery date and are excluded.
- Delay is actual delivery timestamp minus estimated timestamp; strictly positive means late.
- Reviews are averaged per order before comparing with delivery data.
