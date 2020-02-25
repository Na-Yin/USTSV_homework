
-- https://www.richardtwatson.com/dm6e/Reader/ClassicModels.html

 -- Single entity
 -- 1. prepare  a list of offices sorted by country, state, city.
SELECT * FROM Offices
ORDER BY country, state, city;

-- 2. How many employees are there in the company?
SELECT count(employeenumber) AS num FROM employees;

-- 3. What is the total of payments received?
SELECT SUM(amount) AS toal_amount FROM payments; 
 
 -- 4. List the product lines that contain 'Cars'.
SELECT productline FROM productlines
WHERE LOCATE('Cars', productline) > 0;
-- alternate solution
 SELECT productline FROM productlines
 WHERE productline LIKE '%Cars%';

-- 5. Report total payments for October 28, 2004.
SELECT SUM(amount) AS total_payments FROM payments
WHERE paymentdate BETWEEN CAST('2004-10-28' AS DATE) AND CAST('2004-10-28' AS DATE);

-- 6. Report those payments greater than $100,000.
SELECT * FROM payments
WHERE amount > 100000;

-- 7. List the products in each product line.
SELECT productline, GROUP_CONCAT(productname) FROM products
GROUP BY productLine;

-- 8. How many products in each product line?
SELECT productline, COUNT(DISTINCT productcode) AS No_of_product FROM products
GROUP BY productline;

-- 9. What is the minimum payment received?
SELECT MIN(amount) AS min_payment FROM payments;

-- 10. List all payments greater than twice the average payment.
SELECT * FROM payments
WHERE amount > 2*(SELECT AVG(amount) FROM payments);

-- 11. What is the average percentage markup of the MSRP on buyPrice?
SELECT AVG((msrp - buyprice)/buyprice) AS avg_percentage_markup FROM products;

-- 12. How many distinct products does ClassicModels sell?
SELECT COUNT(DISTINCT productcode) AS num_of_product FROM products;

-- 13. Report the name and city of customers who don't have sales representatives?
SELECT customername, city FROM customers
WHERE salesRepEmployeeNumber IS NULL;

-- 14. What are the names of executives with VP or Manager in their title? Use the CONCAT function to combine the 
--     employee's first name and last name into a single field for reporting.
SELECT CONCAT(firstname, ' ', lastname) AS executive_name FROM employees
WHERE jobtitle LIKE 'VP%' OR jobtitle LIKE '%Manager%';

-- 15. Which orders have a value greater than $5,000?
SELECT * FROM orderdetails
WHERE priceeach*quantityOrdered > 5000;

-- One to many relationship
-- 1. Report the account representative for each customer.
SELECT c.*, e.* FROM customers c
JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber;

-- 2. Report total payments for Atelier graphique.
SELECT SUM(p.amount) AS total_payment FROM payments p
JOIN customers c
ON p.customernumber = c.customernumber
WHERE c.customername = 'Atelier graphique';

-- 3. Report the total payments by date.
SELECT paymentdate, SUM(amount) AS total_payment FROM payments
GROUP BY paymentdate;

-- 4. Report the products that have not been sold.
SELECT * FROM products
WHERE productcode NOT IN (SELECT productcode FROM orderdetails);

-- 5. List the amount paid by each customer.
SELECT c.customernumber, GROUP_CONCAT(p.amount) FROM customers c
JOIN payments p
ON c.customernumber = p.customernumber
GROUP BY c.customernumber;

-- 6. How many orders have been placed by Herkku Gifts?
SELECT COUNT(o.ordernumber) AS num_order FROM orders o
JOIN customers c
ON o.customernumber = c.customernumber
WHERE c.customername = 'Herkku Gifts';

-- 7. Who are the employees in Boston?
SELECT e.* FROM employees e
JOIN offices o
ON e.officecode = o.officecode
WHERE o.city = 'Boston';

-- 8. Report those payments greater than $100,000. Sort the report so the customer who made the highest payment appears first.
SELECT p.*, c.* FROM payments p
JOIN customers c
ON p.customernumber = c.customernumber
WHERE p.amount > 100000
ORDER BY p.amount DESC;
-- How to exclude duplicate column (customernumber)??

-- 9. List the value of 'On Hold' orders.
SELECT o.ordernumber, GROUP_CONCAT(od.quantityOrdered*od.priceeach) AS order_value FROM orders o
JOIN orderdetails od
ON o.ordernumber = od.ordernumber
WHERE o.status = 'On Hold'
GROUP BY o.ordernumber;

