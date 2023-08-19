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

