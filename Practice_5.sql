-- PRACTICE 5
-- EX 1
SELECT a.CONTINENT,FLOOR((AVG(b.POPULATION))
FROM COUNTRY AS a
LEFT JOIN CITY as b
ON a. CODE = b.COUNTRYCODE
GROUP BY a.CONTINENT;
-- EX 2
SELECT ROUND(CAST(COUNT (CASE
WHEN b.signup_action IN ('Confirmed') THEN 1 ELSE 0
END)/ COUNT (DISTINCT a.user_id) AS DECIMAL),2) AS confirm_rate
FROM emails AS a
LEFT JOIN texts AS b 
ON a.email_id = b. email_id
-- EX 3
SELECT b.age_bucket,
ROUND (SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0
END)/ SUM (a.time_spent) *100,2) AS send_perc,
ROUND (SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0
END)/ SUM (a.time_spent) *100,2) AS open_perc
FROM activities AS a
LEFT JOIN age_breakdown AS b
ON a.user_id = b. user_id
WHERE a.activity_type IN ('send', 'open')
GROUP BY b.age_bucket
-- EX 4: nhờ mn chữa giúp em bài này, em chưa tìm ra hướng giải quyết :((
-- EX 5
SELECT mng.reports_to AS employee_id , emp.name AS name, COUNT(mng.reports_to) AS reports_count, ROUND(AVG(mng.age),0) AS average_age
FROM Employees AS mng
LEFT JOIN Employees AS emp ON mng.reports_to = emp.employee_id
WHERE mng.reports_to IS NOT NULL
GROUP BY mng.reports_to
ORDER BY mng.reports_to
-- EX 6
SELECT a.product_name, SUM(b.unit) as unit
FROM Products AS a
LEFT JOIN Orders AS b
ON a.product_id  = b. product_id 
WHERE EXTRACT(year FROM b.order_date) = '2020' AND EXTRACT(month FROM b.order_date) = '02' 
GROUP BY a.product_name
HAVING SUM(b.unit) >=100
-- EX 7
SELECT a.page_id
FROM pages AS a 
LEFT JOIN page_likes AS b 
ON a.page_id = b.page_id
WHERE b.liked_date IS NULL
ORDER BY a.page_id
