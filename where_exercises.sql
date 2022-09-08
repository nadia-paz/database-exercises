# 1
USE employees;

# 2. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya' using IN. 
#Enter a comment with the number of records returned.

SELECT first_name, last_name
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya');
# 709 rows

# 3. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', as in Q2, but use OR instead of IN. 
# Enter a comment with the number of records returned. Does it match number of rows from Q2?

USE employees;

SELECT first_name, last_name
FROM employees
WHERE first_name = 'Irena' 
	OR first_name = 'Vidya'
	OR first_name = 'Maya';

# 709 rows

# 4. Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', using OR, and who is male. 
#Enter a comment with the number of records returned.


SELECT first_name, last_name, gender
FROM employees
WHERE (first_name = 'Irena' AND gender = 'M')
	OR (first_name = 'Vidya' AND gender = 'M')
	OR (first_name = 'Maya' AND gender = 'M');

# 441 rows

# 5. Find all current or previous employees whose last name starts with 'E'. Enter a comment with the number of employees whose last name starts with E.

SELECT first_name, last_name
FROM employees
WHERE last_name LIKE 'E%';
# 7330 rows

# 6. Find all current or previous employees whose last name starts or ends with 'E'.
# Enter a comment with the number of employees whose last name starts or ends with E. How many employees have a last name that ends with E, but does not start with E?

SELECT first_name, last_name
FROM employees
WHERE last_name LIKE 'E%' 
	OR last_name LIKE '%e';

# 30723 rows

# 7. Find all current or previous employees employees whose last name starts and ends with 'E'.
# Enter a comment with the number of employees whose last name starts and ends with E. How many employeeS last names end with E, regardless of whether they start with E?

SELECT first_name, last_name
FROM employees
WHERE last_name LIKE 'E%' 
	AND last_name LIKE '%e';

# 899 rows

# 8. Find all current or previous employees hired in the 90s. Enter a comment with the number of employees returned.

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1999-12-31';

# 135214 rows

# 9. Find all current or previous employees born on Christmas. Enter a comment with the number of employees returned.

SELECT first_name, last_name, birth_date
FROM employees
WHERE birth_date LIKE '%12-25';

# 842 rows

# 10. Find all current or previous employees hired in the 90s and born on Christmas. Enter a comment with the number of employees returned.

SELECT first_name, last_name, birth_date, hire_date
FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1999-12-31'
	AND birth_date LIKE '%12-25';

# 362 rows

# 11. Find all current or previous employees with a 'q' in their last name. Enter a comment with the number of records returned.

SELECT last_name
FROM employees
WHERE last_name LIKE '%q%';

# 1873 rows

# 12. Find all current or previous employees with a 'q' in their last name but not 'qu'. How many employees are found?

SELECT last_name
FROM employees
WHERE last_name LIKE '%q%' AND last_name NOT LIKE '%qu%';

# 547 rows