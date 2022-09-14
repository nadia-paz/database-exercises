#1
-- Using the example from the lesson, create a temporary table called employees_with_departments 
-- that contains first_name, last_name, and dept_name for employees currently with that department. 
-- Be absolutely sure to create this table on your own database. If you see "Access denied for user ...",
-- it means that the query was attempting to write a new table to a database that you can only read.
CREATE TEMPORARY TABLE employees_with_departments AS (
SELECT first_name, last_name, dept_name
FROM employees.employees e
JOIN employees.dept_emp de USING(emp_no)
JOIN employees.departments d USING(dept_no)
WHERE to_date > CURDATE()
);

#2
-- Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of the lengths of the first name and last name columns
-- Update the table so that full name column contains the correct data
-- Remove the first_name and last_name columns from the table.

ALTER TABLE employees_with_departments ADD full_name VARCHAR(30);
UPDATE employees_with_departments SET full_name = CONCAT(first_name, ' ', last_name);
ALTER TABLE employees_with_departments DROP COLUMN first_name;
ALTER TABLE employees_with_departments DROP COLUMN last_name;

-- What is another way you could have ended up with this same table?
CREATE TEMPORARY TABLE employees_with_departments AS (
SELECT CONCAT(first_name, ' ', last_name) full_name, dept_name
FROM employees.employees e
JOIN employees.dept_emp de USING(emp_no)
JOIN employees.departments d USING(dept_no)
);

-- Create a temporary table based on the payment table from the sakila database.
CREATE TEMPORARY TABLE sakila_pay AS (
SELECT *
FROM sakila.payment);

#3
--Write the SQL necessary to transform the amount column such that it is stored as
-- an integer representing the number of cents of the payment. For example, 1.99 should become 199.
ALTER TABLE sakila_pay ADD amount_cents INT;
UPDATE sakila_pay SET amount_cents = amount *100;

-- alternative change the column type
ALTER TABLE sakila_pay MODIFY amount_in_cents INT NOT NULL;


#4
--Find out how the current average pay in each department compares to the overall current pay for 
-- everyone at the company. In order to make the comparison easier,
-- you should use the Z-score for salaries. In terms of salary, what is the best
-- department right now to work for? The worst?

USE mirzakhani_1945;

CREATE TEMPORARY TABLE salaries_compare AS (
SELECT d.dept_name, s.salary
FROM employees.dept_emp de
JOIN employees.departments d ON de.dept_no = d.dept_no
JOIN employees.salaries s ON de.emp_no = s.emp_no
WHERE de.to_date > CURDATE() AND s.to_date > CURDATE()
);

-- create a column with the mean of the current salaries, add values
ALTER TABLE salaries_compare ADD total_avg DECIMAL(10, 2);
UPDATE salaries_compare SET total_avg = (SELECT AVG(salary) FROM employees.salaries WHERE to_date > CURDATE());

-- create a column with the standard deviation of the current salaries, add values
ALTER TABLE salaries_compare ADD std_current_salaries DECIMAL(10, 2);
UPDATE salaries_compare SET std_current_salaries = (SELECT STD(salary) FROM employees.salaries WHERE to_date > curdate());

-- create the column with zscores for each salary
ALTER TABLE salaries_compare ADD zscore DECIMAL(10, 2);
UPDATE salaries_compare SET zscore = (salary - total_avg) / std_current_salaries;

-- Group all values
SELECT dept_name, 
		AVG(salary) as 'salary', 
		AVG(total_avg) as mean, 
        AVG(std_current_salaries) as 'standard deviation',
        AVG(zscore) as 'zscore'
FROM salaries_compare
GROUP BY dept_name
ORDER BY zscore DESC;

-- class solution
use mirzakhani_1945;

CREATE TEMPORARY TABLE overall_aggregates AS (
SELECT AVG(SALARY) AS avg_salary,
	STD(salary) AS std_salary
    FROM employees.salaries
    WHERE to_date > NOW()
);

SELECT dept_name, AVG(salary) as DEP_AVG_SALARY
FROM employees.salaries
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING(dept_no)
WHERE employees.dept_emp.to_date > NOW()
AND  employees.salaries.to_date > NOW()
group by dept_name;

CREATE TEMPORARY TABLE info AS (
SELECT dept_name, AVG(salary) as DEP_AVG_SALARY
FROM employees.salaries
JOIN employees.dept_emp USING (emp_no)
JOIN employees.departments USING(dept_no)
WHERE employees.dept_emp.to_date > NOW()
AND  employees.salaries.to_date > NOW()
group by dept_name
);

ALTER TABLE info ADD overall_av FLOAT(10, 2);
ALTER TABLE info ADD overall_STD FLOAT(10, 2);
ALTER TABLE info ADD zscore FLOAT(10, 2);

select * from info;
UPDATE info SET overall_av = (SELECT avg_salary FROM overall_aggregates);
UPDATE info SET overall_STD = (SELECT std_salary FROM overall_aggregates);
UPDATE info SET zscore = (DEP_AVG_SALARY - overall_av) / overall_STD;


--Hint Consider that the following code will produce the z score for current salaries.
-- Returns the historic z-scores for each salary
-- Notice that there are 2 separate scalar subqueries involved
SELECT salary,
    (salary - (SELECT AVG(salary) FROM salaries))
    /
    (SELECT stddev(salary) FROM salaries) AS zscore
FROM salaries;
-- BONUS To your work with current salary zscores, determine the overall historic average 
-- departement average salary, the historic overall average, and the historic zscores for salary.
-- Do the zscores for current department average salaries tell a similar or a different story than the historic department salary zscores?