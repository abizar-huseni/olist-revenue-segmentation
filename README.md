# Olist E-Commerce: Revenue & Customer Segmentation Analysis

## Problem Statement
Olist, a Brazilian e-commerce marketplace, processes over 100K orders across thousands of sellers. This project analyses 96,478 delivered orders to answer: **Who are Olist's most valuable customers and which segments drive the most revenue?**

## Dataset
- **Source:** [Olist Brazilian E-Commerce Dataset (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
- 9 relational tables, 100K+ orders from 2016-2018
- Analysis period trimmed to January 2017 – August 2018

## Methodology
1. **Data Cleaning (SQL Server):** Standardised table names, verified primary keys, checked for NULLs, filtered to delivered orders only
2. **Revenue Analysis (SQL):** Analysed revenue by time period, customer state, product category, and payment method
3. **RFM Segmentation (Python):** Scored 93,104 unique customers on Recency, Frequency, and Monetary value, then mapped to 8 business segments
4. **Dashboard (Power BI):** Built interactive visualisations of revenue and segment distributions

## Key Findings
- **97% of customers are one-time buyers** — only 2.7% return for a second order
- **São Paulo accounts for 37% of all revenue** (R$5.76M) — heavy geographic concentration creates business risk
- **"Can't Lose Them" segment drives 20.7% of revenue** but these high-value customers are becoming inactive
- **Champions have the highest average spend (R$312)** but represent only 7% of the customer base
- **November 2017 was the peak revenue month** (R$1.15M) driven by Black Friday — 2018 revenue plateaued around R$1M/month

## Tools Used
- **SQL Server 2022** — data cleaning, schema design, revenue analysis
- **Python** (pandas, matplotlib) — RFM segmentation and visualisation
- **Power BI** — interactive dashboard
- **Git/GitHub** — version control

## Repository Structure

olist-revenue-segmentation/
├── data/
│ ├── raw/ # Original CSVs (gitignored)
│ └── processed/ # RFM segments CSV
├── notebooks/
│ └── 01_rfm_segmentation.ipynb
├── sql/
│ ├── 00_table_setup.sql
│ ├── 01_data_quality_checks.sql
│ └── 02_revenue_analysis.sql
├── outputs/
│ └── olist_segmentation_dashboard.pbix
├── README.md
├── .gitignore
└── requirements.txt


## How to Reproduce
1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
2. Load CSVs into SQL Server and run `sql/00_table_setup.sql`
3. Run data quality checks with `sql/01_data_quality_checks.sql`
4. Run revenue analysis queries with `sql/02_revenue_analysis.sql`
5. Open `notebooks/01_rfm_segmentation.ipynb` and run all cells
6. Open `outputs/olist_segmentation_dashboard.pbix` in Power BI

## Author
**Abizar Huseni** — MSc Business Analytics, Aston University, Birmingham, UK
