# Olist E-Commerce: Revenue and Customer Segmentation Analysis

## Problem Statement
Olist, a Brazilian e commerce marketplace, processes over 100K orders across thousands of sellers. This project analyses 96,478 delivered orders to answer: who are Olist's most valuable customers, and which segments drive the most revenue?

## Dataset
Source: Olist Brazilian E Commerce Dataset (Kaggle), https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
It contains 9 relational tables and over 100K orders from 2016 to 2018.
The analysis period was trimmed to January 2017 through August 2018.

## Methodology
1. Data Cleaning (SQL Server): standardised table names, verified primary keys, checked for nulls, and filtered to delivered orders only.
2. Revenue Analysis (SQL): analysed revenue by time period, customer state, product category, and payment method.
3. RFM Segmentation (Python): scored 93,104 unique customers on recency, frequency, and monetary value, then mapped to 8 business segments.
4. Dashboard (Power BI): built interactive visualisations of revenue and segment distributions.

## Key Findings
1. 97% of customers are one time buyers; only 2.7% return for a second order.
2. São Paulo accounts for 37% of all revenue (R$5.76M), showing heavy geographic concentration and business risk.
3. The "Can't Lose Them" segment drives 20.7% of revenue, but these high value customers are becoming inactive.
4. Champions have the highest average spend (R$312) but represent only 7% of the customer base.
5. November 2017 was the peak revenue month (R$1.15M), driven by Black Friday; 2018 revenue plateaued around R$1M per month.

## Tools Used
1. SQL Server 2022: data cleaning, schema design, revenue analysis.
2. Python (pandas, matplotlib): RFM segmentation and visualisation.
3. Power BI: interactive dashboard.
4. Git and GitHub: version control.

## Repository Structure
The repository is organised as follows.

1. `data/raw` holds the original CSVs (gitignored).
2. `data/processed` holds the RFM segments CSV.
3. `notebooks` holds `01_rfm_segmentation.ipynb`.
4. `sql` holds `00_table_setup.sql`, `01_data_quality_checks.sql`, and `02_revenue_analysis.sql`.
5. `outputs` holds `olist_segmentation_dashboard.pbix`.
6. The root also includes `README.md`, `.gitignore`, and `requirements.txt`.

## How to Reproduce
1. Download the dataset from Kaggle.
2. Load the CSVs into SQL Server and run `sql/00_table_setup.sql`.
3. Run data quality checks with `sql/01_data_quality_checks.sql`.
4. Run revenue analysis queries with `sql/02_revenue_analysis.sql`.
5. Open `notebooks/01_rfm_segmentation.ipynb` and run all cells.
6. Open `outputs/olist_segmentation_dashboard.pbix` in Power BI.

## Author
Abizar Huseni, MSc Business Analytics, Aston University, Birmingham, UK.
