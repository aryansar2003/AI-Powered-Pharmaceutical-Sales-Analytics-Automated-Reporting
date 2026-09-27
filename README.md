# AI-Powered Pharmaceutical Sales Analytics & Automated Reporting

An end-to-end pharmaceutical sales analytics project that combines **Python/Pandas, MySQL, n8n, Google Gemini, JavaScript, and QuickChart** to turn raw sales data into interactive business analysis and automated reports.

## Project Overview

This project started with a raw pharmaceutical sales dataset and was developed through multiple stages:

**Raw Data → Python/Pandas → MySQL → n8n → Gemini AI → SQL Analysis → JavaScript → QuickChart → Business Report**

The system allows users to ask pharmaceutical sales questions in natural language. The AI Agent determines the required analysis, generates read-only SQL queries, retrieves the data from MySQL, analyzes the results, and can generate charts and a multi-section sales report.

---

## Tech Stack

- **Python**
- **Pandas**
- **MySQL**
- **n8n**
- **Google Gemini**
- **JavaScript**
- **QuickChart**
- **Jupyter Notebook**

---

## Dataset

The original dataset contains pharmaceutical sales transactions with information including:

- Distributor
- Customer
- City
- Country
- Sales Channel
- Sub-channel
- Product
- Product Class
- Quantity
- Price
- Sales
- Month
- Year
- Sales Representative
- Manager
- Sales Team

The dataset contains more than **250,000 sales transaction records**.

---

# 1. Data Cleaning & Analysis — Python/Pandas

The first stage of the project was performed using Python and Pandas.

The notebook includes:

- Dataset inspection
- Data type inspection
- Missing-value analysis
- Duplicate detection
- Negative quantity and sales investigation
- Zero-quantity transaction investigation
- Duplicate removal
- Data cleaning
- Date column creation from Month and Year
- Data validation
- Sales calculation validation

The cleaned dataset was subsequently prepared for database analysis.

### File

`pharma_sales_data_cleaning.ipynb`

---

# 2. SQL Database Analysis — MySQL

The cleaned data was imported into MySQL and stored in the `pharma_sales` table.

SQL was then used to perform initial business analysis, including:

- Total transaction count
- Total sales
- Sales by product class
- Negative transaction analysis
- Sales by year
- Highest-selling product class

### File

`pharma_sales_sql_queries.sql`

---

# 3. AI-Powered Analytics — n8n

The next stage connects the MySQL database with an AI-powered n8n workflow.

### Workflow

```text
User
  ↓
Chat Trigger
  ↓
AI Agent
  ↓
Google Gemini
  ↓
MySQL Tool
  ↓
SQL Query
  ↓
MySQL Database
  ↓
AI Analysis
  ↓
JavaScript
  ↓
QuickChart
  ↓
Business Answer / Charts / Report
