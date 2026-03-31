select * from `workspace`.`default`.`bright_coffee_shop_analysis` limit 1000000;

 -- 1. create total amount column
SELECT *,
       transaction_qty * unit_price AS Revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 2. Total Revenue
SELECT 
    SUM(transaction_qty * unit_price) AS total_revenue
    from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 3. Total Transactions
SELECT COUNT(*) AS total_transactions
from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 4. Unique Products Sold
SELECT COUNT(DISTINCT product_id) AS unique_products
from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 5. Unique Stores
SELECT COUNT(DISTINCT store_id) AS total_stores
from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 6. Revenue by Product Category
SELECT product_category,
       SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_category
ORDER BY revenue DESC;

-- 7. Revenue by Product Type
SELECT product_type,
       SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_type
ORDER BY revenue DESC;

-- 9. Quantity Sold by Product Category
SELECT product_category,
       SUM(transaction_qty) AS total_units
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_category;

-- 10. Average Price per Product Category
SELECT product_category,
       AVG(unit_price) AS avg_price
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_category;

-- 11. Top 5 Products by Revenue
SELECT product_detail,
       SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_detail
ORDER BY revenue DESC
LIMIT 5;

-- 12. Bottom 5 Products by Revenue
SELECT product_detail,
       SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_detail
ORDER BY revenue ASC
LIMIT 5;

-- 13. Revenue by Store Location
SELECT store_location,
       SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY store_location;

-- 14. Number of Sales per Store
SELECT store_location,
       COUNT(*) AS total_sales
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY store_location;

-- 15. Average Transaction Value per Store
SELECT store_location,
       AVG(transaction_qty * unit_price) AS avg_transaction_value
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY store_location;

-- 16. Best Performing Store
SELECT store_location,
       SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY store_location
ORDER BY revenue DESC
LIMIT 1;

-- 17. Revenue by Hour
SELECT EXTRACT(HOUR FROM transaction_time) AS hour,
       SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY hour
ORDER BY hour;

-- 18. Number of Sales by Hour
SELECT EXTRACT(HOUR FROM transaction_time) AS hour,
       COUNT(*) AS sales_count
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY hour;

-- 19. Peak Hour
SELECT EXTRACT(HOUR FROM transaction_time) AS hour,
       SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY hour
ORDER BY revenue DESC
LIMIT 1;

-- 20. Time Bucket (30 mins)
SELECT *,
       DATE_TRUNC('hour', transaction_time) +
       INTERVAL '30 minutes' * FLOOR(EXTRACT(MINUTE FROM transaction_time)/30)
       AS time_bucket
from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 21. Revenue by Time Bucket
SELECT 
    DATE_TRUNC('hour', transaction_time) +
    INTERVAL '30 minutes' * FLOOR(EXTRACT(MINUTE FROM transaction_time)/30)
    AS time_bucket,
    SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY time_bucket
ORDER BY time_bucket;

-- 22. Sales Trend by Date
SELECT transaction_date,
       SUM(transaction_qty * unit_price) AS daily_revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY transaction_date
ORDER BY transaction_date;

-- 23. Day Name
SELECT transaction_date,
       TO_CHAR(transaction_date, 'Day') AS day_name
from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 24. Revenue by Day Name
SELECT TO_CHAR(transaction_date, 'Day') AS day_name,
       SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY day_name;

