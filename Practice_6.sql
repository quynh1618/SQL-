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
