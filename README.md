Absolutely. Based on what you've actually built, I’d use this README. It tells the full story without overselling the project.

Copy this into **`README.md`**:

````markdown
# AI-Powered Pharmaceutical Sales Analytics & Automated Reporting

An AI-powered pharmaceutical sales analytics system that combines **Python/Pandas, MySQL, n8n, Google Gemini, JavaScript, and QuickChart** to analyze pharmaceutical sales data through natural-language questions and generate automated business reports with visualizations.

---

## Project Overview

This project was built as an end-to-end data analytics and automation workflow.

The project starts with a raw pharmaceutical sales dataset, which is cleaned and validated using **Python and Pandas**. The cleaned data is then analyzed using **MySQL** and connected to an **n8n AI workflow**.

Users can ask business questions in natural language. The AI Agent uses Google Gemini to understand the request, generates a read-only SQL query, retrieves the required data from MySQL, analyzes the results, and returns a business-oriented response.

For chart requests and full reports, JavaScript dynamically converts the AI-generated chart data into **QuickChart** visualizations.

---

## Architecture

```text
Raw Pharmaceutical Sales Data
            ↓
      Python / Pandas
            ↓
   Data Cleaning & Validation
            ↓
          MySQL
            ↓
       n8n Chat Trigger
            ↓
        AI Agent
       ↙         ↘
 Google Gemini   MySQL Tool
       ↓
  Business Analysis
       ↓
 JavaScript Code
       ↓
     QuickChart
       ↓
 Answer + Charts / Report
````

---

## Technologies Used

* **Python**
* **Pandas**
* **MySQL**
* **n8n**
* **Google Gemini**
* **JavaScript**
* **QuickChart**
* **GitHub**

---

## Dataset

The pharmaceutical sales dataset contains transactional sales information including:

* Distributor
* Customer
* City
* Country
* Channel
* Sub-channel
* Product
* Product Class
* Quantity
* Price
* Sales
* Month
* Year
* Sales Representative
* Manager
* Sales Team
* Latitude / Longitude

The dataset contains pharmaceutical sales transactions across multiple years, products, customers, channels, and sales teams.

---

## 1. Data Cleaning & Validation — Python/Pandas

The initial dataset was explored and cleaned using Pandas.

The analysis included:

* Dataset shape and structure inspection
* Data type inspection
* Missing-value checks
* Duplicate-row detection
* Negative quantity investigation
* Negative sales investigation
* Zero-quantity transaction investigation
* Duplicate removal
* Creation of a proper date column from month and year
* Final data-quality validation
* Sales consistency checks

The cleaned dataset was then prepared for database analysis.

### File

`pharma_sales_data_cleaning.ipynb`

---

## 2. SQL Analysis — MySQL

The cleaned data was loaded into MySQL for structured analysis.

The SQL analysis includes queries for:

* Total number of transactions
* Total sales
* Sales by product class
* Negative transactions
* Yearly sales
* Highest-selling product class

### File

`pharma_sales_sql_queries.sql`

---

## 3. AI Analytics Workflow — n8n

The cleaned sales database was connected to an n8n workflow.

The workflow contains:

### Chat Trigger

Users interact with the analytics system through the n8n chat interface.

### AI Agent

The AI Agent interprets the user's business question and determines what data is required.

### Google Gemini

Gemini is used as the language model for understanding requests and generating the required SQL/analysis workflow.

### MySQL Tool

The AI Agent can execute read-only SQL queries against the `pharma_sales` table.

The workflow restricts database operations to read-only queries and does not allow operations such as:

```text
INSERT
UPDATE
DELETE
DROP
ALTER
TRUNCATE
```

### Simple Memory

The workflow includes conversational memory to maintain context during the interaction.

### JavaScript

A JavaScript Code node processes the AI Agent's structured response and dynamically creates chart URLs.

### QuickChart

QuickChart is used to render charts from the data returned by the AI Agent.

---

## 4. Natural-Language Analytics

The system allows users to ask questions such as:

```text
What is the total sales by product class?
```

or:

```text
Show total sales by product class as a chart.
```

The AI Agent retrieves the required information from MySQL and returns the result in a business-friendly format.

---

## 5. Automated Charts

When a chart is requested, the AI Agent returns structured chart data containing:

* Chart title
* Chart type
* Labels
* Values

The JavaScript node converts this information into a QuickChart visualization.

Supported chart types include:

* Bar charts
* Line charts

Examples of generated visualizations include:

* Sales by Product Class
* Monthly Sales Trend
* Sales by Channel
* Top Products
* Top Sales Representatives

---

## 6. Full Sales Report

The workflow also supports a full pharmaceutical sales report.

The report can include:

### Executive Summary

* Total sales
* Total quantity
* Unique products
* Unique customers
* Number of distributors

### Sales Performance

* Sales by product class
* Sales by channel
* Monthly sales trend

### Top Performers

* Top 10 products
* Top 10 customers
* Top 10 sales representatives

### Business Insights

* Highest-selling product class
* Lowest-selling product class
* Highest-sales month
* Highest-performing sales team
* Other patterns supported by the available data

The full report can also generate multiple charts automatically.

---

## 7. Example Workflow

A typical interaction follows this process:

```text
User:
"Show total sales by product class as a chart."

        ↓

n8n Chat Trigger

        ↓

AI Agent

        ↓

Google Gemini determines the required analysis

        ↓

MySQL executes a read-only SQL query

        ↓

AI Agent analyzes the returned data

        ↓

JavaScript processes chart data

        ↓

QuickChart generates the visualization

        ↓

User receives:
Business Answer + Chart
```

---

## Screenshots

### n8n Automation Workflow

![n8n Workflow](screenshots/n8n_workflow.png)

### Single Question with Chart

![Single Question Chart](screenshots/single_question_chart.png)

### Full Sales Report

![Full Sales Report](screenshots/full_sales_report.png)

---

## Project Structure

```text
AI-Powered-Pharmaceutical-Sales-Analytics-Automated-Reporting/
│
├── pharma_sales_data_cleaning.ipynb
├── pharma_sales_sql_queries.sql
├── pharma_sales_ai_automation.json
│
├── screenshots/
│   ├── n8n_workflow.png
│   ├── single_question_chart.png
│   └── full_sales_report.png
│
└── README.md
```

---

## Key Learning Outcomes

This project demonstrates practical experience with:

* Data cleaning using Pandas
* Exploratory data analysis
* SQL-based data analysis
* MySQL database integration
* AI-assisted analytics
* Natural-language-to-SQL workflows
* n8n workflow automation
* API-based AI integration
* JavaScript data processing
* Dynamic chart generation
* Automated business reporting

---

## End-to-End Data Flow

```text
Python / Pandas
      ↓
Cleaned Data
      ↓
MySQL Database
      ↓
n8n
      ↓
Google Gemini
      ↓
AI-Generated SQL
      ↓
MySQL Results
      ↓
Business Analysis
      ↓
JavaScript
      ↓
QuickChart
      ↓
Interactive Analytics Response
```

---

## Author

**Aryan Saraswat**

B.Tech — Information Technology

Interested in Data Analytics, Business Analytics, BI, and AI-powered automation.


pharma_sales_data_cleaning.ipynb
pharma_sales_sql_queries.sql
pharma_sales_ai_automation.json
n8n_workflow.png
README.md
````

