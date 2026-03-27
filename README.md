# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_sales_analysis`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_sales_analysis`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_sales_analysis;
```

###2. Data Cleaning 
Since I imported all data as text to avoid trucation I have to clean up the raw data before proceeding with analysis. 
- **Convert empty strings to proper NULLs for all numeric columns**: ie age, quantity, cogs and total_sales
- **Correct columns data type**: Modified the columns to the right data types.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```-- SQL DATA CLEANING
-- Convert empty strings to proper NULLs for all numeric columns
UPDATE `retail_sales` 
SET 
	age = NULLIF(age, ''),
    quantity = NULLIF(quantity, ''),
    price_per_unit = NULLIF(price_per_unit, ''),
    cogs = NULLIF(cogs, ''),
    total_sale = NULLIF(total_sale, '');

-- modify columns to the right data types 
ALTER TABLE retail_sales 
MODIFY COLUMN `sale_date` DATE,
MODIFY COLUMN `sale_time` TIME,
MODIFY COLUMN `gender` VARCHAR(15),
MODIFY COLUMN `age` INT,
MODIFY COLUMN `category` VARCHAR(15),
MODIFY COLUMN `quantity` INT,
MODIFY COLUMN `price_per_unit` FLOAT,
MODIFY COLUMN `cogs` FLOAT,
MODIFY COLUMN `total_sale` FLOAT;

-- check all the columns for null
SELECT * FROM retail_sales
	WHERE 
		transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
		gender IS NULL OR age IS NULL OR category IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR
		total_sale IS NULL;

-- Delete any rows where the value is missing
DELETE FROM retail_sales 
	WHERE
		transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
		gender IS NULL OR age IS NULL OR category IS NULL OR price_per_unit IS NULL OR cogs IS NULL OR
		total_sale IS NULL;
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
    AND
    quantity >= 4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT * FROM 
(
	SELECT 
		YEAR(sale_date),
		MONTH(sale_date),
		AVG(total_sale) as avg_sale, 
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) as sales_rank 
	FROM retail_sales 
	GROUP BY 1, 2 
) as t1 
WHERE sales_rank = 1;
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_customers
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
 WITH hourly_sale
    AS
    (
        SELECT *,
            CASE 
                WHEN HOUR(sale_time) < 12 THEN 'Morning'
                WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
                ELSE 'Evening'
            END AS shift 
        FROM retail_sales
    )
SELECT 
	shift,
    COUNT(*) AS total_orders 
FROM hourly_sale
GROUP BY shift 
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project covers database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## Author - Zilpah Mbuvi

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

- **LinkedIn**: [Connect with me professionally](https://www.linkedin.com/in/zilpahmbuvi/)]