-- 25. Weekday vs Weekend (CASE)
SELECT 
    CASE 
        WHEN EXTRACT(DOW FROM transaction_date) IN (0,6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    SUM(transaction_qty * unit_price) AS revenue
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY day_type;

-- 26. Start Date & End Date
SELECT MIN(transaction_date) AS start_date,
       MAX(transaction_date) AS end_date
from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 27. Number of Sales per Day
SELECT transaction_date,
       COUNT(*) AS sales_count
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY transaction_date;

-- 28. Classify Time of Day
SELECT *,
    CASE 
        WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM transaction_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
from `workspace`.`default`.`bright_coffee_shop_analysis`;

--29. Time of day classification
    SELECT *,
    CASE 
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:00' THEN '01.Rush Hour'
        WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '09:00:00' AND '11:59:00'  THEN '02.Mid Morning'
        WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '12:00:00' AND '15:59:00'  THEN '03.Afternoon'
         WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '16:00:00' AND '18:00:00'  THEN '01.Rush Hour'
        ELSE '05.Night'
    END AS time_classification
    from `workspace`.`default`.`bright_coffee_shop_analysis`;


-- 30. High vs Low Value Transactions
SELECT 
    CASE 
        WHEN transaction_qty * unit_price > 20 THEN 'High Value'
        ELSE 'Low Value'
    END AS transaction_type,
    COUNT(*) AS count_transactions
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY transaction_type;

-- 31. Product Performance Classification
SELECT product_detail,
       SUM(transaction_qty * unit_price) AS revenue,
       CASE 
           WHEN SUM(transaction_qty * unit_price) > 1000 THEN 'Top Performer'
           ELSE 'Low Performer'
       END AS performance
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_detail;

-- 32. Store Performance Classification
SELECT store_location,
       SUM(transaction_qty * unit_price) AS revenue,
       CASE 
           WHEN SUM(transaction_qty * unit_price) > 5000 THEN 'High Performing'
           ELSE 'Needs Improvement'
       END AS performance
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY store_location;

--33. spend category
 SELECT transaction_id,
        transaction_qty,
        unit_price,
        CASE 
          WHEN (transaction_qty * unit_price)<=50 THEN '01.Low Spender'
         WHEN (transaction_qty * unit_price) BETWEEN 51 AND 200 THEN '02.Medium Spender'
          WHEN (transaction_qty * unit_price) BETWEEN 201 AND 300 THEN '03.Moreki'
          ELSE '04.Blesser'
         END AS spend_bucket
         from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 34. Average Items per Transaction
SELECT AVG(transaction_qty) AS avg_items_per_transaction
from `workspace`.`default`.`bright_coffee_shop_analysis`;

-- 35. Distinct Products per Store
SELECT store_location,
       COUNT(DISTINCT product_id) AS unique_products
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY store_location;

-- 36. Revenue Contribution %
SELECT product_category,
       SUM(transaction_qty * unit_price) AS revenue,
       ROUND(100.0 * SUM(transaction_qty * unit_price) / 
            SUM(SUM(transaction_qty * unit_price)) OVER (), 2) AS revenue_percentage
from `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY product_category;

--37. extrascting the day and month names
SELECT 
    transaction_date,
    Dayname(transaction_date) AS Day_name,
    Monthname(transaction_date) AS Month_name
    from `workspace`.`default`.`bright_coffee_shop_analysis`;

--create final dataset
   CREATE OR REPLACE TABLE bright_coffee_shop_analysis_final AS
SELECT 
    transaction_id,
    transaction_date,
    transaction_time,
    store_id,
    store_location,
    product_id,
    product_category,
    product_type,
    product_detail,
    transaction_qty,
  --unit_price already clean
   unit_price,
    
    --total sales
    transaction_qty * unit_price AS total_sales,

   --revenue
   transaction_qty * unit_price AS Revenue,

    -- Time bucket
    DATE_TRUNC('hour', transaction_time) +
    INTERVAL '30 minutes' * FLOOR(EXTRACT(MINUTE FROM transaction_time)/30) AS time_bucket,
    -- Time of day classification
    CASE 
        WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '05:00:00' AND '08:59:00' THEN '01.Rush Hour'
        WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '09:00:00' AND '11:59:00'  THEN '02.Mid Morning'
        WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '12:00:00' AND '15:59:00'  THEN '03.Afternoon'
         WHEN date_format(transaction_time,'HH:MM:SS') BETWEEN '16:00:00' AND '18:00:00'  THEN '01.Rush Hour'
        ELSE '05.Night'
    END AS time_classification,
    --spend bucket
    CASE 
          WHEN (transaction_qty * unit_price)<=50 THEN '01.Low Spender'
         WHEN (transaction_qty * unit_price) BETWEEN 51 AND 200 THEN '02.Medium Spender'
          WHEN (transaction_qty * unit_price) BETWEEN 201 AND 300 THEN '03.Moreki'
          ELSE '04.Blesser'
         END AS spend_bucket,

    -- Day name
    Dayname(transaction_date) AS Day_name,
    --month name
    Monthname(transaction_date) AS Month_name,
    --day of month
    Dayofmonth(transaction_date) AS date_of_month,
    
    CASE
         WHEN Dayname(transaction_date) IN ('Sunday','Saturday') THEN 'Weekend'
        ELSE 'Weekday'
        END AS Day_classifiction

from `workspace`.`default`.`bright_coffee_shop_analysis`;

SELECT * from bright_coffee_shop_analysis_final LIMIT 1000000;
