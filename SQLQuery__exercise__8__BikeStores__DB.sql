-- get cities from California where the customers are larger than 10
SELECT city,
COUNT(customer_id) AS customersPerCity
FROM sales.customers
WHERE state = 'CA'
GROUP BY city
HAVING COUNT(*) > 10
ORDER BY city

-- the WHERE clause filters row, while the HAVING clause filters GROUPS