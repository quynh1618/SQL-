-- EX 1
WITH twt_job_count AS
(SELECT company_id, title, description, COUNT(job_id) AS job_count 
FROM job_listings
GROUP BY company_id, title, description)
SELECT COUNT (DISTINCT company_id) AS duplicate_companies
FROM twt_job_count
WHERE job_count > 1
-- EX 2
WITH twt_first_step AS(
SELECT category, product, SUM(spend) AS total_spending,
RANK()OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS ranking
FROM product_spend
WHERE EXTRACT(year FROM transaction_date) ='2022'
GROUP BY category, product
)
SELECT category, product, total_spending
FROM twt_first_step
WHERE ranking <=2
-- EX3
WITH twt_call_count AS(
SELECT policy_holder_id, COUNT(case_id) AS total_call
FROM callers
GROUP BY policy_holder_id
)
SELECT COUNT(DISTINCT policy_holder_id) FROM twt_call_count
WHERE total_call >= 3
-- EX4
SELECT a.page_id
FROM pages AS a 
LEFT JOIN page_likes AS b 
ON a.page_id = b.page_id
WHERE b.liked_date IS NULL
ORDER BY a.page_id
-- EX5
WITH twt_month AS
(SELECT user_id, EXTRACT(MONTH FROM event_date) AS Month
FROM user_actions
WHERE event_type IN ('sign-in','like','comment') 
AND EXTRACT(YEAR FROM event_date) = '2022'
AND EXTRACT(MONth FROM event_date) = '7'
GROUP BY user_id, EXTRACT(MONTH FROM event_date)
),
twt_user_active AS(
SELECT a.user_id, a.Month, b.Month 
FROM twt_month as a 
JOIN twt_month as b ON a.user_id = b.user_id 
WHERE a.Month = b.Month-1
)
SELECT Month, COUNT(user_id) AS monthly_active_users FROM twt_month
GROUP BY Month
-- EX6
SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month, country,
COUNT(id) AS trans_count,
SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
SUM(amount) AS trans_total_amount,
SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country
-- EX7
WITH twt_year_ranking AS(
SELECT product_id, year, quantity, price,
RANK()OVER (PARTITION BY product_id ORDER BY year) AS ranking
FROM Sales)
SELECT product_id, year AS first_year, quantity, price
FROM twt_year_ranking
WHERE ranking = 1
-- EX8
WITH twt_product_count AS(
SELECT customer_id, product_key, COUNT(DISTINCT product_key) AS count
FROM Customer
GROUP BY customer_id)
SELECT a.customer_id 
FROM twt_product_count AS a
JOIN Product AS b ON a.product_key=b.product_key
WHERE a.count= (SELECT COUNT(DISTINCT product_key) FROM Product)
-- EX 9
WITH twt_salary_filter AS(
SELECT employee_id, name, manager_id, salary FROM Employees
WHERE salary < 30000 AND manager_id IS NOT NULL)
SELECT a.employee_id
FROM twt_salary_filter AS a
LEFT JOIN twt_salary_filter AS b ON a.manager_id=b.employee_id
WHERE b.employee_id IS NULL
ORDER BY a.employee_id
-- EX10
WITH twt_job_count AS
(SELECT company_id, title, description, COUNT(job_id) AS job_count 
FROM job_listings
GROUP BY company_id, title, description)
SELECT COUNT (DISTINCT company_id) AS duplicate_companies
FROM twt_job_count
WHERE job_count > 1
-- EX 11 
WITH twt_name AS(
SELECT a.user_id, a.name AS results, COUNT(b.rating)
FROM Users AS a 
JOIN MovieRating AS b ON a.user_id = b.user_id
GROUP BY a.user_id
ORDER BY COUNT(b.rating) DESC, a.name 
LIMIT 1),
twt_rating AS(
SELECT c.title AS results, AVG(b.rating)
FROM Movies AS c
JOIN MovieRating AS b ON c.movie_id = b.movie_id
WHERE EXTRACT(YEAR FROM b.created_at) ='2020' AND EXTRACT(MONTH FROM b.created_at) ='02'
GROUP BY c.title
ORDER BY AVG(b.rating) DESC, c.title
LIMIT 1)
SELECT results FROM twt_name
UNION (SELECT results FROM twt_rating)
-- EX 12 
WITH CTE AS(
SELECT ids, count FROM
(SELECT requester_id AS ids, COUNT(accepter_id) AS count
FROM RequestAccepted 
GROUP BY requester_id
UNION
SELECT accepter_id AS ids, COUNT(requester_id) AS count
FROM RequestAccepted
GROUP BY accepter_id) AS SUB
)
SELECT ids AS id, SUM(count) AS num
FROM CTE
GROUP BY id
ORDER BY num DESC
LIMIT 1
