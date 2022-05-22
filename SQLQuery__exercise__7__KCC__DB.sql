SELECT order_date,
list_price as unit_price,
(sales.order_items.list_price - (sales.order_items.list_price * discount)) * quantity as total_price
FROM sales.orders
JOIN sales.order_items on sales.order_items.order_id = sales.orders.order_id
ORDER BY order_date, total_price DESC