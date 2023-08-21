-- DAY 14 (Further Practice with hackerrank.com)

-- 1. Query all columns for all American cities in the CITY table with populations larger than 100000. 
-- The CountryCode for America is USA.
SELECT *
FROM CITY
WHERE population > 100000 AND countrycode = 'USA';

-- 2. Query a list of CITY names from STATION for cities that have an even ID number.
-- Print the results in any order, but exclude duplicates from the answer.
SELECT DISTINCT city
FROM station
WHERE MOD(ID, 2)=0;

-- 3. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. 
-- Your result cannot contain duplicates.
SELECT DISTINCT city 
FROM station 
WHERE LOWER(SUBSTR(city,1,1)) IN ('a','e','i','o','u');

-- DAY 15 SQL Practice with DataLemur

-- 1. Page With No Likes [Facebook SQL Interview Question]
-- Assume you're given two tables containing data about Facebook Pages 
-- -- and their respective likes (as in "Like a Facebook Page").
-- -- Write a query to return the IDs of the Facebook pages that have zero likes. 
-- -- The output should be sorted in ascending order based on the page IDs.
SELECT p.page_id
FROM pages p
 LEFT JOIN page_likes pl
	ON p.page_id = pl.page_id
	WHERE pl.page_id IS NULL
  ORDER BY p.page_id ASC;
  
-- 2. Histogram of Tweets [Twitter SQL Interview Question]
-- Assume you're given a table Twitter tweet data, 
-- write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.
-- In other words, 
-- group the users by the number of tweets they posted in 2022 and count the number of users in each group.
SELECT tweet_bucket,
COUNT(user_id) AS user_num
FROM 
  (SELECT user_id, 
    COUNT(tweet_id) AS tweet_bucket
    FROM tweets
    WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
    GROUP BY user_id) AS total_tweets
GROUP BY tweet_bucket
ORDER BY tweet_bucket;
 
-- 3.  Laptop vs. Mobile Viewership [New York Times SQL Interview Question]
-- Assume you're given the table on user viewership
-- categorised by device type where the three types are laptop, tablet, and phone.
-- Write a query that calculates the total viewership for laptops and mobile devices 
-- where mobile is defined as the sum of tablet and phone viewership. 
-- Output the total viewership for laptops as laptop_reviews 
-- and the total viewership for mobile devices as mobile_views.
SELECT 
  SUM(CASE WHEN device_type = 'laptop'THEN 1 ELSE 0 END) AS laptop_views,
  SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;

-- DAY 16 SQL Practice with stratascratch.com

-- 1. Salaries Differences
-- Write a query that calculates the difference between the highest salaries 
-- found in the marketing and engineering departments. 
-- Output just the absolute difference in salaries.
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
) AS salary_diff;

-- 2. Finding Updated Records
-- We have a table with employees and their salaries, however, some of the records are old and contain outdated salary information. 
-- Find the current salary of each employee assuming that salaries increase each year. 
-- Output their id, first name, last name, department ID, and current salary. 
-- Order your list by employee ID in ascending order.
SELECT id, first_name, last_name, department_id, MAX(salary)
FROM ms_employee_salary
GROUP BY id, first_name, last_name, department_id
ORDER BY id ASC;

-- 3. Reviews of Hotel Arena
-- Find the number of rows for each review score earned by 'Hotel Arena'. 
-- Output the hotel name (which should be 'Hotel Arena'), 
-- review score along with the corresponding number of rows with that score for the specified hotel.
SELECT hotel_name, reviewer_score, COUNT(*) AS corresponding_rows
FROM  hotel_reviews
WHERE hotel_name LIKE 'Hotel Arena'
GROUP BY hotel_name, reviewer_score;

-- 4. Find all posts which were reacted to with a heart
-- Find all posts which were reacted to with a heart. For such posts output all columns from facebook_posts table.
SELECT DISTINCT fp. *
FROM facebook_reactions AS fr
JOIN facebook_posts fp
	ON fr.post_id = fp.post_id
