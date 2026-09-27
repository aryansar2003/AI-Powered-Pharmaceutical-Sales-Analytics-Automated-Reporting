# AI-Powered Pharmaceutical Sales Analytics & Automated Reporting

An end-to-end system that lets a business user ask sales questions in **plain English** and get back a database-verified answer — with charts, and optionally a full multi-chart report — without writing a single line of SQL.

> Natural language → SQL generation → MySQL execution → business insight → chart → report

Built to demonstrate that an AI layer can sit on top of a real relational database and act as a safe, read-only analytics interface — not a chatbot guessing answers, but one that queries actual data every time.

---

## The Problem

Pharmaceutical companies generate large volumes of sales data across products, product classes, distributors, customers, channels, sales reps, and regions. Answering a simple business question — "which product class sold the most last year?" — normally requires an analyst to write a SQL query by hand, every single time.

This project removes that bottleneck: a stakeholder types the question, the system does the rest.

---

## Architecture

```
                     USER
                      │
              Natural language question
                      │
                      ▼
              ┌───────────────┐
              │  n8n Chat     │
              │   Trigger     │
              └───────┬───────┘
                      ▼
              ┌───────────────┐
              │   AI Agent    │
              │  (Gemini +    │
              │   Memory)     │
              └───────┬───────┘
                      ▼
              ┌───────────────┐
              │  MySQL Tool   │  ← read-only, SELECT-only
              └───────┬───────┘
                      ▼
              ┌───────────────┐
              │ pharma_sales  │
              │  (MySQL DB)   │
              └───────┬───────┘
                      ▼
                 SQL Results
                      │
                      ▼
              ┌───────────────┐
              │  AI Agent     │
              │  Analysis     │
              └───────┬───────┘
                      ▼
              ┌───────────────┐
              │ JavaScript    │
              │  Code Node    │
              └───────┬───────┘
                      ▼
              ┌───────────────┐
              │  QuickChart   │
              └───────┬───────┘
                      ▼
         Answer + Chart(s) OR Full Report
```

**Stack:** n8n · Google Gemini · MySQL · JavaScript · QuickChart · SQL

---

## Dataset

- **Source:** Pharmaceutical sales transaction dataset, 254,082 rows × 18 columns
- **Coverage:** 240 unique products · 751 customers · 29 distributors · 6 product classes · Pharmacy & Hospital channels · monthly data, 2017–2020

### Data quality issues found and handled
Rather than assuming a clean dataset, the raw data was investigated first:

| Issue | Decision |
|---|---|
| Negative quantities / negative sales | Kept — likely represent returns/adjustments, not errors |
| Zero-value transactions | Investigated individually, not auto-dropped |
| Duplicate records | Identified and removed during cleaning |

Cleaned data was loaded into MySQL as:

```
Database: pharma_analytics
Table:    pharma_sales     (254,051 rows after cleaning)
```

Columns: `distributor, customer_name, city, country, latitude, longitude, channel, sub_channel, product_name, product_class, quantity, price, sales, month_name, year, sales_rep, manager, sales_team, sale_date`

`sale_date` was engineered from `month_name + year` to enable time-series analysis.

---

## What the system can do

### Mode 1 — Direct question
> "Which product class has the highest total sales?"
→ Returns a plain-language, database-verified answer (e.g., *Analgesics — ~$2.37B*), with no chart.

### Mode 2 — Question + visualization
> "Show total sales by product class as a chart."
→ Returns the answer plus a dynamically generated bar chart.

### Mode 3 — Full automated report
> "Generate the full pharma sales report with all charts."
→ Runs multiple queries and produces a complete report:

**Executive summary:** total sales, total quantity, unique products, unique customers, distributor count

**Five dynamic charts** (each generated from live SQL results, not static images):
1. Sales by Product Class (bar)
2. Monthly Sales Trend (line)
3. Sales by Channel (bar)
4. Top 10 Products (bar)
5. Top 10 Sales Representatives (bar)

**Rankings:** Top 10 products, top 10 customers, top 10 sales reps

**AI-generated business insights**, e.g.:
```
Highest-selling product class:  Analgesics
Lowest-selling product class:   Antimalarial
Highest-sales month:            August 2019
Highest-performing sales team:  Team Delta
```

---

## Safety guardrails

The AI agent is explicitly restricted to protect the underlying database:

- ✅ `SELECT` only
- ❌ No `INSERT`, `UPDATE`, `DELETE`, `DROP`, or `ALTER`
- ❌ Cannot query outside `pharma_sales` or use columns that don't exist
- ❌ Cannot invent values not present in the database

**Tested:** deliberately prompted the agent with destructive requests (e.g., "delete all records") to confirm it refuses rather than executing them. ⚠️ *[Add screenshot/example here — see `/screenshots`]*

---

## Example queries to try

```
Which product class has the highest total sales?
What are the top 10 products by sales?
Show me monthly sales trend for 2019.
Compare sales between 2019 and 2020.
Which sales team generated the most revenue?
How many negative-sales transactions are there?
Generate the full pharma sales report with all charts.
```

---

## Results

- Automated a 5-chart sales report from raw SQL results, cutting manual report-building time from an estimated ~20 minutes (manual query writing + chart building) to under 30 seconds.
- Verified core query accuracy directly against MySQL (e.g., confirmed Analgesics as top product class at $2.37B independent of the AI's answer).

---

## Repository structure

⚠️ *Update this section to match your actual repo layout:*

```
├── data/
│   ├── raw_pharma_sales.csv          # original dataset
│   └── cleaned_pharma_sales.csv      # post-cleaning, loaded into MySQL
├── sql/
│   └── schema.sql                    # pharma_sales table schema
├── notebooks/
│   └── data_cleaning_eda.ipynb       # cleaning + data quality investigation
├── n8n/
│   └── workflow.json                 # exported n8n workflow
├── screenshots/
│   ├── mode1_direct_answer.png
│   ├── mode2_chart.png
│   ├── mode3_full_report.png
│   └── guardrail_refusal_test.png
└── README.md
```

---

## What's not finished yet

- **Stakeholder email delivery** — a Gmail node and Google OAuth app were set up to auto-send reports to stakeholders, but OAuth/billing configuration is incomplete. This is planned, not part of the working system today.

## Roadmap

- [ ] Complete Gmail-based automated report delivery
- [ ] Handle ambiguous/comparative questions more robustly (e.g., "compare 2019 vs 2020")
- [ ] Add a scheduled/recurring report trigger (weekly, monthly)
- [ ] Expand guardrail testing to additional edge cases

---

## Tech stack

`n8n` · `Google Gemini` · `MySQL` · `JavaScript` · `QuickChart` · `SQL`

---

## Author

**Aryan Saraswat** — Data Analyst
[LinkedIn](https://linkedin.com/in/aryan-saraswat-3b4ba9278) · [GitHub](https://github.com/aryansar2003)
