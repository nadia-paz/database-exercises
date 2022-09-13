-- JOIN example data base
#1
-- Use the join_example_db. Select all the records from both the users and roles tables.
USE join_example_db;
SELECT *
FROM roles, users;

SELECT *
FROM roles;

SELECT *
FROM users;


#2
-- Use join, left join, and right join to combine results from the users and roles tables 
-- as we did in the lesson. Before you run each query, guess the expected number of results.
SELECT *
FROM roles as r
JOIN users as u ON r.id = u.role_id;

SELECT *
FROM roles as r
LEFT JOIN users as u ON r.id = u.role_id;

SELECT *
FROM roles as r
RIGHT JOIN users as u ON r.id = u.role_id;
#3
-- Although not explicitly covered in the lesson, aggregate functions like count can be 
-- used with join queries. Use count and the appropriate join type to get 
-- a list of roles along with the number of users that has the role. 
-- Hint: You will also need to use group by in the query.

SELECT r.id, r.name, COUNT(u.id) AS 'Number of users'
FROM roles as r
LEFT JOIN users as u ON r.id = u.role_id
GROUP BY r.id;
-- COUNT(*) in the query returns INCORRECT number of users

########
-- Employees Database
#1
-- Use the employees database.
USE employees;

#2
-- Using the example in the Associative Table Joins section as a guide, 
-- write a query that shows each department along with the name of the current 
-- manager for that department.

SELECT d.dept_name as 'Department', 
		CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager'
FROM departments as d
JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
JOIN employees AS e ON dm.emp_no = e.emp_no
WHERE dm.to_date > CURDATE();

-- class solution
SELECT *
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no 
        AND dm.to_date > CURDATE()
JOIN departments d USING(dept_no);

/*
 Department Name    | Department Manager
 --------------------+--------------------
  Customer Service   | Yuchang Weedman
  Development        | Leon DasSarma
  Finance            | Isamu Legleitner
  Human Resources    | Karsten Sigstam
  Marketing          | Vishwani Minakawa
  Production         | Oscar Ghazalie
  Quality Management | Dung Pesch
  Research           | Hilary Kambil
  Sales              | Hauke Zhang
*/

#3
-- Find the name of all departments currently managed by women.

SELECT d.dept_name as 'Department', 
		CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager'
FROM departments as d
JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
JOIN employees AS e ON dm.emp_no = e.emp_no
WHERE dm.to_date > CURDATE() AND e.gender = 'F';

-- class solution
SELECT *
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no 
        AND dm.to_date > CURDATE()
        AND e.gender = 'F'
JOIN departments d USING(dept_no);

/*
Department Name | Manager Name
----------------+-----------------
Development     | Leon DasSarma
Finance         | Isamu Legleitner
Human Resources | Karsetn Sigstam
Research        | Hilary Kambil 
*/

#4
-- Find the current titles of employees currently working in the Customer Service department.

SELECT t.title AS 'Title', COUNT(t.emp_no) AS 'Count'
FROM titles AS t
JOIN dept_emp AS de ON t.emp_no = de.emp_no
JOIN employees AS e ON t.emp_no = e.emp_no
WHERE de.dept_no LIKE 'd009' AND t.to_date > CURDATE()
GROUP BY t.title;

-- not all numbers are the same as in the table
-- correct solution
SELECT t.title AS 'Title', COUNT(de.emp_no) AS 'Count'
FROM dept_emp de
JOIN titles t ON de.emp_no = t.emp_no 
			  AND de.to_date > CURDATE()
              AND t.to_date > CURDATE()
JOIN departments d ON de.dept_no = d.dept_no AND d.dept_name LIKE 'Customer%'
GROUP BY t.title;

/*
Title              | Count
-------------------+------
Assistant Engineer |    68
Engineer           |   627
Manager            |     1
Senior Engineer    |  1790
Senior Staff       | 11268
Staff              |  3574
Technique Leader   |   241
*/

#5
--Find the current salary of all current managers.

SELECT d.dept_name as 'Department Name', 
		CONCAT(e.first_name, ' ', e.last_name) AS 'Name',
        s.salary AS 'Salary'
FROM departments as d
JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
JOIN employees AS e ON dm.emp_no = e.emp_no
JOIN salaries AS s ON s.emp_no = e.emp_no
WHERE dm.to_date > CURDATE() AND s.to_date > CURDATE();

