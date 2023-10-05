/* Advanced Select. The PADs */
WITH names_concat AS(
    SELECT CONCAT(Name, '(', SUBSTRING(Occupation, 1, 1), ')') AS s
    FROM OCCUPATIONS
    ORDER BY s
),
occup_group AS (
    SELECT Occupation, COUNT(Occupation) AS occ_count
    FROM OCCUPATIONS
    GROUP BY Occupation
    ORDER BY COUNT(Occupation), Occupation
)
SELECT s FROM names_concat
UNION
SELECT CONCAT('There are a total of ', occ_count, ' ', LOWER(Occupation), 's')
FROM occup_group;

/* the code above doesn't pass. SELECT s FROM names_concat 
returns incorrect order. The correct solution is without UNION,
but with 2 SELECT queries */

/* GROUP BY works even when we don't form columns, but concatenate */
SELECT CONCAT(Name, '(', SUBSTRING(Occupation, 1, 1), ')') AS s
FROM OCCUPATIONS
ORDER BY s;
SELECT CONCAT('There are a total of ', COUNT(Occupation), ' ', LOWER(Occupation), 's.')
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(Occupation), Occupation;

/*
New Companies
*/
-- very slow
SELECT c.company_code, c.founder, lm.cnt, sm.cnt, man.cnt, emp.cnt
FROM Company c, 
(SELECT company_code, COUNT(DISTINCT(lead_manager_code)) AS cnt FROM Lead_Manager GROUP BY company_code) lm,
(SELECT company_code, COUNT(DISTINCT(senior_manager_code)) AS cnt FROM Senior_Manager GROUP BY company_code) sm,
(SELECT company_code, COUNT(DISTINCT(manager_code)) AS cnt FROM Manager GROUP BY company_code) man,
(SELECT company_code, COUNT(DISTINCT(employee_code)) AS cnt FROM Employee GROUP BY company_code)emp

WHERE c.company_code = lm.company_code AND
    c.company_code = sm.company_code AND
    c.company_code = man.company_code AND
    c.company_code = emp.company_code
    
ORDER BY c.company_code;

/*
BST - binary search tree
N - number
P - parent
print out a number and "Leaf/Inner/Root"
*/
SELECT DISTINCT N, 
    CASE
        WHEN N IN (SELECT N FROM BST WHERE P IS NULL) THEN 'Root'
        WHEN N IN (SELECT DISTINCT P FROM BST) THEN 'Inner'
        ELSE 'Leaf' END node
FROM BST
ORDER BY N;

/* Triangles */
WITH sums AS (
    SELECT A, B, C, A + B AS sum_ab, A + C AS sum_ac, B + C AS sum_bc,
        CASE 
            WHEN A >= B AND A >= C THEN A
            WHEN B >= A AND B >= C THEN B
            ELSE C END max_value
    FROM TRIANGLES
)
SELECT CASE
    WHEN sum_ab <= max_value OR 
            sum_ac <= max_value OR 
            sum_bc <+ max_value THEN 'Not A Triangle'
    WHEN A = B AND A = C THEN 'Equilateral'
    WHEN (A = B AND A <> C) OR (B = C AND B <> A) OR (A = C AND A <> B) THEN 'Isosceles'
    ELSE 'Scalene'  END tr
    FROM sums;

/* OCCUPATIONS */
WITH partitions AS (
SELECT 
    ROW_NUMBER() OVER (PARTITION BY OCCUPATION ORDER BY NAME) AS R_NUMBER, 
    NAME, 
    OCCUPATION
FROM OCCUPATIONS
)
SELECT MIN(CASE WHEN OCCUPATION = 'Doctor' THEN NAME END),
       MIN(CASE WHEN OCCUPATION = 'Professor' THEN NAME END),
       MIN(CASE WHEN OCCUPATION = 'Singer' THEN NAME END),
       MIN(CASE WHEN OCCUPATION = 'Actor' THEN NAME END)
FROM partitions
GROUP BY R_NUMBER;