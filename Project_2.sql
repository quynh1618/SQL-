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