WHERE fr.reaction LIKE 'heart';

-- DAY 17 SQL Practice with stratascratch.com

-- 1. Find libraries who haven't provided the email address
SELECT DISTINCT home_library_code 
FROM library_usage
WHERE notice_preference_definition = 'email' AND  
    provided_email_address = FALSE AND 
    circulation_active_year = 2016;
    
-- 2. Average Salaries
-- Compare each employee's salary with the average salary of the corresponding department.
-- Output the department, first name, and salary of employees along with the average salary of that department.
SELECT department, first_name, salary,
    AVG(salary) OVER(PARTITION BY department) AS dept_avg
FROM employee;


-- 3. Order Details
-- Find order details made by Jill and Eva.
-- Consider the Jill and Eva as first names of customers.
-- Output the order date, details and cost along with the first name.
-- Order records based on the customer id in ascending order.
SELECT c.first_name, o.order_date, o.order_details, o.total_order_cost
FROM customers c
JOIN orders o
ON c.id = o.cust_id
WHERE c.first_name IN ('Jill', 'Eva')
ORDER BY o.cust_id ASC;

-- 4. Customer Details
-- Find the details of each customer regardless of whether the customer made an order. 
-- Output the customer's first name, last name, and the city along with the order details.
-- You may have duplicate rows in your results due to a customer ordering several of the same items. 
-- Sort records based on the customer's first name and the order details in ascending order.
SELECT c.first_name, c.last_name, c.city, o.order_details
FROM customers c
LEFT JOIN orders o
ON  o.cust_id = c.id
ORDER BY c.first_name, o.order_details ASC;


-- 5. Admin Department Employees Beginning in April or Later
-- Find the number of employees working in the Admin department that joined in April or later.
SELECT COUNT(worker_id) AS num_of_admin_employees
FROM worker
WHERE MONTH(joining_date) >=4 AND department = 'Admin';

-- DAY 18 SQL Practice with DataLemur

-- 1. DATA SCIENCE SKILLS [LINKEDIN SQL INTERVIEW QUESTION]
-- Given a table of candidates and their skills, 
-- you're tasked with finding the candidates best suited for an open Data Science job. 
-- You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.
-- Write a query to list the candidates who possess all of the required skills for the job. 
-- Sort the output by candidate ID in ascending order.
-- Assumption: There are no duplicates in the candidates table.
SELECT DISTINCT candidate_id
FROM candidates 
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id ASC;

-- 2. AVERAGE POST HIATUS (PART 1) [FACEBOOK SQL INTERVIEW QUESTION]
-- Given a table of Facebook posts, for each user who posted at least twice in 2021, 
-- write a query to find the number of days between each user’s first post of the year 
-- and last post of the year in the year 2021. 
-- Output the user and number of the days between each user's first and last post.
SELECT user_id, EXTRACT(DAY FROM(MAX(post_date) - MIN(post_date)))AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2021-12-31'
GROUP BY user_id
HAVING COUNT(post_id) > 1;

-- 3. TEAMS POWER USERS [MICROSOFT SQL INTERVIEW QUESTION]
-- Write a query to identify the top 2 Power Users 
-- who sent the highest number of messages on Microsoft Teams in August 2022. 
-- Display the IDs of these 2 users along with the total number of messages they sent. 
-- Output the results in descending order based on the count of the messages.
-- Assumption: No two users have sent the same number of messages in August 2022.
SELECT sender_id, COUNT(message_id) AS message_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = 8
  AND EXTRACT(YEAR FROM sent_date) = 2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

-- 4. DUPLICATE JOB LISTINGS [LINKEDIN SQL INTERVIEW QUESTION]
-- Assume you're given a table containing job postings from various companies on the LinkedIn platform. 
-- Write a query to retrieve the count of companies that have posted duplicate job listings.
-- Definition: Duplicate job listings are defined as two job listings 
-- within the same company that share identical titles and descriptions.
WITH CTE AS (
SELECT company_id, COUNT(title) AS duplicate_job, description
FROM job_listings
GROUP BY company_id, description
HAVING COUNT(title) > 1
)
SELECT COUNT(company_id) AS duplicate_companies
FROM CTE;

