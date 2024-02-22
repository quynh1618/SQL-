-- EX 1
SELECT 
SUM(CASE
  WHEN device_type = 'laptop' THEN 1 ELSE 0
END) AS laptop_views,
SUM (CASE
  WHEN device_type IN ( 'phone','tablet') THEN 1 ELSE 0
END) AS mobile_views
FROM viewership
GROUP BY laptop_views, mobile_views
-- EX 2
SELECT x,y,z,
CASE
  WHEN x+y > z AND x+z > y AND y+z > x THEN 'Yes'
  ELSE 'No'
END AS triangle
FROM Triangle
-- EX 3 (đã fix)
SELECT 
ROUND (CAST(COUNT(CASE 
WHEN call_category IN ('n/a', 'NULL') THEN 1 ELSE 0
END)/ count(call_category)) AS DECIMAL *100,1) AS call_percentage
FROM callers
-- EX 4
SELECT name FROM Customer
WHERE referee_id <> 2 OR referee_id IS null
-- EX 5
SELECT survived,
COUNT (CASE
WHEN pclass = 1 THEN 'first_class' END) AS first_class,
COUNT (CASE
WHEN pclass = 2 THEN 'second_class' END) AS second_class,
COUNT (CASE
WHEN pclass = 3 THEN 'third_class' END) AS third_class
FROM titanic
GROUP BY survived
