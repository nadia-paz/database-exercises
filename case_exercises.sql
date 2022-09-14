#1
-- Write a query that returns all employees, their department number,
-- their start date, their end date, and a new column 'is_current_employee'
-- that is a 1 if the employee is still with the company and 0 if not.
SELECT dept_no, first_name, last_name, from_date, to_date,
	CASE
		WHEN to_date > NOW() THEN 1
        ELSE 0
	END AS is_current_employee
FROM employees
JOIN dept_emp de USING (emp_no);

#2
-- Write a query that returns all employee names (previous and current),
-- and a new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z'
-- depending on the first letter of their last name.
SELECT first_name, last_name,
	CASE
		WHEN last_name BETWEEN 'A' AND 'Iz' THEN 'A-H'
        WHEN last_name BETWEEN 'I' AND 'Qz' THEN 'I-Q'
        WHEN last_name BETWEEN 'R' AND 'Zz' THEN 'R-Z'
	END AS alpha_group
FROM employees;

#3
-- How many employees (current or previous) were born in each decade?
SELECT 
	COUNT(CASE WHEN birth_date LIKE '195%' THEN 1 ELSE NULL END) AS '1950s',
    COUNT(CASE WHEN birth_date LIKE '196%' THEN 1 ELSE NULL END) AS '1960s'
FROM employees;

#4
-- What is the current average salary for each of the following department groups:
-- R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
SELECT dc.department_categories, AVG(s.salary)
FROM (
	SELECT
		dept_no,
        CASE
			WHEN dept_name IN ('Marketing', 'Sales') THEN 'Sales & Marketing'
			WHEN dept_name IN ('Research', 'Development') THEN 'R&D'
			WHEN dept_name LIKE 'prod%' OR dept_name LIKE 'quality%' THEN 'Prod & QM'
			WHEN dept_name LIKE 'Finance%' OR dept_name LIKE 'Human%' THEN'Finance & HR'
			ELSE 'Customer Service'
		END AS department_categories
FROM departments
) AS dc
JOIN dept_emp de ON dc.dept_no = de.dept_no AND de.to_date > NOW()
JOIN salaries s ON de.emp_no = s.emp_no AND s.to_date > NOW()
GROUP BY dc.department_categories;