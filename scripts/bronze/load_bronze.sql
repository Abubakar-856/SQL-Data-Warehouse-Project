/*
===============================================================================
Script Name : load_bronze_tables.sql

Description :
    This script reloads all Bronze layer tables by truncating the existing
    data and importing the latest records from the CRM and ERP source CSV
    files.

    The Bronze layer is designed to store raw source data with minimal or
    no transformations. Data quality issues such as missing values, invalid
    dates, duplicates, or inconsistent formatting are intentionally
    preserved at this stage and will be addressed during the Silver layer
    transformation process.

Load Process:
    1. Truncate existing Bronze tables.
    2. Import raw data from CSV source files.
    3. Preserve source data for downstream transformations.

Source Systems:
    - CRM
        * cust_info.csv
        * prd_info.csv
        * sales_details.csv

    - ERP
        * CUST_AZ12.csv
        * LOC_A101.csv
        * PX_CAT_G1V2.csv

WARNING:
    - This script deletes all existing data from the Bronze tables before
      loading new data.
    - Ensure the CSV file paths are correct before execution.
    - Update the file paths if running this project on another machine.
    - This script is intended for development and local execution.

NOTE:
    - MySQL does not allow LOAD DATA [LOCAL] INFILE inside stored
      procedures. Therefore, the Bronze data loading process is implemented
      as a standalone SQL script instead of a stored procedure.

===============================================================================
*/
TRUNCATE TABLE crm_cust_info;
LOAD DATA LOCAL INFILE "/Users/chabubakar/sql projects/sql-data-warehouse-project/datasets/source_crm/cust_info.csv"
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ","
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

TRUNCATE TABLE crm_prd_info;
LOAD DATA LOCAL INFILE "/Users/chabubakar/sql projects/sql-data-warehouse-project/datasets/source_crm/prd_info.csv"	INTO TABLE crm_prd_info
FIELDS TERMINATED BY ","
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

TRUNCATE TABLE crm_sales_details;
LOAD DATA LOCAL INFILE "/Users/chabubakar/sql projects/sql-data-warehouse-project/datasets/source_crm/sales_details.csv"
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ","
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

TRUNCATE TABLE erp_cust_az12;
LOAD DATA LOCAL INFILE "/Users/chabubakar/sql projects/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv"
INTO TABLE erp_cust_az12
FIELDS TERMINATED BY ","
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

TRUNCATE TABLE erp_loc_a101;
LOAD DATA LOCAL INFILE "/Users/chabubakar/sql projects/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv"
INTO TABLE erp_loc_a101
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS;

TRUNCATE TABLE erp_px_cat_g1v2;
LOAD DATA LOCAL INFILE "/Users/chabubakar/sql projects/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv"
INTO TABLE erp_px_cat_g1v2
FIELDS TERMINATED BY ","
LINES TERMINATED BY "\r\n"
IGNORE 1 ROWS;