-- 10. Report the number of orders 'On Hold' for each customer.
SELECT c.customernumber, COUNT(o.ordernumber) AS num_of_order FROM customers c
JOIN orders o
ON c.customernumber = o.customernumber
WHERE o.status = 'On Hold'
GROUP BY c.customernumber;

-- Many to many relationship
-- 1. List products sold by order date.
SELECT p.*, o.orderdate FROM products p
JOIN orderdetails od
ON p.productcode = od.productcode
JOIN orders o
ON od.ordernumber = o.ordernumber;

-- 2. List the order dates in descending order for orders for the 1940 Ford Pickup Truck.
SELECT p.*, o.orderdate FROM products p
JOIN orderdetails od
ON p.productcode = od.productcode
JOIN orders o
ON od.ordernumber = o.ordernumber
WHERE p.productname = '1940 Ford Pickup Truck'
ORDER BY o.orderdate DESC;

-- 3. List the names of customers and their corresponding order number where a particular order from that customer has 
--    a value greater than $25,000?
SELECT c.customername, a.ordernumber FROM customers c
JOIN 
(SELECT o.ordernumber, o.customernumber, SUM(od.quantityordered * od.priceeach) AS total_value FROM orders o
JOIN orderdetails od
ON o.ordernumber = od.ordernumber
GROUP BY o.ordernumber) A
ON c.customernumber = a.customernumber
WHERE a.total_value > 25000;

-- 4. Are there any products that appear on all orders?
SELECT COUNT(DISTINCT ordernumber) FROM orderdetails;
SELECT p.productcode, COUNT(DISTINCT od.ordernumber) AS num_of_order FROM products p
JOIN orderdetails od
ON p.productcode = od.productcode
GROUP BY p.productcode
HAVING num_of_order = (SELECT COUNT(DISTINCT ordernumber) FROM orderdetails);

-- 5. List the names of products sold at less than 80% of the MSRP.
SELECT p.productname FROM products p
JOIN orderdetails od
ON p.productcode = od.productcode
WHERE od.priceeach < p.msrp * 0.8;

-- 6. Reports those products that have been sold with a markup of 100% or more (i.e.,  the priceEach is at least twice the buyPrice)
SELECT p.productname FROM products p
JOIN orderdetails od
ON p.productcode = od.productcode
WHERE od.priceeach > p.buyprice * 2;

-- 7. List the products ordered on a Monday.
SELECT p.productname FROM products p
JOIN orderdetails od
ON p.productcode = od.productcode
JOIN orders o
ON od.ordernumber = o.ordernumber
WHERE WEEKDAY(o.orderdate) = 0;

-- 8. What is the quantity on hand for products listed on 'On Hold' orders?
SELECT COUNT(p.productname) AS num_of_product FROM products p
JOIN orderdetails od
ON p.productcode = od.productcode
JOIN orders o
ON od.ordernumber = o.ordernumber
WHERE o.status = 'On Hold';

-- Regular expressions
-- 1. Find products containing the name 'Ford'.
SELECT * FROM products
WHERE productname LIKE '%Ford%';

-- 2. List products ending in 'ship'.
SELECT * FROM products
WHERE productname LIKE '%ship';

-- 3. Report the number of customers in Denmark, Norway, and Sweden.
SELECT country, COUNT(customernumber) AS num FROM customers
WHERE country in ('Denmark', 'Norway', 'Sweden')
GROUP BY country;

-- 4. What are the products with a product code in the range S700_1000 to S700_1499?
SELECT * FROM products
WHERE productcode >= 'S700_1000' AND productcode <= 'S700_1499';

-- 5. Which customers have a digit in their name?
SELECT * FROM customers
WHERE customername REGEXP '[0-9]';

-- 6. List the names of employees called Dianne or Diane.
SELECT CONCAT(firstname, ' ', lastname) FROM employees
WHERE CONCAT(firstname, ' ', lastname) LIKE '%Dianne%' OR CONCAT(firstname, ' ', lastname) LIKE '%Diane%';

-- 7. List the products containing ship or boat in their product name.
SELECT * FROM products
WHERE productname LIKE '%ship%' OR productname LIKE '%boat%';

-- 8. List the products with a product code beginning with S700.
SELECT * FROM products
WHERE productcode LIKE 'S700%';

-- 9. List the names of employees called Larry or Barry.
SELECT CONCAT(firstname, ' ', lastname) FROM employees
WHERE CONCAT(firstname, ' ', lastname) LIKE '%Larry%' OR CONCAT(firstname, ' ', lastname) LIKE '%Barry%';

