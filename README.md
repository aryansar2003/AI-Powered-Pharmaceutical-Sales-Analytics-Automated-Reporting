# AI-Powered Pharmaceutical Sales Analytics & Automated Reporting

A system that lets a business user ask sales questions in **plain English** and get back a database-verified answer — with charts, and optionally a full multi-chart report — without writing any SQL.

> Natural language → AI agent generates SQL → MySQL executes it → results are analyzed and charted → answer/report returned

Built to show that an AI layer can sit on top of a real relational database as a **safe, read-only analytics interface** — every answer comes from an actual query against real data, not a guess.

---

## The problem

Pharma companies generate sales data across products, product classes, distributors, customers, channels, sales reps, and regions. Answering something as simple as "which product class sold the most?" normally means an analyst writes a fresh SQL query every time someone asks. This system replaces that with a chat interface: type the question, get the answer.

---

## Architecture

```
                     USER
                      │
              Natural language question
                      ▼
              ┌───────────────────┐
              │  When chat message│
              │     received      │
              └─────────┬─────────┘
                        ▼
              ┌───────────────────┐
              │      AI Agent     │
              │  (Google Gemini)  │
              └───┬───────┬───────┘
                  │       │
        ┌─────────┘       └─────────┐
        ▼                           ▼
┌───────────────┐          ┌──────────────────┐
│ Simple Memory  │          │ Execute a SQL     │
│ (conversation  │          │ query in MySQL    │
│  context)      │          │ (read-only tool)  │
└───────────────┘          └─────────┬─────────┘
                                      ▼
                             pharma_sales table
                             (MySQL, 254,051 rows)
                                      │
                                      ▼
                              SQL results returned
                              to the AI Agent
                                      │
                                      ▼
                          ┌───────────────────────┐
                          │   Code in JavaScript   │
                          │ (parses AI's structured│
                          │ JSON output, builds a  │
                          │ QuickChart image URL   │
                          │ per chart)             │
                          └───────────┬───────────┘
                                      ▼
                         Answer + embedded chart(s)
                         OR full multi-chart report
```

**Stack:** n8n · Google Gemini · MySQL · JavaScript · QuickChart (via URL, not a dedicated node) · SQL

---

## Dataset

- **Source:** Pharmaceutical sales transaction dataset — 254,082 rows × 18 columns
- **Coverage:** 240 unique products · 751 customers · 29 distributors · 6 product classes · Pharmacy & Hospital channels · monthly data, 2017–2020

### Data quality investigation

Rather than assuming the raw CSV was clean, it was checked systematically before use (see `pharma_sales_data_cleaning_and_analysis_.ipynb`):

| Check | Finding | Decision |
|---|---|---|
| Negative `Quantity` | **2,633 rows (~1%)** — every one also has negative `Sales`, spans all 240 products and all 6 product classes | Kept — the consistent pairing with negative sales suggests returns/adjustments, not data-entry errors, so they weren't dropped |
| Exact duplicate rows | **4 rows** | Dropped |
| `Quantity == 0` | **27 rows**, all with `Sales == 0` too (no transaction actually happened) | Dropped |
| `Quantity × Price = Sales` | **29 rows** fail this check — their `Quantity` values are non-integer (e.g. `163.551276`) instead of clean whole numbers, suggesting they were back-calculated from `Sales ÷ Price` rather than being original input | Flagged as a known, unresolved data-quality issue — `Sales` is treated as the more reliable field for these rows |
| Text field whitespace | Stray leading/trailing spaces from source file | Stripped |

**Result:** 254,082 → **254,051 rows** after removing the 4 duplicates and 27 zero-quantity rows. The negative-quantity rows and the 29 quantity/price mismatches remain in the dataset by design, not by oversight.

A `Date` column was engineered from `Month` (name) + `Year` (int) via `pd.to_datetime(..., format="%B %Y")` to support time-series analysis.

Cleaned data was loaded into MySQL:

```
Database: pharma_analytics
Table:    pharma_sales
```

Columns: `distributor, customer_name, city, country, latitude, longitude, channel, sub_channel, product_name, product_class, quantity, price, sales, month_name, year, sales_rep, manager, sales_team, sale_date`

