# Python Analytics

## Setup

Download the required Olist source CSVs, then place these eight files in `python/data/`: orders, customers, order items, products, sellers, payments, reviews, and product category translations. The geolocation file is not used by the current script because repeated ZIP prefixes need aggregation before mapping.

From the repository root:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r python/requirements.txt
python python/olist_analysis.py
```

On Windows activate with `.venv\\Scripts\\activate`.

The script writes data-quality summaries, monthly GMV/AOV, category and seller performance, customer value, payment mix, delivery KPIs, state-level delivery metrics, delay buckets, delivery-vs-review summary and PNG charts into `python/outputs/`.

Metric safeguards: orders are counted distinctly, item-price GMV excludes freight, reviews are aggregated to order grain before joining, and delivery eligibility filters are explicit.
