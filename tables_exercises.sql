USE employees;

# 3. List all the tables in the database
SHOW TABLES;

# 5. Explore the employees table. What different data types are present on this table?
DESCRIBE employees; #int, date, varchar, enum

# 6. Which table(s) do you think contain a numeric type column? 
# All of them except the table "departments"

# 7. Which table(s) do you think contain a string type column?
# All tables except "salaries"

# 8. Which table(s) do you think contain a date type column?
# All tables except "departments"

# 9. What is the relationship between the employees and the departments tables?
# There is no direct relationship between these 2 tables, meanwhile
# there is a column "emp_no" in the table "employees" and the column "dept_no"
# in the table "departments". Both these columns intersect in the table "dept_emp".alter

# 10. Show the SQL that created the dept_manager table. 
# Write the SQL it takes to show this as your exercise solution.

SHOW CREATE TABLE dept_manager; 

/*
CREATE TABLE dept_manager (
	emp_no int NOT NULL,
	dept_no char(4) NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    PRIMARY KEY (emp_no, dept_no),
    KEY dept_no (dept_no),
    CONSTRAINT dept_manager_ibfk_1 FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT dept_manager_ibfk_2 FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE ON UPDATE RESTRICT)
    ENGINE=InnoDB DEFAULT CHARSET=latin1
;
*/