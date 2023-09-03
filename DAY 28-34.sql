-- DAY 28 (SUBQUERIES)
/*Find all the athletes who were older than 40yrs when they won either bronze or silver medals.*/
SELECT * FROM
	( SELECT name, age, medal
	FROM olympics_athletes_events
	WHERE medal IN ('Bronze', 'Silver')) AS winners
WHERE age > 40
ORDER BY name;

/* How many customer's are qualified for a raffle draw ($5000 total order worth or over 20 different transactions)*/
SELECT COUNT(customer_name) AS eligible_customers
FROM (
		SELECT c.customer_name, SUM(s.revenue) AS total_revenue,
        COUNT(s.customer_id) AS total_transaction
		FROM customers c
		INNER JOIN sales s
		ON c.customer_id = s.customer_id
		GROUP BY c.customer_name
		ORDER BY c.customer_name
	) AS cust
WHERE total_revenue > 5000 OR total_transaction > 20;

/* From the adverts table write a query to return details of when we spent more than average budget for adverts*/
SELECT *
FROM adverts
WHERE spend > (SELECT AVG(spend)
				FROM adverts);
                
-- DAY 29 (SQL PRACTICE)
/* Assuming you are given two tables containing data about Facebook Pages 
and their respective likes (as in 'like a Facebook Page')
Write a query to return the IDs of the Facebook pages that have zero likes. 
The output should be sorted in ascending order based on the page IDs.*/
SELECT pa.page_id
FROM pages pa
LEFT JOIN page_likes pl
ON pa.page_id = pl.page_id
WHERE pl.page_id IS NULL;

-- WEATHER OBSERVATION STATION 5 (hackerrank.com)
/* Query the two cities in STATION with the shortest and longest CITY names, 
as well as their respective lengths (i.e.: number of characters in the name). 
If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.*/
(SELECT city, 
LENGTH(city)
FROM station
ORDER BY LENGTH(city), city ASC
LIMIT 1)

UNION

(SELECT city, 
LENGTH(city)
FROM station
ORDER BY LENGTH(city), city DESC
LIMIT 1);

-- WEATHER OBSERVATION STATION 7 (hackerrank.com)
/* Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. 
Your result cannot contain duplicates.*/
SELECT DISTINCT city
FROM station 
WHERE RIGHT(city,1) IN ('a','e','i','o','u');

/* Assume you are given tables with information about TikTok user sign-ups 
and confirmations through email and text. 
New users on TikTok sign-up using their email addresses
and upon sign up, each user recieves a text confirmation to activate their account. 
Write a query to display the user IDs of those who did not confirm their sign-up on the first day, 
but confirm on the second day.*/
SELECT e.user_id
FROM emails e
INNER JOIN texts t
ON e.email_id = t.email_id
WHERE t.signup_action = 'Confirmed' AND (EXTRACT(DAY FROM t.action_date) - EXTRACT(DAY FROM t.signup_date)) = 1;

/* Given the reviews table, write a query to retrieve the average star ratings of each product, grouped by month. 
The output should display the month as a numerical value, product ID 
and average star rating rounded to two decimal places. 
Sort the first by month and then by product ID.*/
SELECT EXTRACT(MONTH FROM submit_date) AS month, 
product_id, ROUND(AVG(stars), 2) AS avg_review
FROM reviews
GROUP BY EXTRACT(MONTH FROM submit_date), product_id
ORDER BY month, product_id;

/* Given the reviews table, write a query to retrieve the average star ratings of each product, grouped by month. 
The output should display the month as a numerical value, product ID 
and average star rating rounded to two decimal places. 
Sort the first by month and then by product ID.*/
SELECT EXTRACT(MONTH FROM submit_date) AS month, 
product_id, ROUND(AVG(stars), 2) AS avg_review
FROM reviews
GROUP BY EXTRACT(MONTH FROM submit_date), product_id
ORDER BY month, product_id;

-- DAY 30 (Datalemur.com)

-- PHARMACY ANALYTICS (PART 1)
/* CVS Health is trying to better understand its pharmacy sales, and how well different products are selling. 
Each drug can only be produced by one manufacturer.
Write a query to find the top 3 most profitable drugs sold, 
and how much profit they made. Assume that there are no ties in the profits. 
Display the result from the highest to the lowest total profit.*/
SELECT drug,
SUM( total_sales - cogs) AS total_profit
FROM pharmacy_sales
GROUP BY drug
ORDER BY total_profit DESC
LIMIT 3;

-- PHARMACY ANALYTICS (PART 2)
/* CVS Health is analyzing its pharmacy sales data, and how well different products are selling in the market. 
Each drug is exclusively manufactured by a single manufacturer.
Write a query to identify the manufacturers associated with the drugs that resulted in losses for CVS Health 
and calculate the total amount of losses incurred.
Output the manufacturer's name, the number of drugs associated with losses, and the total losses in absolute value. 
Display the results sorted in descending order with the highest losses displayed at the top.*/
SELECT manufacturer, 
  COUNT(drug) AS drug_count, 
  SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;

-- PHARMACY ANALYTICS (PART 3)
/* CVS Health wants to gain a clearer understanding of its pharmacy sales and the performance of various products.
Write a query to calculate the total drug sales for each manufacturer. 
Round the answer to the nearest million and report your results in descending order of total sales. 
In case of any duplicates, sort them alphabetically by the manufacturer name.
Since this data will be displayed on a dashboard viewed by business stakeholders, 
please format your results as follows: "$36 million".*/
SELECT manufacturer, 
CONCAT('$', ROUND(SUM(total_sales) / 1000000, 0), ' ', 'million') AS drug_sales
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC;