---

## What the system can do

### Mode 1 — Direct question, no chart
> "Which product class has the highest total sales?"
→ Plain-language answer from a live SQL query (e.g., *Analgesics — ~$2.37B*).

### Mode 2 — Question + chart
> "Show total sales by product class as a chart."
→ Same answer, plus a chart image rendered inline via a dynamically built QuickChart URL.

### Mode 3 — Full report
> "Generate the full pharma sales report with all charts."
→ Runs multiple SQL queries via the agent and returns:

- **Executive summary:** total sales, total quantity, unique products, unique customers, distributor count
- **Five charts**, each built from that run's live SQL results:
  1. Sales by Product Class (bar)
  2. Monthly Sales Trend (line)
  3. Sales by Channel (bar)
  4. Top 10 Products (bar)
  5. Top 10 Sales Representatives (bar)
- **Rankings:** top 10 products, top 10 customers, top 10 sales reps
- **AI-generated business insights**, e.g. highest/lowest-selling product class, highest-sales month, highest-performing sales team

The agent decides which mode to use based on the system prompt in `pharma_sales_ai_automation.json`, which defines the exact JSON output contract for both modes (see that file for the full prompt).

---

## Safety guardrails

The MySQL tool is restricted at the prompt/tool level:

- ✅ `SELECT` only, against `pharma_sales` only, using only existing columns
- ❌ No `INSERT`, `UPDATE`, `DELETE`, `DROP`, or `ALTER`
- ❌ Instructed never to invent values not returned by a query

⚠️ *Guardrail test pending — deliberately prompt the agent with a destructive request (e.g. "delete all records in pharma_sales") and confirm it refuses. Add the transcript/screenshot here once tested.*

---

## Repository contents

```
├── n8n_workflow.png                              # workflow diagram screenshot
├── pharma_sales_ai_automation.json               # exported n8n workflow (import into n8n to run)
├── pharma_sales_data_cleaning_and_analysis_.ipynb # data cleaning & quality investigation notebook
└── sales_analysis.sql                            # queries used to independently verify AI-returned results in MySQL
```

Note: the raw/cleaned CSV isn't included in this repo (size). To reproduce: run the notebook against the [pharma sales dataset], load the resulting `pharma_sales_clean.csv` into MySQL as `pharma_sales`, then import `pharma_sales_ai_automation.json` into n8n and connect your own Gemini + MySQL credentials.

---

## Example queries to try

```
Which product class has the highest total sales?
What are the top 10 products by sales?
Show me monthly sales trend for 2019.
Which sales team generated the most revenue?
How many negative-sales transactions are there?
Generate the full pharma sales report with all charts.
```

---

## Verification

Core results were independently checked against MySQL directly (see `sales_analysis.sql`) rather than trusted from the AI output alone — e.g., confirmed Analgesics as the top product class at ~$2.37B total sales, matching the agent's answer.

---

## Known limitations / not yet finished

- **Stakeholder email delivery** — a Gmail node + Google OAuth app were set up to auto-send reports, but OAuth/billing setup wasn't completed. Not part of the working system yet.
- **Guardrail refusal** — designed and prompted for, but not yet screenshot-verified (see above).
- The 29 rows where `Quantity × Price ≠ Sales` are a known open data-quality issue, not yet resolved in the pipeline.
- Ambiguous or comparative questions (e.g., "compare 2019 vs 2020") haven't been systematically tested yet.

## Roadmap

- [ ] Verify and document the guardrail-refusal test
- [ ] Complete Gmail-based report delivery
- [ ] Resolve or explicitly handle the 29 quantity/price/sales mismatch rows
- [ ] Test and document comparative/ambiguous question handling
- [ ] Add a scheduled/recurring report trigger

---

## Tech stack

`n8n` · `Google Gemini` · `MySQL` · `JavaScript` · `QuickChart` · `SQL`

---

## Author

**Aryan Saraswat** — Data Analyst
[LinkedIn](https://linkedin.com/in/aryan-saraswat-3b4ba9278) · [GitHub](https://github.com/aryansar2003)
