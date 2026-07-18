/*
===============================================================================
DDL Script: Gold Layer Views
===============================================================================

Purpose:
    This script creates the Gold layer views for the data warehouse.
    The Gold layer presents business-ready, analytics-optimized data
    organized using a dimensional model (Star Schema) to support reporting,
    dashboards, and business intelligence.

Layer Description:
    The Gold layer integrates cleansed Silver layer data into
    dimension and fact views, providing a single source of truth
    for analytical workloads.

Objects Created:
    • dim_customers
    • dim_products
    • fact_sales

Business Model:
    • Customer Dimension
    • Product Dimension
    • Sales Fact

Design Principles:
    • Star Schema architecture
    • Surrogate keys generated using ROW_NUMBER()
    • Business-friendly column names
    • Integrated CRM and ERP data
    • Optimized for analytical queries and BI reporting

Source Layer:
    dw_silver

Target Layer:
    dw_gold

Dependencies:
    • dw_silver.crm_cust_info
    • dw_silver.crm_prd_info
    • dw_silver.crm_sales_details
    • dw_silver.erp_cust_az12
    • dw_silver.erp_loc_a101
    • dw_silver.erp_px_cat_g1v2

Notes:
    • Gold objects are implemented as SQL views.
    • Customer and product dimensions integrate data from both CRM and ERP systems.
    • The Sales fact view references the dimension views through surrogate keys.
    • These views are intended for reporting, dashboarding, and business analytics.

===============================================================================
*/

CREATE VIEW dw_gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY ca.cst_id) customer_key,
	ca.cst_id customer_id,
    ca.cst_key customer_number,
    ca.cst_firstname firs_tname,
    ca.cst_lastname last_name,
    cc.CNTRY country,
    ca.cst_marital_status marital_status,
    CASE WHEN ca.cst_gndr != 'N/A' THEN ca.cst_gndr
    ELSE COALESCE(cb.GEN, 'N/A')
    END Gender,
    cb.BDATE birthday,
    ca.cst_create_data creation_date
FROM dw_silver.crm_cust_info ca
LEFT JOIN dw_silver.erp_cust_az12 cb
ON ca.cst_key = cb.CID
LEFT JOIN dw_silver.erp_loc_a101 cc
ON ca.cst_key = cc.CID;

CREATE VIEW dw_gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY pa.prd_start_dt, pa.prd_key) product_key,
	pa.prd_id product_id,
	pa.prd_key product_number,
    pa.prd_nm product_name,
    pa.cat_id category_id,
    pb.CAT category,
    pb.SUBCAT subcategory,
    pb.MAINTENANCE maintenance,
    pa.prd_cost cost,
    pa.prd_line product_line,
    pa.prd_start_dt start_date
FROM dw_silver.crm_prd_info pa
LEFT JOIN dw_silver.erp_px_cat_g1v2 pb
ON pa.cat_id = pb.ID
WHERE pa.prd_end_dt IS NULL;

CREATE VIEW dw_gold.fact_sales AS
SELECT 
	s.sls_ord_num order_number,
    p.product_key,
    c.customer_key,
    s.sls_order_dt order_date,
    s.sls_ship_dt shipping_date,
    s.sls_due_dt due_date,
    s.sls_sales sales_amount,
    s.sls_quantity quantity,
    s.sls_price price
FROM dw_silver.crm_sales_details s
LEFT JOIN dw_gold.dim_products p
ON s.sls_prd_key = p.product_number
LEFT JOIN dw_gold.dim_customers c
ON s.sls_cust_id = c.customer_id;
