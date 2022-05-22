SELECT customer_id,
YEAR(order_date) as year_order,
COUNT(order_id) as num_of_orders
FROM sales.orders
GROUP BY customer_id, YEAR(order_date)
-- why does GROUP BY need both year and customer_id? Some customers may have ordered more goods over the year!
-- for each customer we want to know the number of orders

-- how many orders were made over 2016, 2017 and 2018