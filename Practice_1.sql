-- ex1
SELECT NAME FROM CITY
WHERE POPULATION > 120000
AND COUNTRYCODE = 'USA'
-- ex2
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN'
-- ex3
SELECT CITY, STATE FROM STATION
-- ex4
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%'
-- ex5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%A' OR CITY LIKE '%E' OR CITY LIKE '%I' OR CITY LIKE '%O' OR CITY LIKE '%U'
--ex6
SELECT DISTINCT CITY FROM STATION
WHERE CITY NOT LIKE 'A%' AND CITY NOT LIKE 'E%' AND CITY NOT LIKE 'I%' AND CITY NOT LIKE 'O%' AND CITY NOT LIKE 'U%'
-- ex7
SELECT name FROM Employee
ORDER BY name
-- ex8
SELECT name FROM Employee
WHERE salary > 2000 AND months < 10
ORDER BY employee_id 
-- ex9
SELECT product_id FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y'
-- ex10
SELECT name FROM Customer
WHERE referee_id <> 2 OR referee_id IS null
--ex 11
SELECT name, population, area FROM World
WHERE  population >= 25000000 OR area >= 3000000
-- ex 12
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id = viewer_id
ORDER BY author_id
-- ex 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL
-- ex 14
SELECT * FROM lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary >= 70000
-- ex 15
SELECT advertising_channel FROM uber_advertising
WHERE money_spent > 100000 AND year = 2019
