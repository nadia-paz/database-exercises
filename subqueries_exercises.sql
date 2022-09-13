#1
-- Find all the current employees with the same hire date as employee 101010 using a sub-query.
USE employees;

SELECT e.emp_no, e.first_name, e.last_name, e.hire_date
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
WHERE e.hire_date = (SELECT hire_date FROM employees WHERE emp_no = '101010')
	AND de.to_date > CURDATE();

-- without JOINs
SELECT *
FROM employees
WHERE emp_no IN (
SELECT emp_no
FROM dept_emp de
WHERE emp_no IN (
					SELECT emp_no
					FROM employees 
					WHERE hire_date = (SELECT hire_date
										FROM employees
										WHERE emp_no = 101010)
					)
		AND de.to_date > CURDATE()
				);

#2
-- Find all the titles ever held by all current employees with the first name Aamod.

SELECT DISTINCT title
FROM titles
WHERE emp_no IN (
				SELECT emp_no
				FROM dept_emp
				WHERE to_date > CURDATE() 
					AND emp_no IN (SELECT emp_no
								FROM employees
								WHERE first_name = 'Aamod')

				);
-- 'Senior Staff','Staff','Engineer','Technique Leader','Senior Engineer','Assistant Engineer'


	

#3
-- How many people in the employees table are no longer working for the company? 
-- Give the answer in a comment in your code.

SELECT COUNT(*)
FROM (SELECT de.emp_no -- , e.first_name, e.last_name, de.to_date
	FROM employees e
	JOIN dept_emp as de ON de.emp_no = e.emp_no
	WHERE de.to_date < CURDATE()
    GROUP BY de.emp_no) AS result

-- without JOINs
SELECT COUNT(*)
FROM (
		SELECT *
		FROM employees
		WHERE emp_no IN (
						SELECT emp_no
						FROM dept_emp
						WHERE to_date < CURDATE()
						)
		) result;
-- 85108

#4
-- Find all the current department managers that are female. 
-- List their names in a comment in your code.

SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name, d.dept_name
FROM (SELECT emp_no, dept_no FROM dept_manager WHERE to_date > CURDATE()) AS manager
JOIN employees e ON manager.emp_no = e.emp_no
JOIN departments d ON manager.dept_no = d.dept_no
WHERE e.gender = 'F';

-- without JOINs
SELECT *
FROM employees
WHERE emp_no IN (
				SELECT emp_no
				FROM dept_manager
				WHERE to_date > CURDATE()
				)
                AND gender = 'F';
-- Isamu Legleitner, Karsten Sigstam, Leon DasSarma, Hilary Kambil


#5
-- Find all the employees who currently have a higher salary than the companies overall, 
-- historical average salary.

SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE s.to_date > CURDATE()
		AND s.salary > 
        (SELECT AVG(salary) FROM salaries)

-- WITHOU JOINS
SELECT *
FROM employees 
WHERE emp_no IN (
				SELECT emp_no
				FROM salaries
				WHERE salary > (SELECT AVG(salary) FROM salaries)
					AND emp_no IN (
							SELECT emp_no
							FROM dept_emp
							WHERE to_date > CURDATE()
									)
					AND to_date > CURDATE()
				);
--154543 rows

#6
-- How many current salaries are within 1 standard deviation of the current highest salary? 
-- (Hint: you can use a built in function to calculate the standard deviation.) 
-- What percentage of all salaries is this?
-- Hint You will likely use multiple subqueries in a variety of ways
-- Hint It's a good practice to write out all of the small queries that you can. 
-- Add a comment above the query showing the number of rows returned. 
-- You will use this number (or the query that produced it) in other, larger queries.

SELECT * FROM salaries
    WHERE to_date > CURDATE() AND 
    salary >= ((SELECT MAX(salary) FROM salaries) - (SELECT ROUND(STD(salary)) FROM salaries))
    AND 
    salary <= (SELECT MAX(salary) FROM salaries)  
-- 78 rows 

