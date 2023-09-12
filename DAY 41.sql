/* DAY 41 (HANDLING AGGREGATE FUNCTIONS WITHIN WINDOW FUNCTIONS)
Using the sales table generate the following insights. */
SELECT * FROM sales;

/* RUNNING TOTAL
Retrieve the running total of revenue earned daily for the whole year.*/
SELECT order_date,
SUM(revenue) AS total_revenue,
SUM(SUM(revenue)) OVER(ORDER BY order_date ASC) AS running_total_revenue
FROM sales
GROUP BY order_date
ORDER BY order_date;

/* PERCENTAGE OF MONTHLY TOTAL
Return the percentage each product contribute to the totral revenue earned every month.*/
SELECT product_id,
MONTH(order_date) AS month_date,
SUM(revenue) AS monthly_rev,
(SUM(SUM(revenue)) OVER(PARTITION BY MONTH(order_date), product_id) /
SUM(SUM(revenue)) OVER(PARTITION BY MONTH(order_date)) * 100)
												AS rev_percent_cntrbtn
FROM sales
GROUP BY product_id, month_date
ORDER BY month_date;