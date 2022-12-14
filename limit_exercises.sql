-- 1. List the first 10 distinct last name sorted in descending order.

SELECT DISTINCT last_name
FROM employees
ORDER BY last_name DESC
LIMIT 10;

-- Find all previous or current employees hired in the 90s and born on Christmas.
SELECT *
FROM employees
WHERE hire_date LIKE '199%'
	AND birth_date LIKE '%12-25';

 
-- Find the first 5 employees hired in the 90's by sorting by hire date and limiting your results to the first 5 records. 
-- Write a comment in your code that lists the five names of the employees returned.

SELECT first_name, last_name
FROM employees
WHERE hire_date LIKE '199%' AND birth_date LIKE '%12-25'
ORDER BY hire_date
LIMIT 5;

-- Alselm, Cappello
-- Utz, Mandell
-- Bouchung, Schreiter
-- Baocai, Kushner
-- Petter, Stroustrup

-- Page #10

SELECT first_name, last_name
FROM employees
WHERE hire_date LIKE '199%' AND birth_date LIKE '%12-25'
ORDER BY hire_date
LIMIT 5 OFFSET 45;

-- 'Pranay', 'Narwekar'
-- 'Marjo', 'Farrow'
-- 'Ennio', 'Karcich'
-- 'Dines', 'Lubachevsky'
-- 'Ipke', 'Fontan'


-- What is the relationship between OFFSET (number of results to skip), LIMIT (number of results per page), and the page number?
PAGE = OFFSET / LIMIT + 1
OFFSET = (PAGE - 1) * LIMIT