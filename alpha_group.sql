-- Write a query that returns all employee names 
-- (previous and current), and a
-- new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' 
-- depending on the
-- first letter of their last name.


SELECT DISTINCT(last_name)
FROM employees
WHERE LOWER(last_name) LIKE '%q%' AND 
		LOWER(last_name) NOT LIKE '%qu%';
        
-- Using the Employees database, find all the titles ever held 
-- by all current employees with the first name Aamod.

SELECT DISTINCT(title)
FROM titles t
JOIN employees e USING(emp_no) 
WHERE t.to_date > NOW()
	AND e.first_name = 'Aamod'