-- 10. List the names of employees with non-alphabetic characters in their names.
SELECT CONCAT(firstname, ' ', lastname) FROM employees
WHERE firstname REGEXP '[^a-z]+' OR lastname REGEXP '[^a-z]+';

-- 11. List the vendors whose name ends in Diecast
SELECT productvendor FROM products
WHERE productvendor LIKE '%Diecast';

-- General queries
-- 1. Who is at the top of the organization (i.e.,  reports to no one).
SELECT * FROM employees
WHERE reportsto IS NULL;

-- 2. Who reports to William Patterson?
SELECT * FROM employees
WHERE reportsto = (SELECT employeenumber FROM employees
									WHERE CONCAT(firstname, ' ', lastname) = 'William Patterson');

-- 3. List all the products purchased by Herkku Gifts.
SELECT p.productname FROM products p
JOIN orderdetails od
ON p.productcode = od.productcode
JOIN orders o
ON od.ordernumber = o.ordernumber
JOIN customers c
ON o.customernumber = c.customernumber
WHERE c.customername = 'Herkku Gifts';

-- 4. Compute the commission for each sales representative, assuming the commission is 5% of the value of an order. 
--    Sort by employee last name and first name.
SELECT e.lastname, e.firstname, SUM(od.quantityordered * od.priceeach) * 0.05 AS commission FROM employees e
JOIN customers c
ON e.employeenumber = c.salesrepemployeenumber
JOIN orders o
ON c.customernumber = o.customernumber
JOIN orderdetails od
ON o.ordernumber = od.ordernumber
GROUP BY e.lastname, e.firstname
ORDER BY e.lastname, e.firstname;

-- 5. What is the difference in days between the most recent and oldest order date in the Orders file?
SELECT timestampdiff(DAY, MIN(orderdate), MAX(orderdate)) FROM orders;

-- 6. Compute the average time between order date and ship date for each customer ordered by the largest difference.
SELECT c.customernumber, AVG(TIMESTAMPDIFF(DAY, o.orderdate, o.shippeddate)) AS AVG_day_diff FROM customers c
JOIN orders o
ON c.customernumber = o.customernumber
GROUP BY c.customernumber
ORDER BY avg_day_diff DESC;

-- 7. What is the value of orders shipped in August 2004? (Hint).
SELECT SUM(od.quantityordered * od.priceeach) AS total_value FROM orderdetails od
JOIN orders o
ON od.ordernumber = o.ordernumber
WHERE o.shippeddate BETWEEN CAST('2004-08-01' AS DATETIME) AND CAST('2004-08-31' AS DATETIME);

-- 8. Compute the total value ordered, total amount paid, and their difference for each customer for orders placed in 2004 
--    and payments received in 2004 (Hint; Create views for the total paid and total ordered).
SELECT c.customernumber, SUM(od.quantityordered * od.priceeach) AS total_value_ordered, SUM(p.amount) AS total_value_paid, SUM(od.quantityordered * od.priceeach - p.amount) AS diff FROM customers c
JOIN payments p
ON c.customernumber = p.customernumber
JOIN orders o
ON c.customernumber = o.customernumber
JOIN orderdetails od
ON o.ordernumber = od.ordernumber
WHERE o.orderdate BETWEEN CAST('2004-01-01' AS DATETIME) AND CAST('2004-12-31' AS DATETIME)
AND p.paymentdate BETWEEN CAST('2004-01-01' AS DATETIME) AND CAST('2004-12-31' AS DATETIME)
GROUP BY c.customernumber;

-- 9. List the employees who report to those employees who report to Diane Murphy. Use the CONCAT function to 
--    combine the employee's first name and last name into a single field for reporting.
SELECT CONCAT(firstname, ' ', lastname) AS employee_name FROM employees
WHERE reportsto IN (SELECT employeenumber FROM employees
									WHERE reportsto = (SELECT employeenumber FROM employees
																		WHERE CONCAT(firstname, ' ', lastname) = 'Diane Murphy'));

-- 10. What is the percentage value of each product in inventory sorted by the highest percentage first (Hint: Create a view first).
SELECT productcode, (buyprice / msrp * 100) AS percentage_value FROM products
ORDER BY percentage_value DESC;

-- 11. Write a function to convert miles per gallon to liters per 100 kilometers.
DROP FUNCTION IF EXISTS mpg_to_lpkm;
DELIMITER $$
CREATE FUNCTION mpg_to_lpkm (mpg DECIMAL(10, 2))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
	DECLARE lpkm DECIMAL(10,2);
    SET lpkm = 3.79 * 100.0 / (mpg * 1.61);
    RETURN lpkm;
