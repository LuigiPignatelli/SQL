-- join some fields from Orders with other fields from Customers
SELECT
OrderDate,
sum(OrderTotal) as orderSum,
dbo.Customers.CustomerID,
CustomerName,
Country
FROM dbo.Orders
JOIN dbo.Customers on dbo.Orders.CustomerID = dbo.Customers.CustomerID
WHERE Country = 'United States'
GROUP BY OrderDate, dbo.Customers.CustomerID, CustomerName, Country
ORDER BY orderSum
-- ORDER BY OrderDate DESC

-- date, somma quantità, order id, customer code, customer name