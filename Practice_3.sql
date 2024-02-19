-- ex 1
SELECT Name FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name, 3), ID
-- ex 2
SELECT user_id, 
CONCAT(UPPER(LEFT(name,1)),LOWER(SUBSTRING(name FROM 2 FOR LENGTH(name)))) AS name
FROM Users
ORDER BY user_id
-- ex 3
SELECT manufacturer,
'$' || ROUND(SUM(total_sales)/1000000,0) || ' million' AS sale_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer
-- ex 4
SELECT EXTRACT(month FROM submit_date) AS mth, product_id AS product,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(month FROM submit_date), product_id
ORDER BY EXTRACT(month FROM submit_date), product_id
-- ex 5
SELECT sender_id, COUNT(message_id) AS message_count
FROM messages
WHERE sent_date BETWEEN '2022-08-01' AND '2022-09-01'
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
LIMIT 2
-- ex 6
SELECT tweet_id FROM Tweets
WHERE LENGTH(content) > 15
-- ex 7: nhờ chị chữa giúp em, em kb sai ở đâu :((
SELECT activity_date, COUNT(DISTINCT user_id) as active_users
FROM Activity
WHERE activity_date BETWEEN '2019-07-27' - 30 AND  '2019-07-27'
GROUP BY activity_date
-- ex 8:
SELECT COUNT(id) FROM employees
WHERE (EXTRACT(month FROM joining_date) BETWEEN 1 AND 7)
AND EXTRACT(year FROM joining_date) = 2022
-- ex 9
SELECT POSITION('a' IN first_name)
FROM worker
WHERE first_name = 'Amitah'
-- ex 10
SELECT winery, SUBSTRING(title FROM LENGTH(winery)+1 FOR 5)
FROM winemag_p2
WHERE country = 'Macedonia'