-- class solution
SELECT d.dept_name as 'Department Name', 
	   CONCAT(e.first_name, ' ', e.last_name) AS 'Name',
	   s.salary AS 'Salary'
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
	AND s.to_date > CURDATE()
JOIN dept_manager dm ON e.emp_no = dm.emp_no
	AND dm.to_date > CURDATE()
JOIN departments d ON dm.dept_no = d.dept_no
ORDER BY d.dept_name;

/*
Department Name    | Name              | Salary
-------------------+-------------------+-------
Customer Service   | Yuchang Weedman   |  58745
Development        | Leon DasSarma     |  74510
Finance            | Isamu Legleitner  |  83457
Human Resources    | Karsten Sigstam   |  65400
Marketing          | Vishwani Minakawa | 106491
Production         | Oscar Ghazalie    |  56654
Quality Management | Dung Pesch        |  72876
Research           | Hilary Kambil     |  79393
Sales              | Hauke Zhang       | 101987
*/

#6
--Find the number of current employees in each department.

SELECT d.dept_no, 
		d.dept_name, 
        COUNT(de.emp_no) AS num_employees
FROM departments AS d
JOIN dept_emp AS de ON d.dept_no = de.dept_no
WHERE de.to_date > CURDATE()
GROUP BY d.dept_no
ORDER BY d.dept_no;

-- class solution
SELECT d.dept_no, d.dept_name, COUNT(emp_no)
FROM dept_emp de
JOIN departments d ON de.dept_no = d.dept_no
	 AND  de.to_date > CURDATE()
GROUP BY d.dept_no, d.dept_name
ORDER BY d.dept_no;

/*
+---------+--------------------+---------------+
| dept_no | dept_name          | num_employees |
+---------+--------------------+---------------+
| d001    | Marketing          | 14842         |
| d002    | Finance            | 12437         |
| d003    | Human Resources    | 12898         |
| d004    | Production         | 53304         |
| d005    | Development        | 61386         |
| d006    | Quality Management | 14546         |
| d007    | Sales              | 37701         |
| d008    | Research           | 15441         |
| d009    | Customer Service   | 17569         |
+---------+--------------------+---------------+
*/

#7
--Which department has the highest average salary? Hint: Use current not historic information.

SELECT d.dept_name, 
        AVG(s.salary) AS average_salary
FROM departments AS d
JOIN dept_emp AS de ON d.dept_no = de.dept_no
JOIN salaries AS s ON de.emp_no = s.emp_no
WHERE de.to_date > CURDATE() AND s.to_date > CURDATE()
GROUP BY d.dept_no
ORDER BY average_salary DESC
LIMIT 1; -- 1.5 seconds

SELECT d.dept_name, 
        AVG(s.salary) AS average_salary
FROM dept_emp AS de
JOIN departments AS d ON de.dept_no = d.dept_no
JOIN salaries AS s ON de.emp_no = s.emp_no
WHERE de.to_date > CURDATE() AND s.to_date > CURDATE()
GROUP BY d.dept_no
ORDER BY average_salary DESC
LIMIT 1; -- 1.7 seconds

-- class solution
SELECT d.dept_name, AVG(s.salary) average_salary
FROM dept_emp de
JOIN salaries s ON de.emp_no = s.emp_no AND de.to_date > CURDATE() AND s.to_date > CURDATE()
JOIN departments d USING (dept_no)
GROUP BY d.dept_name
ORDER BY average_salary  DESC
LIMIT 1; 

/*
+-----------+----------------+
| dept_name | average_salary |
+-----------+----------------+
| Sales     | 88852.9695     |
+-----------+----------------+
*/

#8
-- Who is the highest paid employee in the Marketing department?

-- with max_salary
SELECT e.first_name, e.last_name, MAX(s.salary) AS max_salary
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN salaries AS s ON de.emp_no = s.emp_no
WHERE de.dept_no = 'd001'
GROUP BY de.emp_no
ORDER BY max_salary DESC
LIMIT 1;

--
SELECT e.first_name, e.last_name
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN salaries AS s ON de.emp_no = s.emp_no
WHERE de.dept_no = 'd001'
ORDER BY s.salary DESC
LIMIT 1;

-- class solution
SELECT e.first_name, e.last_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
	AND de.to_date > CURDATE()
JOIN salaries s ON e.emp_no = s.emp_no
	AND s.to_date > CURDATE()
JOIN departments d ON de.dept_no = d.dept_no
	AND d.dept_name = 'Marketing'
ORDER BY s.salary DESC
LIMIT 1;

