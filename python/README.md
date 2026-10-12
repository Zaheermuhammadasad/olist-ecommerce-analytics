# Python Analytics

## Setup

From the repository root:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install -r python/requirements.txt
python python/olist_analysis.py
```

On Windows activate using `.venv\\Scripts\\activate`.

Put the nine Olist CSVs in `data/` with their original filenames. Raw data is excluded from GitHub because of repository size limits. The full project ZIP supplied alongside this repository contains a local copy of the data and generated outputs.

The script exports data-quality checks, monthly GMV/AOV, category and seller performance, customer value, payment mix, delivery KPIs, state-level delivery metrics, delay buckets, review-vs-delivery summary and PNG charts into `outputs/`.

Metric safeguards: distinct order counting, item-price GMV excluding freight, review aggregation to order grain, and explicit delivery eligibility filters.
