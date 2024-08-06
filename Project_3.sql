-- ĐỀ BÀI:
Sau khi dữ liệu được làm sạch hãy tiến hành phân tích theo các gợi ý sau:
1) Doanh thu theo từng ProductLine, Year  và DealSize?
Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE
2) Đâu là tháng có bán tốt nhất mỗi năm?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
3) Product line nào được bán nhiều ở tháng 11?
Output: MONTH_ID, REVENUE, ORDER_NUMBER
4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
Xếp hạng các các doanh thu đó theo từng năm.
Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK
5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
-- PHẦN THỰC HÀNH
-- Câu 1
SELECT PRODUCTLINE, YEAR_ID, DEALSIZE, SUM(sales) AS REVENUE
FROM SALES_DATASET_RFM_PRJ
GROUP BY PRODUCTLINE, YEAR_ID, DEALSIZE
ORDER BY PRODUCTLINE
-- Câu 2
WITH cte1 AS(
SELECT year_id, month_id, sum(sales) AS REVENUE, count(ordernumber) AS ORDER_NUMBER
FROM SALES_DATASET_RFM_PRJ
GROUP BY year_id, month_id
ORDER BY year_id),
cte2 AS(
SELECT year_id, month_id, REVENUE, ORDER_NUMBER,
DENSE_RANK()OVER(PARTITION BY year_id ORDER BY REVENUE DESC) AS rnk1,
DENSE_RANK()OVER(PARTITION BY year_id ORDER BY ORDER_NUMBER DESC) AS rnk2
FROM cte1)
SELECT month_id, REVENUE, ORDER_NUMBER
FROM cte2
WHERE rnk1 = 1 AND rnk2 = 1
-- Câu 3
WITH cte1 AS(
SELECT productline, sum(sales) AS REVENUE, count(ordernumber) AS ORDER_NUMBER
FROM SALES_DATASET_RFM_PRJ
WHERE month_id = 11
GROUP BY productline),
cte2 AS(
SELECT productline, REVENUE, ORDER_NUMBER,
ROW_NUMBER()OVER(ORDER BY REVENUE DESC) AS rnk1,
ROW_NUMBER()OVER(ORDER BY ORDER_NUMBER DESC) AS rnk2
FROM cte1)
SELECT productline, REVENUE, ORDER_NUMBER
FROM cte2
WHERE rnk1=1 AND rnk2 = 1
-- Câu 4
WITH cte1 AS(
SELECT year_id, productline, sum(sales) AS REVENUE
FROM SALES_DATASET_RFM_PRJ
WHERE country = 'UK'
GROUP BY year_id, productline
ORDER BY year_id),
cte2 AS(
SELECT year_id, productline, REVENUE,
DENSE_RANK()OVER(PARTITION BY year_id ORDER BY REVENUE DESC) AS rnk1
FROM cte1)
SELECT year_id, productline, REVENUE,
RANK()OVER(ORDER BY REVENUE DESC)
FROM cte2
WHERE rnk1 = 1
-- Câu 5
WITH twt_customer_rfm AS(
SELECT customername, current_date - MAX(orderdate) AS R,
count(DISTINCT ordernumber) AS F,
SUM(sales) AS M
FROM SALES_DATASET_RFM_PRJ
GROUP BY customername),
rfm_scores AS(
SELECT customername,
ntile (5) OVER(ORDER BY R DESC) AS R_score,
ntile (5) OVER(ORDER BY F) AS F_score,
ntile (5) OVER(ORDER BY M) AS M_score
FROM twt_customer_rfm),
rfm_final AS(
SELECT customername,
CAST(R_score AS varchar)||CAST(F_score AS varchar)||CAST(M_score AS varchar) AS rfm_score
FROM rfm_scores)
SELECT a. customername, b. segment
FROM rfm_final AS a
JOIN segment_score AS b ON a.rfm_score = b.scores
WHERE b.segment = 'Champions'
