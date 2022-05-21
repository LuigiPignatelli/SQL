-- date, somma quantità (Order_Product), order id, customer code, customer name, valore monetario ma no customer id
-- OrderData (Orders), OrderTotal (Orders), OrderID (Orders, Order_Product), CustomerName (Customers), CustomerID
SELECT OrderDate,
sum(dbo.Order_Product.Quantity) as QTY,
dbo.Orders.OrderTotal,
dbo.Order_Product.OrderID,
CustomerName
FROM dbo.Orders
JOIN dbo.Customers ON dbo.Orders.CustomerID = dbo.Customers.CustomerID
JOIN dbo.Order_Product ON dbo.Orders.OrderID= dbo.Order_Product.OrderID
WHERE OrderDate between '2022-01-01' and '2022-01-31' 
GROUP BY OrderDate, dbo.Order_Product.OrderID, CustomerName, dbo.Customers.CustomerID, dbo.Orders.OrderTotal
HAVING sum(dbo.Order_Product.Quantity) > 500 OR OrderTotal > 2000
-- specificare campi
ORDER BY OrderDate

-- HAVING --> clausola di selezione che non esiste in tabella
-- ordini che superano q 500 oppure che superano 2000 euro di order total
-- grafico con questi dati in ordine di data (distribuzione) dei customer name, quantità ordinate nelle singole date