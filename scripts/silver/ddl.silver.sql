/*
===============================================================================
DDL Script: Create Silver Layer Tables
===============================================================================

Purpose:
    This script creates the tables for the Silver layer of the data warehouse.
    The Silver layer stores cleansed, standardized, and validated data that
    serves as the foundation for dimensional modeling and analytics.

Layer Description:
    The Silver layer transforms raw Bronze data into high-quality datasets by
    applying data cleansing, standardization, and business rules while
    preserving the original business meaning.

Tables Created:
    • crm_cust_info
    • crm_prd_info
    • crm_sales_details
    • erp_cust_az12
    • erp_loc_a101
    • erp_px_cat_g1v2

Design Principles:
    • Appropriate data types for each business attribute
    • Consistent naming conventions
    • Primary keys where applicable
    • Optimized for transformation and downstream analytics
    • Supports incremental and full data loads

Source Layer:
    dw_bronze

Target Layer:
    dw_silver

Notes:
    • Existing tables are dropped before being recreated.
    • This script defines the Silver layer structure only.
    • Data is loaded separately through the load_silver() stored procedure.

===============================================================================
*/


USE dw_silver;

DROP TABLE IF EXISTS crm_cust_info;
CREATE TABLE crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname VARCHAR(50),
cst_lastname VARCHAR(50),
cst_marital_status VARCHAR(50),
cst_gndr VARCHAR(50),
cst_create_data DATE,
dwh_create_date DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS crm_prd_info;
CREATE TABLE crm_prd_info(
prd_id INT,
cat_id NVARCHAR(50),
prd_key VARCHAR(50),
prd_nm VARCHAR(50),
prd_cost INT,
prd_line VARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS crm_sales_details;
CREATE TABLE crm_sales_details(
sls_ord_num VARCHAR(50),
sls_prd_key VARCHAR(50),
sls_cust_id INT,
sls_order_dt DATE,
sls_ship_dt DATE,
sls_due_dt DATE,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS erp_cust_az12;
CREATE TABLE erp_cust_az12(
CID VARCHAR(50),
BDATE DATE,
GEN VARCHAR(50),
dwh_create_date DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS erp_loc_a101;
CREATE TABLE erp_loc_a101(
CID VARCHAR(50),
CNTRY VARCHAR(50),
dwh_create_date DATETIME DEFAULT NOW()
);

DROP TABLE IF EXISTS erp_px_cat_g1v2;
CREATE TABLE erp_px_cat_g1v2(
ID VARCHAR(50),
CAT VARCHAR(50),
SUBCAT VARCHAR(50),
MAINTENANCE VARCHAR(50),
dwh_create_date DATETIME DEFAULT NOW()
);
