EXEC sp_help 'dbo.Categories'; -- this query is executed to help understand the the TABLE DEFINITION
USE NORTHWND;
GO

-- BEGINNER EXERCISES

-- 1. Which shippers do we have?
-- We have a table called Shippers. Return all the fields from all the shippers
SELECT *
FROM dbo.Shippers;


-- 2. Certain fields from Categories
-- We only want to see two columns, CategoryName and Description from the Categories table
SELECT c.CategoryName,
c.Description
FROM dbo.Categories AS c


-- 3. Sales Representatives
-- Get FirstName, LastName, and HireDate of all the employees with the Title of Sales Representative.
SELECT emp.FirstName,
emp.LastName,
emp.HireDate
FROM dbo.Employees AS emp
WHERE emp.Title = 'Sales Representative';


-- 4. Sales Representatives in the United States
-- Same query as above but only for those who live in the USE
SELECT emp.FirstName,
emp.LastName,
emp.HireDate
FROM dbo.Employees AS emp
WHERE emp.Title = 'Sales Representative' AND emp.Country = 'USA';


-- 5.  Orders placed by specific EmployeeID
-- Show all the orders placed by employee 5
SELECT ord.OrderID,
ord.OrderDate
FROM dbo.Orders AS ord
WHERE ord.EmployeeID = 5
ORDER BY ord.OrderID, ord.OrderDate;


-- 6. Suppliers and contract titles
-- show supplierID, ContatName and ContactTitle for suppliers whose contact title is not Marketing Manager
SELECT
	s.SupplierID
	,s.ContactName
	,s.ContactTitle
FROM DBO.Suppliers AS s
WHERE s.ContactTitle != 'Marketing Manager'


-- 7. get name of products with "queso" in it
-- get productID and productName
SELECT 
	P.ProductID
	,p.ProductName
FROM dbo.Products AS p
WHERE p.ProductName LIKE '%queso%'


-- 8. Orders shipping to France or Belgium
-- show the orderID, customerID and ShipCountry for orders where country is either France or Belgium
SELECT
	o.OrderID
	,o.CustomerID
	,o.ShipCountry
FROM dbo.Orders AS o
WHERE o.ShipCountry = 'France' OR o.ShipCountry = 'Belgium'


-- 9. Orders shipping to any country in Latin America
-- show the orderID, customerID and ShipCountry
SELECT
	o.OrderID
	,o.CustomerID
	,o.ShipCountry
FROM dbo.Orders AS o
WHERE o.ShipCountry IN('Brazil', 'Mexico', 'Argentina', 'Venezuela');


-- 10-11. Employees in order of age
-- first name, last name, title and birthdate
-- in the birthdate show only the date portion of the datetime field
SELECT TOP 10
	e.FirstName
	,e.LastName
	,e.Title
	,CONVERT(DATE, e.BirthDate) AS birth_date
	,DATEDIFF(YEAR, e.BirthDate, GETDATE()) AS age
FROM dbo.Employees AS e
ORDER BY e.BirthDate, age DESC;
--https://stackoverflow.com/questions/113045/how-to-return-only-the-date-from-a-sql-server-datetime-datatype
--https://www.w3schools.com/sql/func_sqlserver_datediff.asp
--https://www.w3schools.com/sql/func_sqlserver_getdate.asp


-- 12. get employees full name
-- show fn, ln and fn
SELECT
	e.FirstName
	,e.LastName
	,CONCAT(e.FirstName, e.LastName) AS FullName -- another way to concatenate fields --> e.FirstName + ' ' + e.LastName
FROM dbo.Employees AS e


-- 13. OrderDetails amount per line item
-- calculate the TotalPrice (UnitPrice * Quantity) for each item
-- show order id, product id, unit price and quantity
SELECT TOP 50
	od.OrderID
	,od.ProductID
	,od.UnitPrice
	,od.Quantity
	,CAST(
		(od.UnitPrice * od.Quantity) - ((od.UnitPrice * od.Quantity) * od.Discount) 
		AS DECIMAL(10,2)
		) AS [TotalPrice (€)]
FROM dbo.[Order Details] AS od
ORDER BY od.OrderID, od.ProductID


-- 14. How many custmoers do we have in the Customers Table?
SELECT
COUNT(c.CustomerID) AS TotalCustomers -- COUNT is an aggregate function
FROM dbo.Customers AS c


-- 15. When was the first order?
-- we need the ShippedDate
SELECT MIN(o.ShippedDate) AS FirstOrder
FROM dbo.Orders AS o


-- 16. list of Northwind's customers' countries (and how many)
SELECT
	c.Country
	,COUNT(c.CustomerID) AS TotalCustomers
FROM dbo.Customers AS c
GROUP BY c.Country
ORDER BY TotalCustomers DESC


-- 17. Contact titles for Customers
-- show how many customers have a contact title
SELECT 
	c.ContactTitle
	,COUNT(c.CustomerID) AS totalContacts
FROM dbo.Customers AS c
GROUP BY c.ContactTitle
ORDER BY totalContacts DESC


-- 18. For each product show the supplier
-- show ProductID, ProductName and CompanyName sort by ProductID
SELECT
	p.ProductID
	,p.ProductName
	,s.CompanyName
FROM Products AS p
JOIN Suppliers AS s ON p.SupplierID = s.SupplierID
ORDER BY p.ProductID


-- 19. Orders and the Shipper that was used
-- show order id, order date (date only), company name of the shippers, all sort by OrderId
SELECT
	o.OrderID
	,CONVERT(DATE, o.OrderDate) AS [Order Date]
	,s.CompanyName
FROM dbo.Orders AS o
JOIN dbo.Shippers AS s ON o.ShipVia = s.ShipperID
WHERE o.OrderID < 10300
ORDER BY o.OrderID;



