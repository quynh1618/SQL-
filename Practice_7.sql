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
-- ex5
