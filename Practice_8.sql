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
-- ex4
