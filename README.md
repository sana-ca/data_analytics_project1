# 🛒 Retail Orders Analytics Project

This end-to-end data analytics project showcases the use of **Python**, **Pandas**, **SQL**, and the **Kaggle API** to extract insights from a real-world retail dataset. The goal is to clean, transform, load the data into SQL Server, and perform SQL-based business analysis to answer key strategic questions.

## 📦 Dataset

- **Source:** [Kaggle - Retail Orders Dataset](https://www.kaggle.com/datasets/ankitbansal06/retail-orders)
- **File:** `orders.csv`
- **Downloaded Using:** Kaggle API

## 🧰 Tools & Technologies

- **Python 3.10+**
- **Pandas**
- **SQLAlchemy**
- **Microsoft SQL Server**
- **Kaggle API**
- **Jupyter Notebook**

## 🔁 Project Workflow

### 1. Data Ingestion & Preparation
- Downloaded dataset using Kaggle API
- Unzipped and loaded CSV into Pandas
- Handled nulls and standardized column names
- Created new columns like `discount`, `sale_price`, and `profit`
- Converted `order_date` to datetime format
- Dropped redundant columns

### 2. Data Loading
- Connected to SQL Server using SQLAlchemy
- Loaded cleaned DataFrame into a SQL table `df_orders`

### 3. Data Analysis Using SQL
Conducted business-driven queries to extract insights

✅ Outcomes
Automated data ingestion using Kaggle API

Efficient ETL using Python

Business-driven SQL analytics

Real-time insights from cleaned retail data
