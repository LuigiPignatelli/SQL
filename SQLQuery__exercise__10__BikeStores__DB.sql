-- purchases made by customers per years
SELECT customer_id,
YEAR(order_date) as order_year,
COUNT(order_id) as orders
FROM sales.orders
WHERE customer_id IN(1, 2)
GROUP BY customer_id, YEAR(order_date)
ORDER BY customer_id