SELECT * 
FROM salaries
WHERE to_date > CURDATE() 
	AND 
    salary >= ((SELECT MAX(salary) FROM salaries WHERE to_date > CURDATE()) - (SELECT ROUND(STD(salary)) FROM salaries WHERE to_date > CURDATE()))
   -- AND 
    -- salary <= (SELECT MAX(salary) FROM salaries WHERE to_date > CURDATE())
-- 83 rows

SELECT COUNT(*)
FROM (
	SELECT * 
    FROM salaries
    WHERE to_date > CURDATE() 
	    AND 
    salary >= ((SELECT MAX(salary) FROM salaries WHERE to_date > CURDATE()) 
    - (SELECT ROUND(STD(salary)) FROM salaries WHERE to_date > CURDATE()))
) as result
-- 83 
SELECT (
	SELECT
	COUNT(*)
    FROM salaries
    WHERE to_date > CURDATE() 
	    AND 
    salary >= ((SELECT MAX(salary) FROM salaries WHERE to_date > CURDATE()) 
    - (SELECT STD(salary) FROM salaries WHERE to_date > CURDATE())))
    
 / (SELECT COUNT(*) FROM salaries WHERE to_date > CURDATE()) * 100;
 -- 0.0346

-- all answers in one row
SELECT result.one_std_away 'One STD away', 
		result.total_salaries 'Total number', 
        (result.one_std_away / result.total_salaries * 100) as 'Percentage'
FROM (
	SELECT
    -- count how many salaries currently are 1 std away from MAX(salary)
	CASE WHEN true THEN
		(SELECT COUNT(*) 
				FROM (
					SELECT * 
					FROM salaries
					WHERE to_date > CURDATE() 
						AND 
					salary >= ((SELECT MAX(salary) FROM salaries WHERE to_date > CURDATE()) 
					- (SELECT ROUND(STD(salary)) FROM salaries WHERE to_date > CURDATE()))
				) as r)
             END one_std_away,
    -- count the total number of current salaries         
	CASE WHEN TRUE THEN 
		(SELECT COUNT(*) FROM salaries WHERE to_date > CURDATE()) 
			END total_salaries
            ) result;

-- query edited by Mark
SELECT result.one_std_away 'One STD away', 
		result.total_salaries 'Total number', 
        (result.one_std_away / result.total_salaries * 100) as 'Percentage'
FROM (
	SELECT
    -- count how many salaries currently are 1 std away from MAX(salary)
	
		(SELECT COUNT(*) 
				FROM (
					SELECT * 
					FROM salaries
					WHERE to_date > CURDATE() 
						AND 
					salary >= ((SELECT MAX(salary) FROM salaries WHERE to_date > CURDATE()) 
					- (SELECT ROUND(STD(salary)) FROM salaries WHERE to_date > CURDATE()))
				) as r)
             as one_std_away,
    -- count the total number of current salaries         
	
		(SELECT COUNT(*) FROM salaries WHERE to_date > CURDATE()) 
			as total_salaries
            ) result;

-- BONUS
#1
-- Find all the department names that currently have female managers.
SELECT dept_name
FROM departments
WHERE dept_no IN (
				SELECT dept_no
				FROM dept_manager
				WHERE to_date > CURDATE() AND emp_no IN (
								SELECT emp_no
								FROM employees 
								WHERE gender = 'F'
								)
); -- 'Development','Finance', 'Human Resources''Research'

#2
-- Find the first and last name of the employee with the highest salary.
SELECT first_name, last_name
FROM employees
WHERE emp_no = (
		SELECT emp_no
		FROM salaries
		WHERE salary = (SELECT MAX(salary) FROM salaries)
);
-- Tokuyasu Pesch
#3
--Find the department name that the employee with the highest salary works in.
SELECT dept_name
FROM departments
WHERE dept_no = (
    SELECT dept_no
    FROM dept_emp
    WHERE emp_no = (
                    SELECT emp_no
                    FROM salaries
                    WHERE salary = (SELECT MAX(salary) FROM salaries)
            )
);
-- Sales