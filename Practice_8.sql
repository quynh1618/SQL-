-- ex1
WITH twt_rank AS(
SELECT *, 
(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END) as immediate,
RANK()OVER(PARTITION BY customer_id ORDER BY order_date) AS rnk
FROM Delivery
)
SELECT ROUND(SUM(immediate)/COUNT(rnk)*100,2) AS immediate_percentage
FROM twt_rank
WHERE rnk = 1
-- ex2
WITH twt_first_date AS(
SELECT player_id,
MIN(event_date) AS first_date
FROM Activity
GROUP BY player_id), 
twt_source AS(
SELECT * FROM Activity)
SELECT 
ROUND(SUM(CASE WHEN a.first_date + 1= b.event_date THEN 1 ELSE 0 END)/ COUNT(DISTINCT b.player_id),2) AS fraction
FROM twt_first_date AS a 
JOIN twt_source AS b ON a.player_id = b.player_id
-- ex3
SELECT 
CASE 
WHEN id%2 = 1 AND id < (SELECT MAX(id) FROM Seat) THEN id+1
WHEN id%2 = 0 THEN id-1
ELSE id
END AS id, student
FROM Seat
ORDER BY id ASC
-- ex4 (nhờ mn chữa giúp em bài này ạ)
-- ex5
WITH twt_filter AS(
SELECT tiv_2016,
COUNT(*)OVER(PARTITION BY lat, lon) AS count1,
COUNT(*)OVER(PARTITION BY tiv_2015) AS count2
FROM Insurance)
SELECT ROUND(SUM(tiv_2016),2) AS tiv_2016
FROM twt_filter
WHERE count1 = 1 AND count2 > 1
-- ex6
WITH twt_rank AS(
SELECT b.name AS Department, a.name AS Employee, a.salary AS Salary,
DENSE_RANK()OVER(PARTITION BY b.name ORDER BY a.salary DESC) AS rnk
FROM Employee AS a 
JOIN Department AS b ON a.departmentId = b.id)
SELECT Department, Employee, Salary
FROM twt_rank 
WHERE rnk <=3
-- ex7
WITH twt_total_weight AS(
SELECT person_name,
SUM(weight)OVER(ORDER BY turn) AS total_weight
FROM Queue)
SELECT person_name
FROM twt_total_weight 
WHERE total_weight>= 1000 
LIMIT 1
--ex8 (nhờ mn chữa giúp em bài này ạ)


