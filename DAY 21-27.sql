-- DAY 21 (UNION AND HAVING STATEMENTS)

-- Write a query that returns movie with their lowest and highest budget attached to their review score.
(SELECT title, budget, review_score
FROM movies
ORDER BY budget DESC
LIMIT 1)

UNION

(SELECT title, budget, review_score
FROM movies
ORDER BY budget
LIMIT 1);

/* Given a table of Facebook posts, for each user who posted at least twice in 2021, 
write a query to find the number of days between each user’s first post of the year 
and last post of the year in the year 2021. 
Output the user and number of the days between each user's first and last post.*/
SELECT user_id, EXTRACT(DAY FROM(MAX(post_date) - MIN(post_date)))AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING COUNT(post_id) > 1;


/* DAY 22 (SQL JOIN)
Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'
NOTE: CITY.CountryCode and COUNTRY.code are matching key columns.*/
SELECT SUM(city.population) AS total_population
FROM city
JOIN country
ON city.countrycode = country.code
WHERE country.continent = 'Asia';

/*You were provided with 11 tables of dataset pertaining to the startup ecosystem. 
Write a query that returns the top ten African startups in history*/
SELECT ob.name, co.name AS country, ob.funding_total_usd
FROM objects AS ob
JOIN countries AS co
ON ob.country_code = co.country_code
WHERE co.region = 'Africa'
ORDER BY ob.funding_total_usd DESC
LIMIT 10;

/*Find all posts which were reacted to with a heart. 
For such posts output all columns from facebook_posts table.*/
SELECT DISTINCT fp. *
FROM facebook_reactions AS fr
JOIN facebook_posts fp
	ON fr.post_id = fp.post_id
WHERE fr.reaction LIKE 'heart';

-- DAY 24 (INNER JOIN)
/* Given a transaction and customer's table, 
write a query to return the total number of product purchased by each customer.*/
SELECT t.NumOfProducts, COUNT(t.NumOfProducts) AS NumOfCustomers
FROM transaction t
INNER JOIN customer c
ON t.CustomerId = c.CustomerId
GROUP BY NumofProducts
ORDER BY NumOfCustomers;

/*A retail store which has outlet across France, Germany and Spain 
is trying to ascertain the performance of each country.
Write a query that returns total sales recorded for each region for year 2022*/
SELECT g.Country, SUM(t.NumOfProducts) AS TotalProductSales
FROM geography g
INNER JOIN transaction t
ON g.GeoId = t.GeoId
WHERE YEAR(t.date) = 2022
GROUP BY g.Country
ORDER BY g.Country;

-- DAY 25 (FULL/ OUTER JOINS)
/* Return the entire rows and columns from the customers and card orders table for American Express*/
SELECT *
FROM customers cu
FULL JOIN card_orders co
ON cu.id = co.order_id;

-- Alternatively with the use of MySQL
SELECT *
FROM customers cu
LEFT JOIN card_orders co
ON cu.id = co.order_id

UNION ALL

SELECT *
FROM customers cu
RIGHT JOIN card_orders co
ON cu.id = co.order_id;

/* Given shopify_carrier and shopify_order table of shopify database query to access 
all entries of shopify carriers and matching column of the shopify orders*/
SELECT *
FROM shopify_carriers sc
LEFT JOIN shopify_orders so
ON sc.id = so.order_id;

/* Salesforce ask to write query that returns the entire column
 of the sales table combined with the matching columns of the product table*/
SELECT *
FROM dim_products dp
RIGHT JOIN fct_customers_sales fc
ON dp.prod_sku_id = fc.prod_sku_id; 

-- DAY 26 (SELF JOIN)
/* Given an employee table whose manager_id are extracted from employee_id but in seperate columns, 
write a query to show count of employees under each manager in descending order*/
SELECT m.employee_id, 
		CONCAT(m.first_name, " ", m.last_name) AS manager_name, 
        COUNT(m.employee_id) AS total_employee
FROM employee m
SELF JOIN employee e
ON m.employee_id = e.manager_id
GROUP BY m.employee_id;

-- Alternatively:

SELECT m.employee_id, 
		CONCAT(m.first_name, " ", m.last_name) AS managers_name, 
        COUNT(m.employee_id) AS total_employee
FROM employee m ,employee e
WHERE m.employee_id = e.manager_id
GROUP BY m.employee_id;

/* From the question above, with an extra department table, 
display the managers and the reporting employee who work in different departments.*/
SELECT CONCAT(m.first_name, " ", m.last_name) AS managers_name,
		CONCAT(e.first_name, " ", e.last_name) AS reporting_employee,
		d.department_name AS rep_employeee_dept
FROM employee m
JOIN employee e ON m.employee_id = e.manager_id
JOIN departments d ON e.department_id = d.department_id
ORDER BY managers_name;

-- DAY 27 (CROSS JOIN)
/* The English Premier League in the preparation for the 2023/2024 season 
tasked you as the junior Data Analyst to generate all match fixtures for the season*/
SELECT CONCAT(h.team_name,'VS', a.team_name) AS fixtures
FROM home_team h
CROSS JOIN away_team a
WHERE h.team_name != a.team_name;

/* A company looking to post different employess to head different departments in turns, 
write a query that returns different combination of employees and department they are to manage*/
SELECT CONCAT(e.first_name, " ", e.last_name) AS manager_name, d.dept_name
FROM employees e
INNER JOIN dept_manager dm
ON e.emp_no = d.emp_no
CROSS JOIN departments departments
ORDER BY manager_name;
