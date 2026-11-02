# E-Commerce Sales Data Warehouse & Analytics

## Project Overview

This project focuses on designing and implementing an E-Commerce Sales Data Warehouse using MySQL and SQL. It follows a layered data architecture to organise transactional data for structured storage and analytical reporting.

## Technologies Used

- MySQL
- SQL
- Data Warehousing
- ETL (Extract, Transform, Load)
- Star Schema

## Data Warehouse Architecture

The project follows these processing layers:

1. **Raw Data Layer** – Stores the original e-commerce transactional data.
2. **Staging Layer** – Prepares the extracted data for further processing.
3. **Operational Data Store (ODS)** – Organises integrated operational data.
4. **Data Warehouse (DWH)** – Stores structured data for analytical purposes.

## Key Implementations

- Data extraction and transformation using SQL.
- Data loading across warehouse layers.
- SQL JOIN operations for integrating transactional data.
- Fact and dimension table design.
- Data quality validation.
- Sales Data Mart design for business reporting.

## Repository Structure

```text
ecommerce-data-warehouse/
├── sql/
│   ├── ECOM RAW DATA.sql
│   ├── ECOM_STAGING.sql
│   ├── ECOM_ODS.sql
│   └── ECOM_DWH.sql
├── data/
│   ├── ECOM SAMPLE DATA.txt
│   └── INSERT DATA.txt
├── README.md
└── .gitignore
```

## Execution

1. Install and configure MySQL.
2. Review the SQL scripts in the `sql/` directory.
3. Prepare the required database environment.
4. Execute the scripts in their appropriate dependency order.
5. Verify the created tables and loaded records.

## Learning Outcomes

- Understanding layered data warehouse architecture.
- Practical SQL development.
- ETL workflow implementation.
- Relational database integration.
- Data warehouse modelling.

## Author

Krishna Prasath DS