SELECT
production.products.product_name,
production.brands.brand_name,
quantity, sales.order_items.list_price, discount,
sales.order_items.list_price - (sales.order_items.list_price * discount) as totalPrice,
order_date
FROM production.brands
JOIN production.products on production.products.brand_id = production.brands.brand_id
JOIN sales.order_items on sales.order_items.product_id = production.products.product_id
JOIN sales.orders on sales.orders.order_id = sales.order_items.order_id