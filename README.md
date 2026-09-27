# AI-Powered Pharmaceutical Sales Analytics & Automated Reporting

An end-to-end analytics system that lets a business user ask sales questions in plain English and get answers, charts, and full reports back — generated from a real MySQL database, not fabricated by the AI.

**Pipeline:** Raw data → Python/Pandas cleaning → MySQL → n8n + Gemini AI Agent → Read-only SQL execution → Business insights → QuickChart visualization → Automated multi-chart report

---

## Why this project

Pharmaceutical companies generate sales data across products, distributors, customers, channels, and regions. Answering a simple business question ("which product class sells best?") normally requires an analyst to write SQL by hand every time. This project removes that bottleneck: a non-technical user types a question, and the system queries the database, analyzes the result, and returns a business-ready answer — with a chart if asked, or a full report if requested.

The AI never invents numbers. Every answer traces back to a live SQL query against the actual database.

---

## Dataset

- **254,082** raw pharmaceutical sales records, 18 columns
- **240** unique products across **6** product classes
- **751** unique customers, **29** distributors
- Pharmacy and Hospital sales channels
- Monthly data, 2017–2020

Columns: `Distributor`, `Customer Name`, `City`, `Country`, `Latitude`, `Longitude`, `Channel`, `Sub-channel`, `Product Name`, `Product Class`, `Quantity`, `Price`, `Sales`, `Month`, `Year`, `Sales Rep`, `Manager`, `Sales Team`

### Data quality issues found and handled

- **Negative quantities and negative sales** — present across multiple product classes rather than isolated to one category. Kept rather than deleted, since these likely represent returns/adjustments in a real sales system.
- **Zero-value transactions** (`quantity = 0`, `sales = 0`) — investigated rather than auto-dropped.
- **Duplicate records** — identified during exploration.
- **Derived field**: `sale_date` engineered from `Month` + `Year` to support time-series analysis, since no single date column existed in the raw data.

Full exploration and cleaning steps are in [`pharma_sales_data_cleaning_and_analysis.ipynb`](./pharma_sales_data_cleaning_and_analysis.ipynb).

---

## Database

```
Database: pharma_analytics
Table:    pharma_sales
Rows:     254,051 (after cleaning)
```

Core queries — record counts, total sales, sales by product class, negative-transaction counts, yearly sales — are in [`sales_analysis.sql`](./sales_analysis.sql).

---

## AI Agent Architecture

```
User (chat message)
        ↓
   n8n Chat Trigger
        ↓
     AI Agent ── Simple Memory (conversation context)
        ↓
  Google Gemini (reasoning + SQL generation)
        ↓
   MySQL Tool (read-only)
        ↓
   pharma_sales table
        ↓
    SQL results
        ↓
  AI Agent (business analysis)
        ↓
  JavaScript Code node
        ↓
     QuickChart
        ↓
  Answer + Chart(s) / Full Report
```

Exported workflow: [`pharma_sales_ai_automation.json`](./pharma_sales_ai_automation.json)

![n8n workflow](./screenshots/n8n_workflow.png)

### Guardrails

The AI Agent is explicitly restricted to:
- `SELECT` queries only against `pharma_sales`
- Existing columns only — no invented fields
- No `INSERT`, `UPDATE`, `DELETE`, `DROP`, `ALTER`, or `TRUNCATE`

Tested by deliberately asking the agent to modify or delete data; it refused and returned a read-only explanation instead of executing the request.

---

## Three Interaction Modes

**1. Direct question** — *"Which product class has the highest total sales?"*
Returns a concise, data-backed answer (verified independently against MySQL: Analgesics, ~$2.37B).

**2. Question + chart** — *"Show total sales by product class as a chart."*
Returns the business explanation plus a dynamically generated QuickChart visualization built from the live query result.

**3. Full report** — *"Generate the full pharma sales report."*
Runs multiple SQL queries and assembles a complete report:

- **Executive summary** — total sales, total quantity, unique products, unique customers, distributor count
- **Sales performance** — by product class, by channel, monthly trend
- **Top performers** — top 10 products, top 10 customers, top 10 sales reps
- **Business insights** — highest/lowest-selling product class, highest-sales month, top-performing sales team
- **5 charts** — sales by product class, monthly trend, sales by channel, top 10 products, top 10 reps — each generated fresh from the current SQL results, not static images

---

## Tech Stack

| Layer | Tool |
|---|---|
| Data cleaning | Python, Pandas |
| Database | MySQL |
| Workflow orchestration | n8n |
| Reasoning / NL-to-SQL | Google Gemini |
| Chart generation | JavaScript, QuickChart |

---

## Repository Structure

```
.
├── pharma_sales_data_cleaning_and_analysis.ipynb   # Data exploration & cleaning
├── sales_analysis.sql                              # Core SQL queries
├── pharma_sales_ai_automation.json                 # Exported n8n workflow
├── screenshots/
│   └── n8n_workflow.png                            # Workflow diagram
└── README.md
```

---

## Known Limitations / Not Yet Built

Being upfront about scope:

- **Stakeholder email delivery is not complete.** A Gmail node and OAuth app were set up, but sending is blocked on OAuth/billing configuration — treat this as planned, not shipped.
- Tested primarily on direct, well-formed questions. Ambiguous phrasing ("show me the bad performers") and cross-year comparison queries have not been systematically validated yet.
- No automated test suite for SQL-generation correctness — verification so far has been manual, spot-checked against MySQL directly.

## Possible Next Steps

- Complete the Gmail/report-delivery step
- Add automated regression tests comparing AI-generated SQL output against known-correct results
- Expand guardrail testing to prompt-injection-style attempts, not just direct destructive requests
