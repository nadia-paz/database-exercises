-- Write a query that returns all employee names 
-- (previous and current), and a
-- new column 'alpha_group' that returns 'A-H', 'I-Q', or 'R-Z' 
-- depending on the
-- first letter of their last name.


SELECT first_name, last_name, CASE
		WHEN SUBSTR(last_name, 1, 1) between 'A' and 'H'  THEN 'A-H'
        WHEN SUBSTR(last_name, 1, 1) BETWEEN 'I' AND 'Q' THEN 'I-Q'
		ELSE 'R-Z' END AS alpha_group
        FROM employees;

SELECT first_name, last_name, CASE
		WHEN LEFT(last_name, 1) <= 'H' THEN 'A-H'
        WHEN LEFT(last_name, 1) <= 'Q' THEN 'I-Q'
        ELSE 'R-Z' END AS alpha_group
FROM employees;