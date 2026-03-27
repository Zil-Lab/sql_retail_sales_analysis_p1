USE retail_sales_analysis;

SELECT * FROM retail_sales;

SELECT 
	COUNT(*)
FROM retail_sales;

-- show columns data types 
DESC retail_sales;

-- DATA CLEANING
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
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR 
		age IS NULL
		OR
		category IS NULL
		OR
		price_per_unit IS NULL
		or
		cogs IS NULL
		or
		total_sale IS NULL;

-- Delete any rows where the value is missing
DELETE FROM retail_sales 
	WHERE
		transactions_id IS NULL
		OR
		sale_date IS NULL
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL
		OR
		gender IS NULL
		OR 
		age IS NULL
		OR
		category IS NULL
		OR
		price_per_unit IS NULL
		or
		cogs IS NULL
		or
		total_sale IS NULL;
        
        
        -- DATA EXPLORATION 
        
        -- How many sales we have 
        SELECT COUNT(*) AS total_sales FROM retail_sales;
        
        -- How many unique customers we have 
        SELECT COUNT(DISTINCT customer_id) as total_sales FROM retail_sales;
        
        -- How many unique categories we have 
		SELECT COUNT(DISTINCT category) as total_sales FROM retail_sales;
        
        
        -- Data Analysis & Business key problems and answers 
        
        -- Q.1 write a sql query to retrieve all columns for sales made on 2022-11-05 
        SELECT *
        FROM retail_sales
        WHERE sale_date =  '2022-11-05';
        
        -- Q.2 write  a sql query to retrive all transactions where the category is "clothing" and quantity sold is more than 4 in the month of Nov 2022
        SELECT
			*
		FROM retail_sales 
        WHERE
			category = 'Clothing'
			AND 
			DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
            AND 
            quantity >= 4;
            
		-- Q.3 Write an SQL query to calculate the total_sales (total_sales) for each category
        
        SELECT
			category,
            SUM(total_sale) as net_sale, 
            COUNT(*) as total_orders
         FROM retail_sales    
         GROUP BY 1
         
         -- Q.4 Write an SQL query to find thea verage age of customers who purchases items from the 'Beauty' category .
		SELECT 
			ROUND(AVG(age), 2) AS avg_age 
		FROM retail_sales 
		WHERE category = 'Beauty';
        
        -- Q5 Write an SQL query to find all transactions where the total_sales is greater than 1000
        SELECT 
			*
		FROM retail_sales
        WHERE total_sale >= 1000;
        
        -- Q6  Write an SQL query to find the total number of transations (transactions_id) made by each gender in each category 
        SELECT 
			category,
            gender, 
            COUNT(*) as total_trans
		FROM retail_sales 
        GROUP BY
			category,
            gender 
		ORDER BY 1
            
       -- Q7 Write an SQL query to calculate the average sale for each month . Find out the best sellimg month in each year 
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
        
        -- ORDER BY 1, 3 DESC
        
       -- Q8 Write an SQL query to find the top 5 customers based on the highest total sales 
       SELECT
			customer_id,
            SUM(total_sale) as total_sales
       FROM retail_sales 
       GROUP BY customer_id
       ORDER BY total_sales DESC
       LIMIT 5;
       
       
       -- Q9 Write an SQL query to find unique customers who purchased from every category 
       SELECT
			category,
            COUNT(DISTINCT customer_id) AS cnt_of_unique_customers 
		FROM retail_sales 
        GROUP BY category
        
        -- Q10 Write an SQL query to create each shift and number of orders (example, morning<= 12, afternoon between 12 & 17, evening > 17)
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

-- End of project