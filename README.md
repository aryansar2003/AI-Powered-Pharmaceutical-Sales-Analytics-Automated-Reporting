# AI-Powered Pharmaceutical Sales Analytics & Automated Reporting

An end-to-end pharmaceutical sales analytics project that combines **Python/Pandas, MySQL, n8n, Google Gemini, JavaScript, and QuickChart**.

The project starts with raw pharmaceutical sales data, performs data cleaning and validation using Python/Pandas, loads the cleaned data into MySQL, and then uses an n8n AI workflow to answer natural-language business questions and generate sales reports with charts.

---

## Project Overview

The project follows this pipeline:

```
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
```

The goal was to build a practical analytics system rather than only perform static data analysis.

### Tech Stack

- Python
- Pandas
- MySQL
- n8n
- Google Gemini
- JavaScript
- QuickChart
- GitHub

---

## 1. Data Cleaning & Exploration

The raw pharmaceutical sales dataset was first analyzed and cleaned using Python and Pandas.

The original dataset contained:

- 254,082 rows
- 18 columns
- No missing values

Important columns include:

- Distributor
- Customer Name
- City
- Country
- Latitude
- Longitude
- Channel
- Sub-channel
- Product Name
- Product Class
- Quantity
- Price
- Sales
- Month
- Year
- Name of Sales Rep
- Manager
- Sales Team

### Data Quality Checks

The notebook performs:

- Dataset structure inspection
- Data type inspection
- Descriptive statistics
- Missing-value checks
- Negative quantity investigation
- Negative sales investigation
- Duplicate detection
- Zero-quantity transaction investigation
- Date feature engineering
- Sales formula validation
- Text whitespace cleaning

### Negative Transactions

The dataset contains 2,633 transactions with negative quantity.

Every negative-quantity transaction also has negative sales.

These transactions occur across:

- All 240 products
- All 6 product classes

Rather than automatically deleting them, they were retained because they may represent returns or sales adjustments.

### Duplicate Rows

4 exact duplicate rows were identified and removed.

### Zero-Quantity Rows

27 rows contained:

- Quantity = 0
- Sales = 0

These rows were removed because they do not represent an actual transaction.

### Date Feature

The separate Month and Year columns were combined into a proper Date column using Pandas.

### Sales Validation

The notebook also checks whether:

```
Quantity × Price = Sales
```

There are 29 rows where the calculation does not match exactly.

These rows contain unusually precise non-integer quantity values. They were retained rather than arbitrarily modified, with Sales treated as the more reliable field for sales analysis.

### Final Dataset

After removing duplicate and zero-quantity rows:

**254,051 rows**

The cleaned dataset was exported as:

```
pharma_sales_clean.csv
```

**Python File:** `pharma_sales_data_cleaning_and_analysis.ipynb`

---

## 2. MySQL Analysis

The cleaned dataset was loaded into a MySQL database named:

```
pharma_analytics
```

with the main table:

```
pharma_sales
```

The SQL file contains queries for:

- Total transaction count
- Total sales
- Sales by product class
- Negative transaction count
- Yearly sales
- Highest-selling product class

**SQL File:** `sales_analysis.sql`

---

## 3. AI-Powered Analytics with n8n

After the data was prepared and stored in MySQL, an AI analytics workflow was built using n8n.

The workflow contains:

**Chat Trigger**
Users can submit business questions through the n8n chat interface.

**AI Agent**
The AI Agent interprets the user's request and determines what data needs to be retrieved.

**Google Gemini**
Google Gemini acts as the language model used by the AI Agent.

**MySQL Tool**
The AI Agent can execute read-only SQL queries against the pharmaceutical sales database.

The workflow restricts the database tool to read-only SQL operations. Write operations such as:

- INSERT
- UPDATE
- DELETE
- DROP
- ALTER
- TRUNCATE

are not allowed.

**Simple Memory**
A memory component is connected to the AI Agent to maintain conversational context.

**JavaScript**
The JavaScript Code node processes the structured response returned by the AI Agent. It extracts:

- Chart title
- Chart type
- Labels
- Values

and dynamically generates QuickChart URLs.

**QuickChart**
QuickChart is used to generate visualizations from the chart data returned by the AI Agent.

---

## 4. Natural-Language Business Questions

The system allows users to interact with the sales database using natural language.

For example:

> What is the highest-selling product class?

or:

> Show total sales by product class as a chart.

The AI Agent determines the required SQL query, retrieves the data from MySQL, and converts the result into a business-oriented response.

---

## 5. Chart Generation

The workflow supports dynamic chart generation. Examples include:

- Sales by Product Class
- Monthly Sales Trend
- Sales by Channel
- Top 10 Products
- Top 10 Sales Representatives

The AI Agent returns structured chart information, which is then processed by JavaScript and rendered using QuickChart.

```
AI Agent
   ↓
Chart Data
   ↓
JavaScript
   ↓
QuickChart URL
   ↓
Chart displayed in response
```

---

## 6. Full Sales Report

The AI Agent also supports a full pharmaceutical sales report.

The report workflow is designed to analyze:

**Executive Summary**
- Total sales
- Total quantity
- Unique products
- Unique customers
- Number of distributors

**Sales Performance**
- Sales by product class
- Sales by channel
- Monthly sales trend

**Top Performers**
- Top 10 products by sales
- Top 10 customers by sales
- Top 10 sales representatives by sales

**Business Insights**
- Highest-selling product class
- Lowest-selling product class
- Highest-sales month
- Highest-performing sales team
- Other patterns supported by the database

The full-report mode also generates multiple charts.

---

## 7. Example Workflow

A typical user request follows this process:

```
User asks a business question
            ↓
n8n Chat Trigger
            ↓
AI Agent
            ↓
Google Gemini
            ↓
AI determines required SQL
            ↓
MySQL executes read-only query
            ↓
AI analyzes returned results
            ↓
JavaScript processes output
            ↓
QuickChart generates visualization
            ↓
Business answer + chart
```

---

## 8. n8n Workflow

![n8n workflow diagram](https://github.com/aryansar2003/AI-Powered-Pharmaceutical-Sales-Analytics-Automated-Reporting/raw/main/n8n_workflow.png)

The exported n8n workflow is available in:

```
pharma_sales_ai_automation.json
```

---

## 9. Project Files

```
AI-Powered-Pharmaceutical-Sales-Analytics-Automated-Reporting/
│
├── README.md
├── pharma_sales_data_cleaning_and_analysis.ipynb
├── sales_analysis.sql
├── pharma_sales_ai_automation.json
└── n8n_workflow.png
```

---

## 10. Key Skills Demonstrated

This project demonstrates practical experience with:

- Data cleaning using Pandas
- Data quality validation
- Exploratory data analysis
- SQL analysis
- MySQL
- Natural-language analytics
- AI-assisted SQL generation
- n8n workflow automation
- Google Gemini API integration
- JavaScript data processing
- Dynamic chart generation
- Business reporting
- End-to-end analytics workflow development

---

## 11. Project Outcome

This project combines traditional data analytics with AI-powered workflow automation.

Instead of manually writing a SQL query for every business question, users can interact with the sales database using natural language.

The system connects:

```
Data Cleaning
     +
Database Analysis
     +
Generative AI
     +
Workflow Automation
     +
Data Visualization
```

to create an end-to-end pharmaceutical sales analytics solution.

---

## Author

**Aryan Saraswat**
B.Tech — Information Technology
Interested in Data Analytics, Business Analytics, Business Intelligence, and AI-powered automation.
