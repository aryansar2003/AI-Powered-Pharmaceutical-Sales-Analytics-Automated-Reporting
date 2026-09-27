# AI-Powered Pharmaceutical Sales Analytics & Automated Reporting

## Business Problem

Pharmaceutical companies generate large volumes of sales data across products, distributors, customers, channels, and sales teams — but answering a routine business question ("which product class sold the most?", "what were monthly sales trends?") normally requires an analyst to write a new SQL query every time.

The goal of this project is to let a non-technical business user ask these questions in plain English and get a database-verified answer, with charts, on demand — without writing any SQL themselves.

## Project Overview

This project analyzes 254,082 pharmaceutical sales transactions and builds a natural-language analytics layer on top of them.

**Raw Data → Data Cleaning (Python/Pandas) → MySQL → n8n AI Agent (Gemini) → SQL Query → Business Answer + Charts**

```
Raw Pharmaceutical Sales Data
            ↓
      Python / Pandas
   (Cleaning & Validation)
            ↓
          MySQL
            ↓
   n8n Chat Trigger → AI Agent
                        ↙     ↘
              Google Gemini   MySQL Tool (read-only)
                        ↓
                Business Analysis
                        ↓
                 JavaScript Code
                        ↓
                    QuickChart
                        ↓
             Answer + Charts / Report
```

## Tools Used

- Python (Pandas)
- MySQL
- n8n
- Google Gemini
- JavaScript
- QuickChart

## Data Cleaning & Quality Findings

The raw dataset (254,082 rows, 18 columns, no missing values) was investigated before use, not assumed clean:

| Issue | Finding | Decision |
|---|---|---|
| Negative quantity | 2,633 rows (~1%), every one also has negative sales, spans all 240 products and all 6 product classes | Kept — likely returns/adjustments, not errors |
| Duplicate rows | 4 exact duplicates | Removed |
| Zero-quantity rows | 27 rows, all with Sales = 0 too | Removed |
| `Quantity × Price = Sales` check | 29 rows show a mismatch — due to decimal/rounding differences in `Quantity`, not a real data error | No action needed; Sales treated as the reliable field for these rows |

**Final dataset: 254,051 rows**, loaded into MySQL as `pharma_analytics.pharma_sales`. A `Date` column was engineered from `Month` + `Year` for time-series analysis.

**Notebook:** `pharma_sales_data_cleaning_and_analysis.ipynb`

## What It Can Do

The AI agent supports three modes of interaction:

- **Direct question** — "Which product class has the highest total sales?" → plain-language answer from a live SQL query
- **Question + chart** — "Show total sales by product class as a chart" → answer plus a dynamically rendered chart
- **Full report** — "Generate the full pharma sales report" → executive summary, 5 charts (sales by product class, monthly trend, sales by channel, top 10 products, top 10 sales reps), top-performer rankings, and AI-generated business insights, all built from live SQL results

**Workflow:** `pharma_sales_ai_automation.json`

## Key Findings

- Analgesics is the highest-selling product class, at approximately **$2.37B** in total sales — confirmed independently against MySQL (`sales_analysis.sql`), matching the AI agent's answer.
- 2,633 transactions (~1% of the dataset) carry negative quantity and sales, consistently across every product class — indicating systematic returns/adjustments rather than isolated data errors.

## Guardrails

The MySQL tool is restricted to `SELECT` only, against `pharma_sales` only, using only existing columns. `INSERT`, `UPDATE`, `DELETE`, `DROP`, and `ALTER` are not permitted.

⚠️ *Guardrail test pending — deliberately prompting the agent with a destructive request (e.g. "delete all records") and confirming it refuses. To be added here once tested.*

## n8n Workflow

![n8n workflow diagram](https://github.com/aryansar2003/AI-Powered-Pharmaceutical-Sales-Analytics-Automated-Reporting/raw/main/n8n_workflow.png)

## Repository Files

```
├── README.md
├── pharma_sales_data_cleaning_and_analysis.ipynb
├── sales_analysis.sql
├── pharma_sales_ai_automation.json
└── n8n_workflow.png
```

Note: the raw/cleaned CSV isn't included (file size). To reproduce: run the notebook on the source dataset, load the resulting cleaned CSV into MySQL as `pharma_sales`, then import the workflow JSON into n8n with your own Gemini + MySQL credentials.

## Limitations & Roadmap

- Stakeholder email delivery via Gmail was scoped (OAuth app created) but not completed — not part of the working system yet.
- Comparative/ambiguous questions (e.g., "compare 2019 vs 2020") haven't been systematically tested.
- [ ] Verify and document the guardrail-refusal test
- [ ] Complete Gmail-based report delivery
- [ ] Add a scheduled/recurring report trigger

## About

An AI-powered pharmaceutical sales analytics system combining Python, MySQL, n8n, Google Gemini, and QuickChart — letting business users query 254K+ sales records in natural language and get database-verified answers, charts, and full reports.

---

**Author:** Aryan Saraswat
[LinkedIn](https://linkedin.com/in/aryan-saraswat-3b4ba9278) · [GitHub](https://github.com/aryansar2003)
