-- CustomerName (Customers), CookieName (Product), Quantity (Order_product), Order Totral (Orders)
-- in order to make the join possible --> CustomerID (both in Customers and Orders), OrderID (Order_Product and Orders), CookieID (Order_Product and Product)
-- https://stackoverflow.com/questions/57742264/sql-invalid-object-name

-- calculate the unit price
SELECT dbo.Customers.CustomerName,
dbo.Orders.OrderDate,
dbo.Product.CookieName,
dbo.Order_Product.Quantity as QTY,
dbo.Product.RevenuePerCookie as UnitPrice,
dbo.Product.RevenuePerCookie * dbo.Order_Product.Quantity as TotalPrice,
dbo.Product.CostPerCookie as UnitCost,
(dbo.Product.CostPerCookie * dbo.Order_Product.Quantity) as TotalProfit,
(dbo.Product.RevenuePerCookie * dbo.Order_Product.Quantity) - dbo.Product.RevenuePerCookie - dbo.Product.CostPerCookie as ProfitPerCookie
FROM dbo.Customers
JOIN dbo.Orders ON dbo.Customers.CustomerID = dbo.Orders.CustomerID
JOIN dbo.Order_Product ON dbo.Orders.OrderID = dbo.Order_Product.OrderID
JOIN dbo.Product ON dbo.Order_Product.CookieID = dbo.Product.CookieID
GROUP BY CustomerName, OrderDate, CookieName, Quantity, dbo.Product.RevenuePerCookie, dbo.Product.CostPerCookie
ORDER BY OrderDate, CustomerName

-- profit per day, profit unit