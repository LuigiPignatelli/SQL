-- for each brand show min, max, average and total price for 2018
SELECT
brand_name,
--list_price
MIN(list_price) as min_price,
MAX(list_price) as max_price,
AVG(list_price) as average_price,
SUM(list_price) as total_price
FROM production.products as p
JOIN production.brands as b on b.brand_id = p.brand_id
--JOIN sales.order_items as i on i.product_id = p.product_id
WHERE model_year = 2018
GROUP BY brand_name
ORDER BY brand_name