-- DAY 19 (SQL Practice with Datalemur)

-- 1.AVERAGE REVIEW RATINGS [AMAZON SQL INTERVIEW QUESTION]
-- Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month.
-- The output should display the month as a numerical value, product ID, 
-- and average star rating rounded to two decimal places. 
-- Sort the output first by month and then by product ID.
SELECT EXTRACT(MONTH FROM submit_date) AS month, product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(MONTH FROM submit_date), product_id
ORDER BY month, product_id;

-- 2. APP CLICK-THROUGH RATE (CTR) [FACEBOOK SQL INTERVIEW QUESTION]
-- Assume you have an events table on Facebook app analytics. 
-- Write a query to calculate the click-through rate (CTR) for the app in 2022 
-- and round the results to 2 decimal places.
-- Definition and note: Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
-- To avoid integer division, multiply the CTR by 100.0, not 100.
SELECT app_id, 
 ROUND(100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END)
  / SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 2) AS ct_rate
FROM events
WHERE EXTRACT(YEAR FROM timestamp) = 2022
GROUP BY app_id;

-- 3. SECOND DAY CONFIRMATION [TIKTOK SQL INTERVIEW QUESTION]
-- Assume you're given tables with information about TikTok user sign-ups and confirmations through email and text. 
-- New users on TikTok sign up using their email addresses, and upon sign-up, 
-- each user receives a text message confirmation to activate their account.
-- Write a query to display the user IDs of those who did not confirm their sign-up on the first day, 
-- but confirmed on the second day.
-- Definition: action_date refers to the date when users activated their accounts 
-- and confirmed their sign-up through text messages.
SELECT DISTINCT e.user_id
FROM emails e
JOIN texts t
  ON e.email_id = t.email_id
WHERE t.signup_action = 'Confirmed'
AND DATE(e.signup_date) + 1  = t.action_date;

-- DAY 20 (Practice with DataLemur)

-- 1. CARDS ISSUED DIFFERENCE [JPMorgan CHASE SQL INTERVIEW QUESTION]
-- Your team at JPMorgan Chase is preparing to launch a new credit card, 
-- and to gain some insights, you're analyzing how many credit cards were issued each month.
-- Write a query that outputs the name of each credit card and the difference in the number of issued cards
-- between the month with the highest issuance cards and the lowest issuance. 
-- Arrange the results based on the largest disparity.
SELECT card_name, (MAX(issued_amount) - MIN(issued_amount)) AS difference 
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

-- 2. COMPRESSED MEAN [ALIBABA SQL INTERVIEW QUESTION]
-- You're trying to find the mean number of items per order on Alibaba, 
-- rounded to 1 decimal place using tables which includes information
-- on the count of items in each order (item_count table) 
-- and the corresponding number of orders for each item count (order_occurrences table).
SELECT 
ROUND(1.0 * SUM(item_count*order_occurrences) / SUM(order_occurrences),1) AS mean
FROM items_per_order;

-- 3. PHARMACY ANALYTICS (PART 2) [CVS HEALTH SQL INTERVIEW QUESTION]
-- CVS Health is analyzing its pharmacy sales data, and how well different products are selling in the market. 
-- Each drug is exclusively manufactured by a single manufacturer.
-- Write a query to identify the manufacturers associated with the drugs that resulted in losses for CVS Health 
-- and calculate the total amount of losses incurred.
-- Output the manufacturer's name,the number of drugs associated with losses,and the total losses in absolute value. 
-- Display the results sorted in descending order with the highest losses displayed at the top
SELECT manufacturer, 
  COUNT(drug) AS drug_count, 
  SUM(cogs - total_sales) AS total_loss
FROM pharmacy_sales
WHERE cogs > total_sales
GROUP BY manufacturer
ORDER BY total_loss DESC;