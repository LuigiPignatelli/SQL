-- select all customers that begin with A
SELECT * 
FROM KCC.dbo.Customers
WHERE CustomerName NOT LIKE 'A%'