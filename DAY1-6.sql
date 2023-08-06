-- DAY 1

-- CREATE DATABASE 
-- The create database statement in SQL is used to create new SQL database

-- SYNTAX
CREATE DATABASE DatabaseName;

-- Example: Create a database for mysql100dayschallenge
CREATE DATABASE SQL100Challenge;

USE SQL1OOChallenge;

-- CREATE TABLE
-- This statement is used to create a new table in SQL

-- SYNTAX
CREATE TABLE TableName (
	column1 datatype,
    column2 datatype,
    column3 datatype,
    .....
    columnN datatype,
PRIMARY KEY (1 or more columns)
);

-- Example: Create customers, calender, products and adverts table
USE SQL1OOChallenge;
CREATE TABLE customers (
			customer_id		INT 	NOT NULL,
			customer_name	VARCHAR (32),
			region			VARCHAR (32),
			customer_segment VARCHAR (32),
PRIMARY KEY (customer_id)
);

CREATE TABLE calender (
			date_id 	DATE 	NOT NULL,
PRIMARY KEY (date_id)
);

CREATE TABLE products (
			product_id		VARCHAR(16)		NOT NULL,
			product_name	VARCHAR(60)		NOT NULL,
			product_category VARCHAR(32)	NOT NULL,
PRIMARY KEY (product_id)
);

CREATE TABLE adverts(
			ad_id			VARCHAR(16)		NOT NULL,
			ad_date			DATE			NOT NULL,
			day_of_the_week	VARCHAR(16)		NOT NULL,
			hour_of_day		TIME 			NOT NULL,
			agency			VARCHAR (16)	NOT NULL,
			ad_size			VARCHAR (16),
			platform		TEXT,
			device_type		TEXT,
			ad_format		TEXT,
			impressions		INTEGER,
			clicks			INTEGER,
			spend			DECIMAL (10,2),
PRIMARY KEY (ad_id)
);

-- METHODS OF INSERTING VALUES INTO TABLES
-- Inserting values into a table is used to add rows of data to a table in a database

-- METHOD 1: INSERT INTO METHOD
-- SYNTAX
INSERT INTO TableName VALUES(value1, value2, value3,....valueN);

-- Example: Insert values into the adverts table in SQL100challenge database
USE SQL1OOChallenge;
INSERT INTO adverts VALUES('ads10001', '2017-01-01', 'Sunday', '23:00', 'Ogly', '300x258', 'App', 'Mobile', 
							'Display', 265236, 580, 283);
                            
-- METHOD 2: LOAD INFILE METHOD
-- Using this, data from a text file is loaded into a table.

-- SYNTAX
LOAD DATA LOCAL INFILE 'file_name.txt' 
    INTO TABLE TableName
    FIELDS TERMINATED BY ','
	ENCLOSED BY ''
    LINES TERMINATED BY '\n'
    IGNORE number LINES;
    
   --  Before running this, ensure to follow this prompt:
--     Go to MySQL connection page, Right click on the connection and click 'Edit connection'
--     Select Advanced options and paste OPT_LOCAL_INFILE=1 below the current code in the "Others"
--     And click "Enter"

-- Example: Load data into adverts table
SET GLOBAL LOCAL_INFILE = TRUE;
LOAD DATA LOCAL INFILE 'C:/Users/phill/Desktop/DATA ANALYTICS/SQL/SQL CHALLENGE/adverts.csv'
INTO TABLE adverts
FIELDS TERMINATED BY ','
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET GLOBAL LOCAL_INFILE = TRUE;
LOAD DATA LOCAL INFILE 'C:/Users/phill/Desktop/DATA ANALYTICS/SQL/SQL CHALLENGE/calender.csv'
INTO TABLE adverts
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;

SET GLOBAL LOCAL_INFILE = TRUE;
LOAD DATA LOCAL INFILE 'C:/Users/phill/Desktop/DATA ANALYTICS/SQL/SQL CHALLENGE/customers.csv'
INTO TABLE adverts
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;

