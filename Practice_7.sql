-- ex1
WITH twt_each_year AS(
SELECT EXTRACT(YEAR FROM transaction_date) AS year, product_id,
spend as curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id
ORDER BY product_id, EXTRACT(YEAR FROM transaction_date)) as prev_year_spend
FROM user_transactions
)
SELECT year, product_id, curr_year_spend, prev_year_spend,
ROUND((curr_year_spend - prev_year_spend)/ prev_year_spend *100,2) AS yoy_rate
FROM twt_each_year
-- ex2
WITH twt_launch_date AS(
SELECT card_name, issued_amount,
ROW_NUMBER() OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) as launch_date
FROM monthly_cards_issued)
SELECT card_name, issued_amount
FROM twt_launch_date 
WHERE launch_date = 1
ORDER BY issued_amount DESC
-- ex3
WITH twt_rank AS(
SELECT user_id, spend, transaction_date,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) AS rnk
FROM transactions)
SELECT user_id, spend, transaction_date
FROM twt_rank
WHERE rnk = 3
-- ex4
WITH twt_rank AS(
SELECT user_id, transaction_date, product_id,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) as rnk
FROM user_transactions)
SELECT transaction_date, user_id,
COUNT(product_id) as purchase_count
FROM twt_rank
WHERE rnk = 1
GROUP BY transaction_date, user_id
-- ex5 (nhờ mn chữa giúp em bài này ạ)
-- ex6
WITH twt_minutes AS(
SELECT merchant_id, 
EXTRACT (EPOCH FROM 
transaction_timestamp - LAG(transaction_timestamp) OVER(PARTITION BY merchant_id, credit_card_id, amount
ORDER BY transaction_timestamp))/60 AS minutes
FROM transactions
)
SELECT COUNT(merchant_id) AS payment_count
FROM twt_minutes
WHERE minutes <= 10
-- ex7
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
-- ex8
WITH twt_cte AS(
SELECT a.artist_name AS artist_name, 
DENSE_RANK() OVER(ORDER BY COUNT(c.song_id) DESC) AS artist_rank
FROM artists AS a
JOIN songs AS b ON a.artist_id = b.artist_id
JOIN global_song_rank AS c ON b.song_id = c.song_id
WHERE c.rank <=10
GROUP BY a.artist_name)
SELECT artist_name, artist_rank
FROM twt_cte 
WHERE artist_rank <=5