END$$
DELIMITER ;

SELECT mpg_to_lpkm (2.5);

-- 12. Write a procedure to increase the price of a specified product category by a given percentage. You will need to create 
--     a product table with appropriate data to test your procedure. Alternatively, load the ClassicModels database on your 
--     personal machine so you have complete access. You have to change the DELIMITER prior to creating the procedure.



-- 13. What is the value of orders shipped in August 2004? (Hint).
SELECT SUM(od.quantityordered * od.priceeach) AS total_value FROM orderdetails od
JOIN orders o
ON od.ordernumber = o.ordernumber
WHERE o.shippeddate BETWEEN CAST('2004-08-01' AS DATETIME) AND CAST('2004-08-31' AS DATETIME);

-- 14. What is the ratio the value of payments made to orders received for each month of 2004. (i.e., divide the value of 
--     payments made by the orders received)?
SELECT MONTH(o.orderdate), AVG(od.quantityordered * od.priceeach / p.amount) AS ratio FROM orders o
JOIN payments p
ON o.customernumber = p.customernumber
JOIN orderdetails od
ON o.ordernumber = od.ordernumber
WHERE YEAR(o.orderdate) = 2004
GROUP BY MONTH(o.orderdate)
ORDER BY MONTH(o.orderdate);

-- 15. What is the difference in the amount received for each month of 2004 compared to 2003?
SELECT a.month_2004, (a.amount_2004 - b.amount_2003) AS diff FROM
(SELECT MONTH(p1.paymentdate) AS month_2004, SUM(p1.amount) AS amount_2004 FROM payments p1
			WHERE YEAR(p1.paymentdate) = 2004
            GROUP BY month_2004) A
JOIN (SELECT MONTH(p2.paymentdate) AS month_2003, SUM(p2.amount) AS amount_2003 FROM payments p2
			WHERE YEAR(p2.paymentdate) = 2003
            GROUP BY month_2003) B
ON a.month_2004 = b.month_2003
ORDER BY a.month_2004;

-- 16. Write a procedure to report the amount ordered in a specific month and year for customers containing a specified 
--     character string in their name.


-- 17. Write a procedure to change the credit limit of all customers in a specified country by a specified percentage.


-- 18. Basket of goods analysis: A common retail analytics task is to analyze each basket or order to learn what products 
--     are often purchased together. Report the names of products that appear in the same order ten or more times.


-- 19. ABC reporting: Compute the revenue generated by each customer based on their orders. Also, show each 
--     customer's revenue as a percentage of total revenue. Sort by customer name.
SELECT o.customerNumber, SUM(od.quantityordered*p.msrp) AS revenue, SUM(od.quantityordered*p.msrp)*100/
(SELECT SUM(od.quantityordered*p.msrp) FROM orders o
LEFT JOIN orderdetails od
ON o.ordernumber = od.ordernumber
LEFT JOIN products p
ON od.productcode = p.productcode) AS percentage_revenue FROM orders o
LEFT JOIN orderdetails od
ON o.ordernumber = od.ordernumber
LEFT JOIN products p
ON od.productcode = p.productcode
GROUP BY o.customernumber;

-- 20. Compute the profit generated by each customer based on their orders. Also, show each customer's profit as a 
--     percentage of total profit. Sort by profit descending.
SELECT o.customerNumber, SUM(od.quantityordered*(p.msrp-p.buyprice)) AS profit, SUM(od.quantityordered*(p.msrp-p.buyprice))*100/
(SELECT SUM(od.quantityordered*(p.msrp-p.buyprice)) FROM orders o
LEFT JOIN orderdetails od
ON o.ordernumber = od.ordernumber
LEFT JOIN products p
ON od.productcode = p.productcode) AS percentage_profit FROM orders o
LEFT JOIN orderdetails od
ON o.ordernumber = od.ordernumber
LEFT JOIN products p
ON od.productcode = p.productcode
GROUP BY o.customernumber
ORDER BY profit DESC;

