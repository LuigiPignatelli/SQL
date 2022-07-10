SELECT *
FROM customers
ORDER BY customerNumber;

SELECT *
FROM orders
ORDER BY customerNumber;

-- NATURAL JOIN (misleading because we do not actually need to use a JOIN)
-- a natural join is the same as an INNER JOIN: they're completely equal
SELECT *
FROM customers, orders;
-- we know orders has 326 rows and customers only 123 and
-- when we do this query we expect to get all the 326 with the 123 orders, but we get more
-- each record of customers is merged with a each record of orders

-- NATURAL JOIN
-- what we can do to avoid this is a NATURAL JOIN: we wanto only those records that match
-- to narrow the result down we need to find what relates the two tables: customerNumber
-- we want all those records where the customerNumber of customers matches the customerNumber of orders

SELECT *
FROM customers, orders;
-- we get only the recorde where the customerNumber matches in both tables


-- we want to see the order number, customer name, the order date and the shipped date
-- BEST PRACTICE: always fully qualify the fields: we can have same fields in different tables
SELECT c.customerName AS 'customer name',
o.orderDate AS 'order date',
o.shippedDate AS 'shipped date',
o.orderNumber AS 'order number'
FROM customers c, orders o -- this would be --> orders AS o
WHERE c.customerNumber = o.customerNumber;


-- SELF JOIN
-- we use an ALISA to avoid confusion between the same tables
-- e.g. we use an alias with the self join (we ralate a table back to itself)
SELECT a.customerName, b.customerName
FROM customers a, customers b
WHERE a.customerName = b.customerName; -- we need the WHERE clause, otherwise each record of b is merged with each record of a
-- we want to see twice the field but without an alias we can't

-- to do the SELF JOIN we could actually use a JOIN
SELECT a.customerName, b.customerName
FROM customers a
JOIN customers b ON a.customerName = b.customerName;


-- JOINS
-- WE HAVE INNER, LEFT, RIGTH AND OUTER JOINS

-- we want to select all the customers and their orders, regardless if they made an order
-- customers on the left and orders on the right
SELECT c.customerName,
o.orderNumber,
o.orderDate
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
ORDER BY c.customerName;
-- we could have done the same thing with a rignt join by inverting the order of the tables "from orders o rigth join customers c" 

SELECT c.customerName,
COUNT(o.orderDate) num_orders
FROM customers c
LEFT JOIN orders o ON c.customerNumber = o.customerNumber
GROUP BY c.customerName
ORDER BY c.customerName;
-- we see some nulls or if we use GROUP BY along with COUNT, we can see some 0


-- AGGREGATE FUNCTIONS --> AVG(), COUNT(), SUM(), MAX(), MIN()
DESCRIBE orderdetails;
-- in here we have two PK: orderNumber and productCode
-- I want to see for each orderNumber how many items were ordered and the total price for all those orders

SELECT *
FROM orderdetails;

SELECT od.orderNumber,
COUNT(od.orderNumber) AS orders_placed,
SUM(od.quantityOrdered) AS total_quantity,
SUM(od.quantityOrdered * od.priceEach) AS total_price
FROM orderdetails od
GROUP BY od.orderNumber;
-- ORDER BY total_quantity DESC;


-- who has the most item on a single ticket
SELECT od.orderNumber,
MAX(od.quantityOrdered) AS max_quantity_ordered
FROM orderdetails od;


-- total price for each product
SELECT *,
od.quantityOrdered * od.priceEach AS totalPrice
FROM orderdetails od;


-- see how many of those particular product are ordered and what is the sum of the price for those orders
SELECT od.productCode,
COUNT(od.quantityOrdered) AS num_products,
SUM(od.priceEach) AS total_cost
FROM orderdetails od
GROUP BY od.productCode;


-- total number of items that were ordered on each ticket and the total price for each ticket
SELECT *
FROM orderdetails;

SELECT od.orderNumber,
SUM(od.quantityOrdered) AS total_items,
SUM(od.quantityOrdered * od.priceEach) AS total_price
FROM orderdetails od
GROUP BY od.orderNumber;
-- this is the same as the one I did above


-- SUB QUERY
-- get the average of the items that were ordered and see how many are above that
SELECT od.orderNumber,
od.quantityOrdered
FROM orderdetails od
WHERE quantityOrdered >= (SELECT AVG(quantityOrdered) FROM orderdetails);


-- get the payement table and see for each costumer how much they've payed
-- and we want to see only the customers that have made payments that are above the avg
SELECT *
FROM payments;

SELECT
AVG(amount) average
FROM payments;

SELECT sq.customerNumber,
sq.total_amount
FROM (
	SELECT p.customerNumber,
	SUM(p.amount) AS total_amount
	FROM payments p
	GROUP BY p.customerNumber
) AS sq
WHERE total_amount > (SELECT AVG(amount) FROM payments)
ORDER BY sq.total_amount ASC;
-- here we look at the total amount of payments

-- another way
SELECT p.customerNumber,
SUM(p.amount) AS total_amount
FROM payments p
WHERE amount > (SELECT AVG(amount) FROM payments)
GROUP BY p.customerNumber
ORDER BY total_amount
-- here we look at the individual payments of each customercars