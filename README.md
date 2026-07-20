# Modern Data Warehouse using MySQL

This project demonstrates the design and implementation of a modern data warehouse using the Medallion Architecture (Bronze, Silver, and Gold) in MySQL. The data warehouse integrates data from CRM and ERP source systems, performs data cleansing and transformation, and delivers business-ready datasets for analytics and reporting.

## Project Structure

```
.
├── datasets/     # Raw CSV files from CRM and ERP systems
├── scripts/      # SQL scripts for Bronze, Silver, Gold, and EDA
└── README.md
```

## Data Warehouse Layers

- **Bronze** – Loads raw data from source CSV files.
- **Silver** – Cleans, validates, and standardizes the data.
- **Gold** – Creates business-ready dimension and fact views for analytics.

## Project Workflow

1. Load raw data into the Bronze layer.
2. Clean and transform data in the Silver layer.
3. Build analytical views in the Gold layer.
4. Perform exploratory data analysis (EDA) using the Gold layer.

## Technologies Used

- MySQL
- MySQL Workbench

---
Created by **Abubakar**
