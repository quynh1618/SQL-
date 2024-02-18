--ex 1
SELECT DISTINCT CITY FROM STATION
WHERE ID%2=0
-- ex 2
SELECT COUNT(CITY) - COUNT(DISTINCT CITY) FROM STATION
-- ex 3
-- ex 4
SELECT
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) as DECIMAL),1) as mean
FROM items_per_order
- ex 5
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3
ORDER BY candidate_id
-- ex 6
SELECT user_id, DATE(MAX(post_date)) - DATE(MIN(post_date)) AS days_between FROM posts
WHERE post_date >= '2021-01-02'AND post_date < '2022-01-01'
GROUP BY user_id
HAVING DATE(MAX(post_date)) - DATE(MIN(post_date)) <> 0
-- ex 7
SELECT card_name, (MAX(issued_amount) - MIN(issued_amount)) as difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY (MAX(issued_amount) - MIN(issued_amount)) DESC
-- ex 8
SELECT manufacturer,
COUNT(drug) AS drug_count,
ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC
-- ex 9
SELECT * FROM Cinema
WHERE MOD(id,2) <> 0 
AND description NOT LIKE 'boring'
ORDER BY rating DESC
-- ex 10
SELECT teacher_id,
COUNT(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id
-- ex 11
SELECT user_id,
COUNT(follower_id) as followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id
-- ex 12
SELECT class FROM Courses
GROUP BY class
HAVING COUNT(student) >= 5
