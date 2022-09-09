#2
--In your script, use DISTINCT to find the unique titles in the titles table. 
-- How many unique titles have there ever been? 
-- Answer that in a comment in your SQL file.

SELECT DISTINCT title
FROM titles; 
-- 7 titles

#3
-- Write a query to to find a list of all unique last names of all employees 
-- that start and end with 'E' using GROUP BY.

SELECT last_name
FROM employees
WHERE last_name LIKE 'E%e'
GROUP BY last_name;

#4
--Write a query to to find all unique combinations of first and last names 
-- of all employees whose last names start and end with 'E'.

--1
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE last_name LIKE 'E%e'
GROUP BY full_name;
--2
SELECT last_name, first_name
FROM employees
WHERE last_name LIKE 'E%e'
GROUP BY last_name, first_name
ORDER BY last_name, first_name;

#5
-- Write a query to find the unique last names with a 'q' but not 'qu'. 
-- Include those names in a comment in your sql code.

SELECT last_name
FROM employees
WHERE last_name LIKE '%q%' AND last_name NOT LIKE '%qu%'
GROUP BY last_name;

-- Chleq, Lindqist, Qiwen

#6
-- Add a COUNT() to your results (the query above) to find the number of employees with the same last name.

SELECT last_name, COUNT(last_name)
FROM employees
WHERE last_name LIKE '%q%' AND last_name NOT LIKE '%qu%'
GROUP BY last_name;

#7
--Find all all employees with first names 'Irena', 'Vidya', or 'Maya'. 
-- Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names.

SELECT first_name, gender, COUNT(first_name) AS quantity
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
GROUP BY first_name, gender
ORDER BY first_name, gender;

#8
-- Using your query that generates a username for all of the employees, generate a count employees
-- for each unique username. Are there any duplicate usernames? 
-- BONUS: How many duplicate usernames are there?

SELECT LOWER(
		CONCAT(
			SUBSTR(first_name, 1, 1), 
			SUBSTR(last_name, 1, 4), '_',
			DATE_FORMAT(birth_date, '%m'),
			DATE_FORMAT(birth_date, '%y')
		)
	) AS uname, COUNT(*) as number_of_unames
FROM employees
GROUP BY uname;
-- 285872 total usernames

SELECT LOWER(
		CONCAT(
			SUBSTR(first_name, 1, 1), 
			SUBSTR(last_name, 1, 4), '_',
			DATE_FORMAT(birth_date, '%m'),
			DATE_FORMAT(birth_date, '%y')
		)
	) AS uname, COUNT(*) as number_of_unames
FROM employees
GROUP BY uname
HAVING number_of_unames > 1;
-- 13251 duplicate usernames

#9
-- Bonus: More practice with aggregate functions:

-- Determine the historic average salary for each employee. 
-- When you hear, read, or think "for each" with regard to SQL, you'll probably be grouping by that exact column.


-- Using the dept_emp table, count how many current employees work in each department. 
-- The query result should show 9 rows, one for each department and the employee count.

-- Determine how many different salaries each employee has had. This includes both historic and current.

-- Find the maximum salary for each employee.

-- Find the minimum salary for each employee.

-- Find the standard deviation of salaries for each employee.

--Now find the max salary for each employee where that max salary is greater than $150,000.

-- Find the average salary for each employee where that average salary is between $80k and $90k.