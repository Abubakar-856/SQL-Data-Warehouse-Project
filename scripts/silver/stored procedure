/*
===============================================================================
Stored Procedure: load_silver
===============================================================================

Purpose:
    This stored procedure loads data from the Bronze layer into the Silver layer
    by applying data cleansing, standardization, and business transformation rules.

Processing Steps:
    1. Truncate existing Silver tables.
    2. Extract raw data from Bronze tables.
    3. Clean and standardize data.
    4. Handle missing and invalid values.
    5. Remove duplicate records.
    6. Apply business rules and data quality checks.
    7. Load transformed data into the Silver layer.

Transformations Performed:
    • Standardize date formats.
    • Convert data types.
    • Replace invalid or missing values.
    • Normalize text values.
    • Calculate corrected sales and prices.
    • Deduplicate customer and product records.
    • Integrate CRM and ERP data for consistent business entities.

Source Layer:
    dw_bronze

Target Layer:
    dw_silver

Execution:
    CALL load_silver();
===============================================================================
*/



DROP PROCEDURE IF EXISTS silver_load;

DELIMITER $$

CREATE PROCEDURE silver_load()
BEGIN
		TRUNCATE TABLE dw_silver.crm_cust_info;
        INSERT INTO dw_silver.crm_cust_info (
		cst_id, 
		cst_key, 
		cst_firstname, 
		cst_lastname, 
		cst_marital_status, 
		cst_gndr, 
		cst_create_data)
	SELECT 
		cst_id,
		cst_key,
		TRIM(cst_firstname) cst_firstname,
		TRIM(cst_lastname) cst_lastname,
		 CASE WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
			WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
			ELSE 'N/A'
		END cst_marital_status,
		CASE WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
			WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
			ELSE 'N/A'
		END cst_gndr,
		cst_create_data
	FROM(
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_data DESC ) rn
	FROM dw_bronze.crm_cust_info) t
	WHERE rn = 1;

	TRUNCATE TABLE dw_silver.crm_prd_info;
	INSERT INTO dw_silver.crm_prd_info (
		prd_id, 
		cat_id, 
		prd_key, 
		prd_nm, 
		prd_cost, 
		prd_line, 
		prd_start_dt, 
		prd_end_dt)
	SELECT 
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') cat_id,
		SUBSTRING(prd_key, 7, LENGTH(prd_key)) prd_key,
		prd_nm,
		IFNULL(prd_cost, 0) prd_cost,
		CASE UPPER(TRIM(prd_line))
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'
		END prd_line,
		prd_start_dt,
		DATE_SUB(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt), INTERVAL 1 DAY)  prd_end_dt
	FROM dw_bronze.crm_prd_info;

	TRUNCATE TABLE dw_silver.crm_sales_details;
	INSERT INTO dw_silver.crm_sales_details(
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	)
	WITH corrected_price AS (
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,

			CASE
				WHEN sls_price IS NULL OR sls_price <= 0
				THEN CAST(
					sls_sales / NULLIF(sls_quantity, 0)
					AS SIGNED
				)
				ELSE ABS(CAST(sls_price AS SIGNED))
			END AS corrected_price

		FROM dw_bronze.crm_sales_details
	)

	SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,

		CASE
			WHEN sls_order_dt = 0
			  OR LENGTH(CAST(sls_order_dt AS CHAR)) != 8
			THEN NULL
			ELSE STR_TO_DATE(CAST(sls_order_dt AS CHAR), '%Y%m%d')
		END AS sls_order_dt,

		CASE
			WHEN sls_ship_dt = 0
			  OR LENGTH(CAST(sls_ship_dt AS CHAR)) != 8
			THEN NULL
			ELSE STR_TO_DATE(CAST(sls_ship_dt AS CHAR), '%Y%m%d')
		END AS sls_ship_dt,

		CASE
			WHEN sls_due_dt = 0
			  OR LENGTH(CAST(sls_due_dt AS CHAR)) != 8
			THEN NULL
			ELSE STR_TO_DATE(CAST(sls_due_dt AS CHAR), '%Y%m%d')
		END AS sls_due_dt,

		CASE
			WHEN sls_sales IS NULL
			  OR sls_sales <= 0
			  OR sls_sales != sls_quantity * corrected_price
			THEN sls_quantity * corrected_price
			ELSE sls_sales
		END AS sls_sales,

		sls_quantity,
		corrected_price AS sls_price

	FROM corrected_price;

	TRUNCATE TABLE dw_silver.erp_cust_az12;
	INSERT INTO dw_silver.erp_cust_az12(
		CID,
		BDATE,
		GEN
	)
	SELECT 
		CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID))
		ELSE CID
		END CID,
		CASE WHEN BDATE > NOW() THEN NULL
		ELSE BDATE
		END BDATE,
		CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
			WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a' 
		END GEN
	FROM dw_bronze.erp_cust_az12;

	TRUNCATE TABLE dw_silver.erp_loc_a101;
	INSERT INTO dw_silver.erp_loc_a101(CID, CNTRY)
	SELECT 
		REPLACE(CID, '-', '') CID,
		CASE 
			WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
			WHEN CNTRY IS NULL OR TRIM(CNTRY) = '' THEN 'n/a'
			ELSE TRIM(CNTRY)
			END CNTRY
	FROM dw_bronze.erp_loc_a101;

	TRUNCATE TABLE dw_silver.erp_px_cat_g1v2;
	INSERT INTO dw_silver.erp_px_cat_g1v2(
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
		)
	SELECT
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
	FROM dw_bronze.erp_px_cat_g1v2;

END $$

DELIMITER ;