-- DAY 31 (JOIN PRACTICE)
/* Given the facebook_reactions and facebook_posts table. Find all the posts which were reacted to with a hearts.
For such posts output all columns from facebook_posts table*/ 
SELECT fp.*
FROM facebook_reactions fr 
RIGHT JOIN facebook_posts fp
ON fp.post_id = fr.post_id
WHERE fr.reactions = 'heart';

/* Write a query that calculates the difference between highest salaries found in the marketing
 and engineering departments.
Output just the absolute difference in salaries.*/
SELECT ABS(
		(SELECT MAX(emp.salary) 
		FROM db_employee AS emp
		JOIN db_dept AS dept
		ON emp.department_id = dept.id
		WHERE dept.department = 'engineering')
-
		(SELECT MAX(emp.salary) 
		FROM db_employee AS emp
		JOIN db_dept AS dept
		ON emp.department_id = dept.id
		WHERE dept.department = 'marketing')
) AS salary_diff
FROM db_employee e
JOIN db_dept d
ON e.department_id = d.d_id;

-- HIGHEST ENERGY CONSUMPTION (stratscratch.com)
/* Find the date with the highest total energy consumption from the Meta/Facebook data centers. 
Output the date along with the total energy consumption across all data centers.*/

SELECT date , SUM(consumption) AS total_energy 
FROM 
    (SELECT * FROM fb_eu_energy 
    UNION ALL 
    SELECT * FROM fb_asia_energy 
    UNION ALL
    SELECT * FROM fb_na_energy) a 
GROUP BY date 
ORDER BY date DESC LIMIT 0,2;

-- DAY 33 (SQL PRACTICE USING stratscratch.com)
/*1. NUMBER OF BATHROOMS AND BEDROOMS
Find the average number of bathrooms and bedrooms for each city’s property types. 
Output the result along with the city name and the property type.*/
SELECT city, property_type, 
        AVG(bathrooms) AS bathrooms_avg, 
        AVG(bedrooms) AS bedrooms_avg
FROM airbnb_search_details
GROUP BY city, property_type;

/* 2. COUNT THE NUMBER OF USER EVENTS PERFORMED BY MACBOOK PRO USERS.
Count the number of user events performed by MacBookPro users.
Output the result along with the event name.
Sort the result based on the event count in the descending order.*/
SELECT event_name, COUNT(*) AS event_count
FROM playbook_events
WHERE device LIKE 'macbook pro'
GROUP BY event_name
ORDER BY event_count DESC;

/* 3. FIND THE MOST PROFITABLE COMPANY IN THE FINANCIAL SECTOR OF THE WORLD ALONG WITH ITS CONTINENT.
Find the most profitable company from the financial sector. Output the result along with the continent.*/
SELECT company, continent
from forbes_global_2010_2014
WHERE sector = 'Financials'
        AND profits = (SELECT MAX(profits)
                        FROM forbes_global_2010_2014
                        WHERE sector = 'Financials');

/* 4. CHURRO ACTIVITY DATE.
Find the activity date and the pe_description of facilities with the name 'STREET CHURROS' 
and with a score of less than 95 points.*/
SELECT activity_date, pe_description
FROM los_angeles_restaurant_health_inspections
WHERE facility_name = 'STREET CHURROS' AND score < 95 ;

-- DAY 34 (CASE STUDY)
/* PROBLEM STATEMENT: A business is looking to migrate its data from the traditional single Microsoft Excel to an 
emcompassing database system , and also needs a little bit of insight 
into how its business have fared over the month since inception.*/

/* DATA MIGRATION SOLUTION: On accessing the parent data, the table was divided into 3 different parts, 
which includes; Customer, Transactions and Geography tables.*/

-- INSIGHTS:
/* What is the age distribution of the business patronage from the customers? 
The age should be grouped into teens, 20s, 30s, and so on.*/
SELECT (CASE
			WHEN Age BETWEEN 10 AND 19 THEN 'Teenagers'
			WHEN Age BETWEEN 20 AND 29 THEN '20s'
            WHEN Age BETWEEN 30 AND 39 THEN '30s'
            WHEN Age BETWEEN 40 AND 49 THEN '40s'
            WHEN Age BETWEEN 50 AND 59 THEN '50s'
            WHEN Age BETWEEN 60 AND 69 THEN '60s'
            ELSE '70+'
		END) AS AgeGrp,
COUNT(*) AS NumOfCust
FROM customer
GROUP BY AgeGrp
ORDER BY AgeGrp * 1, AgeGrp DESC;

/* Which customer age of which business branch has the highest average credit score?*/
SELECT c.Age,
	AVG(CASE 
		WHEN g.Country LIKE '%France%' THEN c.CreditScore
		ELSE NULL 
		END) AS France,
	AVG(CASE 
		WHEN g.Country LIKE '%Germany%' THEN c.CreditScore
		ELSE NULL 
		END) AS Germany,
	AVG(CASE 
		WHEN g.Country LIKE '%Spain%' THEN c.CreditScore
		ELSE NULL 
		END) AS Spain,
    AVG(c.CreditScore) AS Avg_Crd_Scr
FROM customer c
INNER JOIN tranbsaction t
ON c.CustomerId = t.CustomerId
INNER JOIN geography g
ON t.GeoId = t. GeoId
GROUP BY c.Age
ORDER BY c.Age;