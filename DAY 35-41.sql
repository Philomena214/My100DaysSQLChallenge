-- DAY 36 (ROW NUMBERING)
/* CASE STUDY: The HR department of a company needs to simplify access to their staffs record. 
They need you as a data analyst to help extract the following information*/

/* ROW NUMBER()
Extract the full name of the staffs, their department with their salary then attach a number based on salary 
and full name incase of their similar salaries.*/
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
		job_id, salary,
		ROW_NUMBER() OVER(ORDER BY salary DESC,
		CONCAT(first_name, ' ', last_name) ASC) AS salary_rank
FROM employees;

/* RANK()
Rank the employees based on their salary and calculate their ranks. 
Incase of ties, assign the same rank to employees with the same salary and the next rank should be skipped.*/
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
		job_id, salary,
		RANK() OVER(ORDER BY salary DESC,
		CONCAT(first_name, ' ', last_name) ASC) AS salary_rank
FROM employees;

/* DENSE RANK()
Rank the employees based on their salary and calculate their ranks. 
Incase of ties, assign the same rank to employees with the same salary and the next rank not be should be skipped.*/
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
		job_id, salary,
		DENSE_RANK() OVER(ORDER BY salary DESC,
		CONCAT(first_name, ' ', last_name) ASC) AS salary_rank
FROM employees;

/* N-TILE(n)
Group the employees into 4 based on their earnings and assign their group number*/
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
		job_id, salary,
		NTILE(4) OVER(ORDER BY salary DESC,
		CONCAT(first_name, ' ', last_name) ASC) AS salary_rank
FROM employees;

-- DAY 37 (PARTITION BY)
/* A supermarket needs your service as a data analyst to help make sense of their advertisement 
and sales logistics data*/ 
USE SQ1OOChallenge;
SELECT * FROM adverts;

/* Rank the performance of adverts by each advert agency. 
Attach the advert conversion and the amount spent on them*/
SELECT ad_id,
		agency,
		ROUND(100.00 *(clicks/impressions),2) AS ad_conversion, spend,
		DENSE_RANK() OVER(PARTITION BY agency ORDER BY spend DESC) AS advert_spend_rank
FROM adverts
WHERE spend > 0;

/* Create a basket of 4 groups of amount spent on the cost of shipping orders by order quantities to customers*/
SELECT order_id,
		order_quantity,
		shipping_price,
		NTILE(4) OVER(PARTITION BY order_quantity ORDER BY shipping_price DESC) AS logistics_basket
FROM sales;

-- DAY 38 (LEAD AND LAG FUNCTIONS)
/* CASE STUDY: The Marketing team of a business seeks to understand 
the performance of the adverts they have funded in the calender year. 
After contracting the analysis project to you. Find the solution to the following insights*/

/* LAG FUNCTION
Calculate the month on month change (in percentage) of total spent on adverts.*/
SELECT MONTH(ad_date) AS ad_month, SUM(spend) AS total_ad_spend,
		LAG(SUM(spend)) OVER(ORDER BY MONTH(ad_date) ASC) AS prev_mnth_ad_spend,
		ROUND(100.00 *((SUM(spend)/LAG(SUM(spend)) OVER(ORDER BY MONTH(ad_date) ASC))=1),2) AS 
        ad_budget_performance
FROM adverts
GROUP BY ad_month;

/* LEAD FUNCTION
Understanding that different agencies were contracted to handle each marketing campaign over the years.
Calculate the number of paid adverts per month each agency delivered for the business.
Use the LEAD function to return the next month advert counts.*/
SELECT agency, MONTH(ad_date) AS ad_month, COUNT(agency) AS total_adverts,
LEAD(COUNT(agency), 1, 0) OVER(PARTITION BY (MONTH(ad_date))ORDER BY COUNT(agency)) AS nxt_mnth_total_ad
FROM adverts
WHERE spend > 0
GROUP BY agency, ad_month
ORDER BY agency, ad_month;