/*
+------------+-----------+
| first_name | last_name |
+------------+-----------+
| Akemi      | Warwick   |
+------------+-----------+
*/

#9
-- Which current department manager has the highest salary?

SELECT 	e.first_name, 
		e.last_name,
        s.salary,
        d.dept_name        
FROM departments as d
JOIN dept_manager AS dm ON d.dept_no = dm.dept_no
JOIN employees AS e ON dm.emp_no = e.emp_no
JOIN salaries AS s ON s.emp_no = e.emp_no
WHERE dm.to_date > CURDATE() AND s.to_date > CURDATE() 
ORDER BY s.salary DESC
LIMIT 1;

-- class solution 
SELECT e.first_name, e.last_name, s.salary, d.dept_name
FROM employees e
JOIN dept_manager dm ON e.emp_no = dm.emp_no
	AND dm.to_date > CURDATE()
JOIN salaries s ON e.emp_no = s.emp_no 
	AND s.to_date > CURDATE()
JOIN departments d ON dm.dept_no = d.dept_no
ORDER BY s.salary DESC
LIMIT 1;

/*
+------------+-----------+--------+-----------+
| first_name | last_name | salary | dept_name |
+------------+-----------+--------+-----------+
| Vishwani   | Minakawa  | 106491 | Marketing |
+------------+-----------+--------+-----------+
*/

#10
--Determine the average salary for each department. Use all salary information and round your results.

SELECT d.dept_name, 
        ROUND(AVG(s.salary)) AS average_salary
FROM departments AS d
JOIN dept_emp AS de ON d.dept_no = de.dept_no
JOIN salaries AS s ON de.emp_no = s.emp_no
GROUP BY d.dept_no
ORDER BY average_salary DESC;

-- class solution
SELECT d.dept_name, ROUND(AVG(s.salary), 0) average_salary
FROM departments d
JOIN dept_emp de ON d.dept_no = de.dept_no
JOIN salaries s ON de.emp_no = s.emp_no
GROUP BY d.dept_name
ORDER BY average_salary DESC;

/*
+--------------------+----------------+
| dept_name          | average_salary | 
+--------------------+----------------+
| Sales              | 80668          | 
+--------------------+----------------+
| Marketing          | 71913          |
+--------------------+----------------+
| Finance            | 70489          |
+--------------------+----------------+
| Research           | 59665          |
+--------------------+----------------+
| Production         | 59605          |
+--------------------+----------------+
| Development        | 59479          |
+--------------------+----------------+
| Customer Service   | 58770          |
+--------------------+----------------+
| Quality Management | 57251          |
+--------------------+----------------+
| Human Resources    | 55575          |
+--------------------+----------------+
*/

#11
-- Bonus Find the names of all current employees, their department name, 
-- and their current manager's name.

SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Employee Name',
		d.dept_name AS 'Department Name',
        CONCAT(em.first_name, ' ', em.last_name) AS 'Manager Name' 
FROM departments AS d
JOIN dept_emp AS de ON d.dept_no = de.dept_no
JOIN employees AS e ON de.emp_no = e.emp_no
LEFT JOIN dept_manager AS dm ON de.dept_no = dm.dept_no
LEFT JOIN employees AS em ON dm.emp_no = em.emp_no
WHERE de.to_date > CURDATE() AND dm.to_date > CURDATE();

-- 240,124 Rows
/*
Employee Name | Department Name  |  Manager Name
--------------|------------------|-----------------
 Huan Lortz   | Customer Service | Yuchang Weedman
.....
 */

#12
USE employees;
SELECT m.dname, m.max_salary, em.first_name, em.last_name
-- subquery 'm' with max salaries for each department
FROM (SELECT d.dept_name AS dname,
		d.dept_no AS dno,
        MAX(s.salary) AS max_salary
FROM departments AS d
JOIN dept_emp AS de ON d.dept_no = de.dept_no
JOIN salaries AS s ON de.emp_no = s.emp_no
Left JOIN employees AS e ON de.emp_no = e.emp_no
WHERE de.to_date > CURDATE() AND s.to_date > CURDATE() -- AND s.salary = Max(s.salary)
GROUP BY d.dept_name) AS m

LEFT JOIN salaries s ON m.max_salary = s.salary
LEFT JOIN employees em ON s.emp_no = em.emp_no
LEFT JOIN dept_emp de1 ON  em.emp_no = de1.emp_no AND de1.dept_no = m.dno

WHERE de1.to_date > CURDATE() AND s.to_date > CURDATE();

