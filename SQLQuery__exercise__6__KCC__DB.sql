-- CustomerName (Customers), CookieName (Product), Quantity (Order_product), Order Totral (Orders)
-- in order to make the join possible --> CustomerID (both in Customers and Orders), OrderID (Order_Product and Orders), CookieID (Order_Product and Product)
SELECT dbo.Customers.CustomerName,
dbo.Product.CookieName,
dbo.Customers.Country,
dbo.Order_Product.Quantity as QTY,
(dbo.Product.CostPerCookie + dbo.Product.RevenuePerCookie) as Unit_Price,
dbo.Orders.OrderTotal as Profit
FROM dbo.Customers
JOIN dbo.Orders ON dbo.Customers.CustomerID = dbo.Orders.CustomerID
JOIN dbo.Order_Product ON dbo.Orders.OrderID = dbo.Order_Product.OrderID
JOIN dbo.Product ON dbo.Order_Product.CookieID = dbo.Product.CookieID
GROUP BY CustomerName, CookieName, Quantity, Country, OrderTotal,
(dbo.Product.CostPerCookie + dbo.Product.RevenuePerCookie)
ORDER BY CustomerName, dbo.Orders.OrderTotal

-- CALCOLARE IL PREZZO UNITARIO DEL COOKIE NAME --> before that we need to calculate the all the quantities for a single product
-- to calculate the unit price we need to look at the Product table
-- we get two interesting data: revenue per cookie and cost of production per cookie
-- in order to get the full price we sum these two data
-- ((dbo.Product.CostPerCookie + dbo.Product.RevenuePerCookie) / dbo.Order_Product.Quantity) 