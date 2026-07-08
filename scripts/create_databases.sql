/*
===============================================================================
Script Name : create_databases.sql

Description :
    This script creates the databases used for the Modern Data Warehouse
    architecture.

    Database Layers:
    - dw_bronze : Stores raw data ingested from source systems.
    - dw_silver : Stores cleansed, standardized, and transformed data.
    - dw_gold   : Stores business-ready dimensional models and fact tables
                  used for reporting and analytics.

WARNING:
    - Execute this script only once when setting up the project.
    - The IF NOT EXISTS clause prevents errors if a database already exists.
    - This script does NOT delete or overwrite any existing databases.

===============================================================================
*/

CREATE DATABASE IF NOT EXISTS dw_bronze;

CREATE DATABASE IF NOT EXISTS dw_silver;

CREATE DATABASE IF NOT EXISTS dw_gold;
