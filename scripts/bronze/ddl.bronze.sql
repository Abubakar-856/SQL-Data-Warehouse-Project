/*
===============================================================================
Script Name : create_bronze_tables.sql

Description :
    This script creates all tables required for the Bronze layer of the
    Modern Data Warehouse.

    The Bronze layer stores raw data ingested directly from the source
    systems with minimal or no transformations. These tables serve as the
    initial landing zone for CRM and ERP source data before it is cleaned
    and standardized in the Silver layer.

Source Systems:
    - CRM
        * cust_info
        * prd_info
        * sales_details

    - ERP
        * CUST_AZ12
        * LOC_A101
        * PX_CAT_G1V2

WARNING:
    - Existing Bronze tables will be permanently dropped and recreated.
    - Any data stored in these tables will be lost.
    - Execute this script only during the initial setup or when rebuilding
      the Bronze layer.

===============================================================================
*/

DROP TABLE IF EXISTS crm_cust_info;
CREATE TABLE crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital_status VARCHAR(50),
cst_gndr VARCHAR(50),
cst_create_data DATE
);

DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info(
prd_id INT,
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE
);

DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details(
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id INT,
sls_order_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT
);

DROP TABLE IF EXISTS erp_cust_az12;
CREATE TABLE erp_cust_az12(
CID VARCHAR(50),
BDATE DATE,
GEN VARCHAR(50)
);

DROP TABLE IF EXISTS erp_loc_a101;
CREATE TABLE erp_loc_a101(
CID VARCHAR(50),
CNTRY VARCHAR(50)
);

DROP TABLE IF EXISTS erp_px_cat_g1v2;
CREATE TABLE erp_px_cat_g1v2(
ID VARCHAR(50),
CAT VARCHAR(50),
SUBCAT VARCHAR(50),
MAINTENANCE VARCHAR(50)
);