SET GLOBAL LOCAL_INFILE = TRUE;
LOAD DATA LOCAL INFILE 'C:/Users/phill/Desktop/DATA ANALYTICS/SQL/SQL CHALLENGE/products.csv'
INTO TABLE adverts
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;

-- BULK INSERT METHOD
-- Used to insert numerous rows of multiple data into a database table
-- Doesn't work with MySQL

SYNTAX
BULK INSERT TableName
FROM File_Path
WITH options;

-- Example: Insert muliple data into adverts table
BULK INSERT adverts
FROM 'C:/Users/phill/Desktop/DATA ANALYTICS/SQL/SQL CHALLENGE/adverts.csv'
WITH (FORMAT = 'CSV');

-- DAY 2 SELECT STATEMENT
-- This is a keyword used to call out a field in SQL

-- SYNTAX
SELECT Column_name1, Column_name2, Column_name3
FROM Table_name;

-- Example: Select all fields from adverts, calender, customers and products
SELECT * FROM adverts;
SELECT * FROM calender;
SELECT * FROM customers;
SELECT * FROM products;

-- Example: Select a desired number of column from a table
SELECT ad_id, ad_date, day_of_the_week, impressions,clicks
FROM Adverts;

SELECT customer_id, customer_name,region
FROM customers;

SELECT product_name, product_category
FROM products;

-- DAY 3
-- WHERE CLAUSE WITH BASIC OPERATORS

-- SYNTAX 
SELECT colunm_name1, colunm_name2, colunm_name3
FROM table_name
WHERE ('condition');

-- Example: Select ads that has over 12000 impressions
-- USE THE GREATER THAN OPERATOR (>)
SELECT *
FROM adverts
WHERE impressions > 12000;

-- Example: Select sales that generated loss in revenue
-- USE THE LESS THAN OPERATOR (<)
SELECT *
FROM sales
WHERE revenue < 0;

-- Example: Select sales with exactly 15 order quantities
-- USE THE EQUAL TO OPERATOR (=)
SELECT *
FROM sales
WHERE order_quantity = 15;

-- DAY 4 WHERE CLAUSE (WITH ADVANCED OPERATORS)

-- LIKE Operators
-- Select all customers whose name contains 'ah'
SELECT *
FROM customers
WHERE customer_name LIKE '%ah%';

-- IN Operator
-- Select all adverts handled by Ogly and Zion agencies
SELECT *
FROM adverts
WHERE agency IN ('Ógly' AND 'Zion');

-- BETWEEN Operator
-- Select sales between January and June 2017
SELECT *
FROM sales 
WHERE order_date BETWEEN '2017-01-01' AND '2017-06-30';

-- DAY 5 (AND-OR-NOT OPERATOR)

-- AND Operator
-- Return the best performing adverts (maximum of $110 ad_spend and a minimum of $14500 impressions)
SELECT *
FROM adverts
WHERE spend <=110 AND impressions >=14500;
-- OR Operator
-- Return sales with critical order prority or lower order quantity (maximum of 2)
SELECT *
FROM sales
WHERE order_priority LIKE '%critical%' OR order_quantity <= 2;
-- NOT Operator
-- Return customer's details whose name ends with E from all regions except Nunavut or West
SELECT *
FROM customers
WHERE customer_name LIKE '%E'AND region NOT IN ('Nunavut', 'West');

-- DAY 6 (STRING OPERATOR AND FUNCTIONS)
-- Return all customers whose name starts with or ends with vowels
SELECT *
FROM customers
WHERE  LEFT (customer_name, 1) IN ('A', 'E', 'I', 'O', 'U')
			OR RIGHT (customer_name, 1) IN ('A', 'E', 'I', 'O', 'U');
            
-- Create an extra column which return the initials of each customers
SELECT customer_id, customer_name,
	CONCAT(LEFT(customer_name, 1), '. ',
		MID(customer_name,
        (POSITION(' ' IN customer_name)), 2)) AS initials;