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

-- MID-COURSE TEST 
-- Question 1
SELECT DISTINCT replacement_cost FROM film
ORDER BY replacement_cost -- 9.99
-- Question 2
SELECT COUNT(*),
CASE
  WHEN replacement_cost BETWEEN '9.99' AND '19.99' THEN 'low'
  WHEN replacement_cost BETWEEN '20' AND '24.99' THEN 'medium'
  WHEN replacement_cost BETWEEN '25' AND '29.99' THEN 'high'
END AS category
FROM film
WHERE CASE
  WHEN replacement_cost BETWEEN '9.99' AND '19.99' THEN 'low'
  WHEN replacement_cost BETWEEN '20' AND '24.99' THEN 'medium'
  WHEN replacement_cost BETWEEN '25' AND '29.99' THEN 'high'
END ='low' --LOW: 51
GROUP BY category 
-- Question 3
SELECT a.title AS film_title, a.length AS length, c.name AS category_name
FROM film AS a
JOIN film_category AS b ON a.film_id = b.film_id
JOIN category AS c ON b.category_id = c.category_id
WHERE c.name IN ('Drama', 'Sports')
ORDER BY length DESC -- SPORTS - LENGTH 184
-- Question 4
SELECT c.name AS category_name, COUNT(a.title) AS film_title
FROM film AS a
JOIN film_category AS b ON a.film_id = b.film_id
JOIN category AS c ON b.category_id = c.category_id
GROUP BY c.name
ORDER BY film_title DESC -- SPORTS: 74
-- Question 5
SELECT a.first_name, a.last_name, COUNT(b.film_id) AS so_luong_phim
FROM actor AS a
LEFT JOIN film_actor AS b
ON a.actor_id = b.actor_id
GROUP BY a.first_name, a.last_name
ORDER BY so_luong_phim DESC -- SUSAN DAVIS: 54 MOVIES
-- QUESTION 6
SELECT COUNT(a.address) AS null_address
FROM address AS a
LEFT JOIN customer AS b
ON a.address_id = b.address_id
WHERE customer_id IS NULL --4
-- Question 7
SELECT a.city, SUM(d.amount) AS total_amount
FROM city AS a 
JOIN address AS b ON a.city_id = b.city_id
JOIN customer AS c ON b.address_id = c.address_id
JOIN payment AS d on c.customer_id = d.customer_id
GROUP BY a.city
ORDER BY total_amount DESC -- Cape Coral : 221.55
-- Question 8 --> câu này em ra khác đáp án so với kết quả, nhờ mn xem lại giúp em
SELECT a.city || ',' || ' ' || e.country AS full_name , SUM(d.amount) AS total_amount
FROM city AS a 
JOIN address AS b ON a.city_id = b.city_id 
JOIN customer AS c ON b.address_id = c.address_id
JOIN payment AS d on c.customer_id = d.customer_id
JOIN country AS e ON a.country_id = e.country_id
GROUP BY full_name
ORDER BY total_amount DESC  -- Cape Coral, United States : 221.55 