-- INTERMEDIATE EXERCISES

-- 20. Categories and total products in each category
SELECT
	c.CategoryName
	,COUNT(*) AS totalProducts
FROM dbo.Products AS p
JOIN dbo.Categories AS c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY totalProducts DESC;


-- 21. Total num of customers per country and city
-- get the Customer table

SELECT
	c.Country
	,c.City
	,COUNT(c.CustomerID) AS [Total Num Customer]
FROM dbo.Customers AS c
GROUP BY c.Country, c.City
ORDER BY
	c.Country
	,[Total Num Customer] DESC;


-- 22. Product reordering
-- What products should we be reordering?
-- use UnitsInStock and ReorderLevel --> get only those where the UnitsInStock is less than the ReorderLevel
-- ignore UnitsOnOrder and Discontinued. Order the results by ProductID.

SELECT
	p.ProductID
	,p.ProductName
	,p.UnitsInStock
	,p.ReorderLevel
FROM dbo.Products AS p
WHERE p.UnitsInStock < p.ReorderLevel
ORDER BY p.ProductID;


-- 23. Product that need reordering, continued
-- we need to use: UnitsInStock, UnitsOnOrder, ReorderLevel
-- the new field "Products that need reordering" needs
-- 1. UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel
-- 2. The Discontinued flag is flase (0)
SELECT
	p.ProductID
	,p.ProductName AS [Products that need reordering]
	,p.UnitsInStock
	,p.UnitsOnOrder
	,p.ReorderLevel
	,p.Discontinued
FROM dbo.Products AS p
WHERE 
	(p.UnitsInStock + p.UnitsOnOrder) <= p.ReorderLevel 
	AND p.Discontinued = 0
ORDER BY p.ProductID;


-- 24. Customer List By region
-- list of all customers sorted by region alphabetically
-- the customers with no region (NULL) should be at the bottom
-- within the same region sort companies by CustomerID
-- this is an example of computed field by using the CASE statement (if/else): then we use that field to order the results
SELECT
	c.CustomerID
	,c.CompanyName
	,c.Region
	,Category = 
	CASE
		WHEN c.Region IS NULL THEN 0
		ELSE 1
	END
FROM dbo.Customers AS c
ORDER BY
	Category DESC
	,c.Region
	,c.CustomerID;


-- 25. High freight charges
-- return the three highest ship country with the highest avg freight overall
-- order by avg in descending order
SELECT TOP 3
	o.ShipCountry
	,CAST(AVG(o.Freight) AS DECIMAL(10, 2)) AS avg_freight
FROM dbo.Orders AS o
GROUP BY o.ShipCountry
ORDER BY avg_freight DESC;


-- 26. Higest freight charges in 2015
SELECT TOP 3
	o.ShipCountry
	,CAST(AVG(o.Freight) AS DECIMAL(10, 2)) AS avg_freight
FROM dbo.Orders AS o
WHERE YEAR(o.OrderDate) = 1997 -- 2015 is not in the DB, let's use 1997, which is the equivalent of 2015 in the DB
GROUP BY o.ShipCountry
ORDER BY avg_freight DESC;


-- 27. go to page 286 and read the section DISCUSSION
-- bare in mind that datetime is different than date
-- if we use the BETWEEN clause to get a renge of data
-- it will only get the first available value in the date
-- eg: if the first shipping of the day is at 2012-12-31 00:00:00 and the second one is at 2012-12-31 00:07:30
-- it will only include the first one, 2012-12-31 00:00:00


-- 28. Hight freight in the last 12 months
-- as above get the three ship countries with the highest avg freigth cost
-- but instead of filtering for years, filter for the last 12 months of order data (meaning filtering the entire data)
-- as the end date use the last order date available in Orders
SELECT TOP 3
	o.ShipCountry
	,AVG(o.Freight) AS avg_freight
FROM dbo.Orders AS o
WHERE o.OrderDate >= ( -- it's as if we write o.OrderDate >= 1997-05-06
	SELECT
		DATEADD(YEAR, -1,MAX(sub.OrderDate)) AS filter_date -- we only get one date: 1997-05-06
	FROM dbo.Orders AS sub
	) -- thid is a simple subquery: if we run this query, we get one date that will be used to filter the results
GROUP BY o.ShipCountry
ORDER BY avg_freight DESC
-- we could have done the subquery as the book did 
-- OrderDate >= Dateadd(yy, -1, (Select max(OrderDate) from Orders)) --> notice that the SELECT statment is inside the DATEADD
-- we get the same result

-- correlated subquery (it matches the result we get above)
-- this type of subquery is different: usually the inner query runs first.
-- in this case, the outer query is executed first and then the inner query is executed
SELECT TOP 3
	o.ShipCountry
	,AVG(o.freight) AS avg_freight
FROM dbo.Orders AS o
WHERE o.OrderDate >= ALL(
	SELECT 
		DATEADD(MONTH, -12, MAX(sub.OrderDate)) AS FilterDate
	FROM dbo.Orders AS sub
	WHERE sub.ShipCountry = o.ShipCountry -- the value is filtered but nothing changes because the value is already the maximum value
)
GROUP BY o.ShipCountry
ORDER BY avg_freight DESC;

-- this is the proof: if we execute the inner query as a normal query we get a filtered date based on the current shipcountry
-- even if we use the filter clause WHERE, the max fuction cannot be filtered because is the max value! So the value will be equal for everybody
SELECT 
	DATEADD(MONTH, -12, MAX(sub.OrderDate)) AS FilterDate
FROM dbo.Orders AS sub
WHERE sub.ShipCountry = 'USA' -- sub.ShipCountry = 'France' have the same values