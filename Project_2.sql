-- ADHOC TASK
-- TASK 1
SELECT FORMAT_DATE('%Y-%m', created_at) AS month_year, COUNT(DISTINCT user_id) AS total_user, COUNT (order_id) AS total_order
FROM bigquery-public-data.thelook_ecommerce.orders 
WHERE status = 'Complete' AND (FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04')
GROUP BY FORMAT_DATE('%Y-%m', created_at)
ORDER BY month_year DESC
-- số lượng đơn hàng và số lượng người dùng nhìn chung là tăng đều theo thời gian, số lượng người dùng và số lượng đơn hàng tỷ lệ thuận với nhau
-- TASK 2
SELECT FORMAT_DATE('%Y-%m', a.created_at) AS month_year, COUNT(DISTINCT a.user_id) AS distinct_users, 
ROUND(SUM(b.sale_price)/COUNT(a.order_id),2) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.orders AS a 
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b 
ON a.user_id = b.user_id
WHERE FORMAT_DATE('%Y-%m', a.created_at) BETWEEN '2019-01' AND '2022-04'
GROUP BY FORMAT_DATE('%Y-%m', a.created_at)
ORDER BY month_year DESC
-- SL người dùng nhìn chung tăng theo thời gian, giá trị đơn hàng trung bình biến động tăng giảm liên tục nhưng có xu hướng tăng từ 01/2019 - 04/2022
-- TASK 3
WITH cte AS
(SELECT first_name,last_name,gender,age,
CASE
WHEN age = (SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users) THEN 'youngest'
END AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE FORMAT_DATE('%Y-%m', a.created_at) BETWEEN '2019-01' AND '2022-04'
UNION
SELECT first_name,last_name,gender,age,
CASE
WHEN age = (SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users) THEN 'oldest'
END AS tag
FROM bigquery-public-data.thelook_ecommerce.users
WHERE FORMAT_DATE('%Y-%m', a.created_at) BETWEEN '2019-01' AND '2022-04')
SELECT gender,age,tag, COUNT(*)
FROM cte
GROUP BY gender, age, tag
WHERE tag IS NOT NULL
-- TASK 4
WITH twt_cte1 AS(
SELECT FORMAT_DATE('%Y-%m', created_at) AS month_year, product_id, SUM(sale_price) AS sales, 
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE (FORMAT_DATE('%Y-%m', created_at) BETWEEN '2019-01' AND '2022-04')
GROUP BY FORMAT_DATE('%Y-%m', created_at), product_id
ORDER BY month_year DESC),
twt_cte2 AS(
SELECT a.month_year AS month_year, a.product_id AS product_id, b.name AS product_name, a.sales AS sales, b.cost AS cost, (a.sales - b.cost) AS profit,
DENSE_RANK()OVER(PARTITION BY a.month_year ORDER BY a.sales - b.cost) AS rank_per_month
FROM twt_cte1 AS a
JOIN bigquery-public-data.thelook_ecommerce.products AS b
ON a.product_id = b.id)
SELECT month_year, product_id, product_name, sales, cost, rank_per_month
FROM twt_cte2
WHERE rank_per_month<= 5
-- TASK 5
SELECT FORMAT_DATE('%Y-%m-%d', b.created_at) AS dates, a.category AS product_categories, SUM(b.sale_price) AS revenue
FROM bigquery-public-data.thelook_ecommerce.products AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b
ON a.id = b.product_id
WHERE FORMAT_DATE('%Y-%m-%d', b.created_at) BETWEEN '2022-04-15' AND '2022-01-15'
GROUP BY a.category, FORMAT_DATE('%Y-%m-%d', b.created_at)
-- CREATE VIEW
CREATE OR REPLACE VIEW vw_ecommerce_analyst AS (
SELECT FORMAT_DATE('%Y-%m', a.created_at) AS month_year, EXTRACT(YEAR FROM a.created_at) AS Year,
c.category AS Product_category, SUM(b.sale_price) AS TPV, 
COUNT(b.order_id) AS TPO,
(SUM(b.sale_price) - LAG(SUM(b.sale_price)) OVER(PARTITION BY FORMAT_DATE('%Y-%m', a.created_at) ORDER BY FORMAT_DATE('%Y-%m', a.created_at)))/SUM(b.sale_price)*100 AS Revenue_growth,
(COUNT(b.order_id) - LAG(SUM(b.order_id)) OVER(PARTITION BY FORMAT_DATE('%Y-%m', a.created_at) ORDER BY FORMAT_DATE('%Y-%m', a.created_at)))/COUNT(b.order_id)*100 AS Order_growth,
SUM(c.cost) AS total_cost, (SUM(b.sale_price) - SUM(c.cost)) AS total_profit,
SUM(b.sale_price)/SUM(c.cost) AS Profit_to_cost_ratio
FROM bigquery-public-data.thelook_ecommerce.orders AS a
JOIN bigquery-public-data.thelook_ecommerce.order_items AS b ON a.order_id = b.order_id
JOIN bigquery-public-data.thelook_ecommerce.products AS c ON b.product_id = c.id 
GROUP BY FORMAT_DATE('%Y-%m', a.created_at), c.category
)