-- 21. Compute the revenue generated by each sales representative based on the orders from the customers they serve.
SELECT c.salesrepemployeenumber, SUM(od.quantityordered*p.msrp) AS revenue, SUM(od.quantityordered*p.msrp)*100/
(SELECT SUM(od.quantityordered*p.msrp) FROM customers c
LEFT JOIN orders o
ON c.customernumber = o.customernumber
LEFT JOIN orderdetails od
ON o.ordernumber = od.ordernumber
LEFT JOIN products p
ON od.productcode = p.productcode) AS percentage_revenue FROM customers c
LEFT JOIN orders o
ON c.customernumber = o.customernumber
LEFT JOIN orderdetails od
ON o.ordernumber = od.ordernumber
LEFT JOIN products p
ON od.productcode = p.productcode
GROUP BY c.salesrepemployeenumber;

-- 22. Compute the profit generated by each sales representative based on the orders from the customers they serve. 
--     Sort by profit generated descending.
SELECT c.salesrepemployeenumber, SUM(od.quantityordered*(p.msrp-p.buyprice)) AS profit, SUM(od.quantityordered*(p.msrp-p.buyprice))*100/
(SELECT SUM(od.quantityordered*(p.msrp-p.buyprice)) FROM customers c
LEFT JOIN orders o
ON c.customernumber = o.customernumber
LEFT JOIN orderdetails od
ON o.ordernumber = od.ordernumber
LEFT JOIN products p
ON od.productcode = p.productcode) AS percentage_profit FROM customers c
LEFT JOIN orders o
ON c.customernumber = o.customernumber
LEFT JOIN orderdetails od
ON o.ordernumber = od.ordernumber
LEFT JOIN products p
ON od.productcode = p.productcode
GROUP BY c.salesrepemployeenumber
ORDER BY profit DESC;

-- 23. Compute the revenue generated by each product, sorted by product name.
SELECT p.productname, SUM(od.quantityordered*p.msrp) AS revenue FROM orders o
LEFT JOIN orderdetails od
ON o.ordernumber = od.ordernumber
LEFT JOIN products p
ON od.productcode = p.productcode
GROUP BY p.productname;

-- 24. Compute the profit generated by each product line, sorted by profit descending.
SELECT productline, AVG((msrp - buyprice)/buyprice) AS profit FROM products
GROUP BY productline
ORDER BY profit DESC;

-- 25. Same as Last Year (SALY) analysis: Compute the ratio for each product of sales for 2003 versus 2004.
SELECT A.productcode, (B.amount_2003 / A.amount_2004) AS ratio FROM
	(SELECT p.productcode, SUM(od.quantityordered) AS amount_2004 FROM products p
	JOIN orderdetails od
	ON p.productcode = od.productcode
    JOIN orders o
    ON od.ordernumber = o.ordernumber
	WHERE YEAR(o.orderdate) = 2004
	GROUP BY p.productcode) A
JOIN (SELECT p.productcode, SUM(od.quantityordered) AS amount_2003 FROM products p
	JOIN orderdetails od
	ON p.productcode = od.productcode
    JOIN orders o
    ON od.ordernumber = o.ordernumber
	WHERE YEAR(o.orderdate) = 2003
	GROUP BY p.productcode) B
ON A.productcode = B.productcode;

-- 26. Compute the ratio of payments for each customer for 2003 versus 2004.
SELECT A.customernumber, (B.amount_2003 / A.amount_2004) AS ratio FROM
	(SELECT c1.customernumber, SUM(p1.amount) AS amount_2004 FROM customers c1
	JOIN payments p1
	ON c1.customernumber = p1.customernumber
	WHERE YEAR(p1.paymentdate) = 2004
	GROUP BY c1.customernumber) A
JOIN (SELECT c2.customernumber, SUM(p2.amount) AS amount_2003 FROM customers c2
	JOIN payments p2
	ON c2.customernumber = p2.customernumber
	WHERE YEAR(p2.paymentdate) = 2003
	GROUP BY c2.customernumber) B
ON A.customernumber = B.customernumber
ORDER BY A.customernumber;

-- 27. Find the products sold in 2003 but not 2004.
SELECT DISTINCT od.productcode FROM orderdetails od
JOIN orders o
ON od.ordernumber = o.ordernumber
WHERE YEAR(o.orderdate) = 2004 AND od.productcode NOT IN
(SELECT DISTINCT od.productcode FROM orderdetails od
JOIN orders o
ON od.ordernumber = o.ordernumber
WHERE YEAR(o.orderdate) = 2004);


-- 28. Find the customers without payments in 2003.
SELECT customernumber FROM customers
WHERE customernumber NOT IN
(SELECT customernumber FROM payments
WHERE YEAR(paymentdate) = 2003);

-- Correlated subqueries
-- 1. Who reports to Mary Patterson?
SELECT CONCAT(firstname, ' ', lastname) FROM employees
WHERE reportsto = (SELECT employeenumber FROM employees
									WHERE CONCAT(firstname, ' ', lastname) = 'Mary Patterson');

