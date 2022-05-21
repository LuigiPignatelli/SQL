SELECT
production.products.product_name,
production.brands.brand_name,
quantity, sales.order_items.list_price, discount,
sales.order_items.list_price - (sales.order_items.list_price * discount) as totalPrice,
order_date, sales.orders.order_id,
first_name, last_name
FROM production.brands
JOIN production.products on production.products.brand_id = production.brands.brand_id
JOIN sales.order_items on sales.order_items.product_id = production.products.product_id
JOIN sales.orders on sales.orders.order_id = sales.order_items.order_id
JOIN sales.customers on sales.customers.customer_id = sales.orders.customer_id
ORDER BY order_date ASC, product_name