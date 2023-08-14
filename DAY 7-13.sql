USE SQL1OOChallenge;

-- DAY 7 (GROUP BY AND AGGREGATE FUNCTIONS)
-- Get the total revenue, total number of products and number of transactions
-- Highest and lowest revenue recorded for each month 
SELECT MONTHNAME(order_date), SUM(revenue ), SUM(order_quantity), 
COUNT(order_date), MAX (revenue), MIN(revenue)
FROM sales
GROUP BY(order_date);

-- Get the total amount spent and total number of adverts under each agency
SELECT agency, COUNT(agency), SUM(spend)
FROM adverts
GROUP BY agency;

-- DAY 8 ORDER BY AND LIMIT CLAUSE
USE SQL1OOChallenge;

-- Write a query to return all rows from customers table sorted by name column in ascending order
SELECT *
FROM customers
ORDER BY customer_name ASC;

-- Write a query to return the bottom 5 of critical order priority in the sales table, 
-- sorted by the revenue generated in ascending order.
SELECT order_id, product_id,order_date, order_priority,
		order_quantity, delivery_date, revenue
FROM sales
WHERE order_priority LIKE '%Critical%'
ORDER BY revenue ASC
LIMIT 5;

-- Write a query to return all rows from the sales table, 
-- sorted by the order_date in ascending order and the delivery-date in descending order.
SELECT * 
FROM sales
ORDER BY order_date ASC, delivery_date DESC;

-- DAY 9 CASE FUNCTION
-- Get total sales and revenue recorded for bulk purchase (above 5 items) and retail purchases (below 5 items)

SELECT CASE
		WHEN order_quantity >= 5 THEN 'Bulk Order'
		ELSE 'Retail Order' END AS order_type,
	SUM(order_quantity) AS total_qnt_order,
	SUM(revenue) AS revenue_generated
FROM sales
GROUP BY order_type;

-- Compare weekday and weekend bulk sales
SELECT CASE
		WHEN DAY(order_date) <= 5 THEN 'Weekday'
        ELSE 'Weekend' END AS day_type,
	AVG(order_quantity) AS average_qnt_order,
    AVG(revenue) AS average_revenue
FROM sales
WHERE order_quantity > 5
GROUP BY day_type;

-- Find the advert performances within the periods of the day.
SELECT CASE
		WHEN HOUR(hour_of_day) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(hour_of_day) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(hour_of_day) BETWEEN 17 AND 23 THEN 'Evening'
        ELSE 'Night' END AS period_of_day,
	SUM(impressions) AS total_reach,
	SUM(clicks) AS total_engagement,
	SUM(spend) AS total_budget,
	SUM(spend) / SUM(clicks) AS budget_per_engagements
FROM adverts
GROUP BY period_of_day;

-- Find the distribution of customers according to their age group.
SELECT CASE
		WHEN age BETWEEN 10 AND 19 THEN 'Teenagers'
        WHEN age BETWEEN 20 AND 29 THEN '20s'
        WHEN age BETWEEN 30 AND 39 THEN '30s'
        WHEN age BETWEEN 40 AND 49 THEN '40s'
        WHEN age BETWEEN 50 AND 59 THEN '50s'
        WHEN age BETWEEN 60 AND 69 THEN '60s'
        ELSE '70+' END AS age_group,
	COUNT(*) AS NumOfCustomers
FROM customers
GROUP BY age_group
ORDER BY age_group * 1, age_group DESC;

-- DAY 10 (DATE AND TIME EXTRACTIONS)
USE SQL1OOChallenge;
-- Get the monthly average spend on adverts.
SELECT CONCAT(MONTH(ad_date), '_', MONTHNAME(ad_date)) AS ad_month,
		SUM(spend) AS total_ad_spend
FROM adverts
GROUP BY ad_month;

-- How much on the average does the business spend on shipping products to customers daily?
SELECT CONCAT(WEEKDAY(order_date), '_', DAYNAME(order_date)) AS sales_day,
AVG(shipping_cost) AS average_shipping
FROM sales
GROUP BY sales_day
ORDER BY sales_day;

-- DAY 11 (SQL INTERVIEW QUESTIONS FROM stratascratch.com)

-- 1. Count the number of movies that Abigail Breslin was nominated for an oscar.
SELECT nominee,
	COUNT(movie)AS num_of_nominations
FROM oscar_nominees
WHERE nominee = 'Abigail Breslin';

-- 2. Find the last time each bike was in use.
-- Output both  the bike number and the date-timestamp of the bike's in last use
-- (i.e., the date-time the bike was returned). Order the result by bikes that were most recently used.
SELECT bike_number,
	MAX(end_time) AS last_time_used
FROM dc_bikeshare_ql_2012
GROUP BY bike_number;

-- 3. Find the number of workers by department who joined in or after April.
-- Output the department name along with the corresponding number of workers.
-- Sort records based on the number of workers in descending order.
SELECT department,
	COUNT(worker_id) AS num_of_workers
FROM worker
WHERE MONTH(joining_date) >= 4
GROUP BY department
ORDER BY num_of_workers DESC;

-- DAY 12 (PRACTICE QUESTIONS)

-- 1. Tesla is investigating production bottlenecks and they need your help to extract the relevant data. 
-- Write a query to determine which parts have begun the assembly process but are not yet finished.
SELECT part, assembly_step 
FROM parts_assembly
WHERE finish_date IS NULL;

-- 2. You're trying to find the mean number of items per order on Alibaba, 
-- rounded to 1 decimal place using tables 
-- which includes information on the count of items in each order (item_count table) 
-- and the corresponding number of orders for each item count (order_occurrences table).
SELECT ROUND(1.0 * SUM(item_count * order_occurrences) / SUM(order_occurrences),1) AS mean
FROM items_per_order
GROUP BY item_count;

-- 3. CVS Health is trying to better understand its pharmacy sales, and how well different products are selling. 
-- Each drug can only be produced by one manufacturer.
-- Write a query to find the top 3 most profitable drugs sold, and how much profit they made. 
-- Assume that there are no ties in the profits. Display the result from the highest to the lowest total profit.
SELECT drug,
SUM( total_sales - cogs) AS total_profit
FROM pharmacy_sales
GROUP BY drug
ORDER BY total_profit DESC
LIMIT 3;


-- DAY 13 (INTERVIEW PRACTICE QUESTION FROM hackerrank.com)

-- 1. Query a list of CITY and STATE from the STATION table.
SELECT city, state
FROM station;

-- 2. Query the difference between the maximum and minimum populations in CITY.
SELECT MAX(population), MIN(population),
SUM(MAX(population) - MIN(population)) population_diff
FROM city;

-- 3. Given the CITY and COUNTRY tables, query the names of all cities where the CONTINENT is 'Africa'.
-- Note: CITY.CountryCode and COUNTRY.Code are matching key columns.
SELECT city.name
FROM city
JOIN country
    ON city.countrycode = country.code
    WHERE continent LIKE 'Africa';

-- Query the sum of Northern Latitudes (LAT_N) from STATION 
-- having values greater than 38.7880  and less than 137.2345 . Truncate your answer to  decimal places.
SELECT ROUND(SUM(lat_n),4)
FROM STATION
WHERE lat_n > 38.7880 AND lat_n < 137.2345;