# Python Analysis

## Setup

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

On Windows, activate the environment with `.venv\\Scripts\\activate`.

## Data

Create a local `data/` directory and place the public Olist CSV files inside it. Raw data is not committed to this repository.

## Run

```bash
python olist_analysis.py
```

The script creates an `output/` directory containing data-quality, delivery, monthly-order and customer KPI tables.

## Why Python is included

SQL is used for relational analysis and reproducible business queries. Python is used for profiling, validation, transformation and export of analysis-ready outputs. The two layers should produce consistent KPI definitions.
