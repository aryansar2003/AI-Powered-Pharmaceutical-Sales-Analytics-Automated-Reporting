# AI-Powered Pharmaceutical Sales Analytics & Automated Reporting

An AI-powered pharmaceutical sales analytics system built using Python, Pandas, MySQL, n8n, Google Gemini, JavaScript, and QuickChart.

The project takes pharmaceutical sales data through a complete analytics pipeline:

**Data Cleaning → SQL Database → AI-Powered Analytics → Dynamic Visualization → Automated Reporting**

---

## Project Overview

The project started with a raw pharmaceutical sales dataset and was developed into an interactive AI-powered analytics workflow.

The system allows users to ask business questions about pharmaceutical sales using natural language.

The AI Agent:

1. Understands the user's question
2. Generates a read-only SQL query
3. Executes the query against MySQL
4. Analyzes the returned results
5. Provides a business explanation
6. Generates charts when requested
7. Can generate a comprehensive pharmaceutical sales report

---

## Project Architecture

```text
Raw Pharmaceutical Sales Data
            ↓
       Python / Pandas
            ↓
    Data Cleaning & Validation
            ↓
          MySQL
            ↓
           n8n
            ↓
     Google Gemini AI
            ↓
    AI-Generated SQL Query
            ↓
       MySQL Database
            ↓
      Business Analysis
            ↓
   JavaScript + QuickChart
            ↓
      Charts / Reports
n8n Automation Workflow

The core AI analytics workflow was built using n8n.

The workflow consists of:

Chat Trigger
AI Agent
Google Gemini
Simple Memory
MySQL Tool
JavaScript Code
QuickChart

The user interacts with the system through the n8n chat interface.

1. Data Cleaning & Analysis with Python

The raw pharmaceutical sales dataset was first explored and cleaned using Python and Pandas.

The notebook covers:

Dataset inspection
Data type inspection
Missing-value checks
Duplicate-row detection
Negative transaction analysis
Zero-quantity transaction analysis
Data cleaning
Date creation from Month and Year
Data validation
Sales, quantity, and price consistency checks
Dataset Columns

The dataset contains fields such as:

Distributor
Customer Name
City
Country
Latitude
Longitude
Channel
Sub-channel
Product Name
Product Class
Quantity
Price
Sales
Month
Year
Sales Representative
Manager
Sales Team
Python Notebook

pharma_sales_data_cleaning.ipynb

2. MySQL Database

After cleaning the data using Python/Pandas, the dataset was loaded into MySQL for structured analysis.

Database
pharma_analytics
Table
pharma_sales

The SQL analysis includes queries for:

Total number of records
Total sales
Sales by product class
Negative transactions
Yearly sales
Highest-selling product class
SQL File

pharma_sales_sql_queries.sql

3. AI-Powered Analytics

Google Gemini is connected to the n8n AI Agent.

The AI Agent can understand natural-language business questions and convert them into SQL queries.

For example:

Which product class has the highest total sales?

The workflow can generate the appropriate SQL query, execute it against MySQL, and return a business-friendly answer.

The AI Agent is instructed to:

Use the MySQL database when data is required
Use only existing database columns
Generate read-only SQL
Use actual database results
Avoid inventing values
Provide concise business explanations
4. Read-Only SQL Execution

The AI Agent connects to MySQL through the n8n MySQL tool.

The SQL tool is restricted to read-only queries.

Allowed operations are focused on queries such as:

SELECT

The workflow does not allow the AI Agent to perform database modification operations such as:

INSERT
UPDATE
DELETE
DROP
ALTER
TRUNCATE

This keeps the AI analytics workflow focused on data retrieval and analysis.

5. Natural-Language Business Questions

The system can answer questions such as:

Which product class has the highest sales?
Show total sales by product class.
Which sales representative generated the highest sales?
Show the monthly sales trend.
Show sales by channel as a chart.

The user does not need to manually write the SQL query.

6. Dynamic Chart Generation

The workflow supports dynamic chart generation when visualization is requested.

The AI Agent returns structured chart information containing:

Chart title
Chart type
Labels
Values

The JavaScript Code node converts this information into a QuickChart URL and embeds the generated visualization into the response.

Supported Visualizations
Sales by Product Class
Monthly Sales Trend
Sales by Channel
Top Products
Top Sales Representatives

Bar charts are used for categorical comparisons and rankings, while line charts are used for time-based trends.

7. Full Pharmaceutical Sales Report

The workflow also supports generating a comprehensive sales report.

The report can include the following sections.

Executive Summary
Total sales
Total quantity
Unique products
Unique customers
Number of distributors
Sales Performance
Sales by product class
Sales by channel
Monthly sales trend
Top Performers
Top products by sales
Top customers by sales
Top sales representatives by sales
Business Insights
Highest-selling product class
Lowest-selling product class
Highest-sales month
Highest-performing sales team
Other meaningful patterns supported by the data
Report Visualizations

The full report can generate:

Sales by Product Class
Monthly Sales Trend
Sales by Channel
Top 10 Products
Top 10 Sales Representatives
8. AI Agent Response Modes

The workflow supports multiple interaction modes.

Mode 1 — Single Business Question

Example:

Which product class has the highest total sales?

The system retrieves the relevant data from MySQL and provides a concise answer.

Mode 2 — Business Question + Chart

Example:

Show total sales by product class as a chart.

The system returns the business explanation together with a dynamically generated chart.

Mode 3 — Full Sales Report

Example:

Generate the full pharmaceutical sales report.

The system performs multiple analyses and generates a comprehensive report with multiple visualizations.

9. Technologies Used
Technology	Purpose
Python	Data analysis and preprocessing
Pandas	Data cleaning and validation
MySQL	Database storage and SQL analysis
n8n	Workflow automation
Google Gemini	Natural-language analytics and SQL generation
JavaScript	Response processing and chart generation
QuickChart	Dynamic data visualization
10. Project Structure
AI-Powered-Pharmaceutical-Sales-Analytics-Automated-Reporting/
│
├── pharma_sales_data_cleaning.ipynb
├── pharma_sales_sql_queries.sql
├── pharma_sales_ai_automation.json
│
└── screenshots/
    └── n8n_workflow.png
11. Key Skills Demonstrated
Python
Pandas
SQL
MySQL
Data Cleaning
Exploratory Data Analysis
Business Analytics
Data Visualization
n8n Workflow Automation
Generative AI
Prompt Engineering
JavaScript
Automated Reporting
Project Objective

The objective of this project was to build an end-to-end pharmaceutical sales analytics system that combines traditional data analytics with generative AI and workflow automation.

Instead of manually writing SQL queries and creating every report separately, the system allows users to interact with the sales database using natural language and receive data-driven analysis and visualizations.