-- 2. Which payments in any month and year are more than twice the average for that month and year (i.e. compare all 
--    payments in Oct 2004 with the average payment for Oct 2004)? Order the results by the date of the payment. You will 
--    need to use the date functions.
SELECT p.paymentdate, p.amount FROM payments p
JOIN (SELECT YEAR(paymentdate) AS payment_year, MONTH(paymentdate) AS payment_month, AVG(amount) AS amount_avg FROM payments
			GROUP BY YEAR(paymentdate), MONTH(paymentdate)) A
ON YEAR(p.paymentdate) = a.payment_year AND MONTH(p.paymentdate) = a.payment_month
WHERE p.amount > a.amount_avg * 2
ORDER BY p.paymentdate;

-- 3. Report for each product, the percentage value of its stock on hand as a percentage of the stock on hand for product 
--    line to which it belongs. Order the report by product line and percentage value within product line descending. Show 
--    percentages with two decimal places.


-- 4. For orders containing more than two products, report those products that constitute more than 50% of the value of the order.
SELECT od.productcode FROM orderdetails od
JOIN (SELECT ordernumber, COUNT(DISTINCT productcode) AS product_num, SUM(quantityordered *priceeach) AS total_price FROM orderdetails
			GROUP BY ordernumber) A
ON od.ordernumber = a.ordernumber
WHERE a.product_num > 2 AND (quantityordered * priceeach) > (a.total_price /2);


-- Spatial data
-- The Offices and Customers tables contain the latitude and longitude of each office and customer in officeLocation and 
-- customerLocation, respectively, in POINT format. Conventionally, latitude and longitude and reported as a pair of points, 
-- with latitude first.

-- 1. Which customers are in the Southern Hemisphere?
SELECT customernumber, customername FROM customers
WHERE ST_X(customerlocation) < 0;

-- 2. Which US customers are south west of the New York office?
SELECT customernumber, customername FROM customers
WHERE country = 'USA' 
AND ST_X(customerlocation) < (SELECT ST_X(officelocation) FROM offices WHERE city = 'NYC') 
AND ST_Y(customerlocation) < (SELECT ST_Y(officelocation) FROM offices WHERE city = 'NYC');

-- 3. Which customers are closest to the Tokyo office (i.e., closer to Tokyo than any other office)?
SELECT customernumber, customername FROM customers
ORDER BY ST_DISTANCE_SPHERE(customerlocation, (SELECT officelocation FROM offices WHERE city = 'Tokyo'))
LIMIT 1;

-- 4. Which French customer is furthest from the Paris office?
SELECT customernumber, customername FROM customers
WHERE country = 'France'
ORDER BY ST_DISTANCE_SPHERE(customerlocation, (SELECT officelocation FROM offices WHERE city = 'Paris')) DESC
LIMIT 1;

-- 5. Who is the northernmost customer?
SELECT customernumber, customername FROM customers
ORDER BY  ST_X(customerlocation) DESC
LIMIT 1;

-- 6. What is the distance between the Paris and Boston offices?
--     To be precise for long distances, the distance in kilometers, as the crow flies, between two points when you have 
--     latitude and longitude, is (ACOS(SIN(lat1*PI()/180)*SIN(lat2*PI()/180)+COS(lat1*PI()/180)*COS(lat2*PI()/180)* COS((lon1-lon2)*PI()/180))*180/PI())*60*1.8532 
SELECT 
    ST_distance_sphere(
        (SELECT officelocation FROM offices WHERE city = 'Paris'), 
        (SELECT officelocation FROM offices WHERE city = 'Boston')
) as distance;
-- Alternative solution
SELECT (ACOS(
				SIN((SELECT ST_X(officelocation) FROM offices WHERE city = 'Paris')*PI()/180)*
                SIN((SELECT ST_X(officelocation) FROM offices WHERE city = 'Boston')*PI()/180)+
                COS((SELECT ST_X(officelocation) FROM offices WHERE city = 'Paris')*PI()/180)*
                COS((SELECT ST_X(officelocation) FROM offices WHERE city = 'Boston')*PI()/180)* 
                COS(
					((SELECT ST_Y(officelocation) FROM offices WHERE city = 'Paris')-
                     (SELECT ST_Y(officelocation) FROM offices WHERE city = 'Boston'))*PI()/180)
																								)*180/PI()
																										    )*60*1.8532 AS distance;

