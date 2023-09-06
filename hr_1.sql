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

/* Weather Observation Station 4 */
SELECT COUNT(*) - COUNT(DISTINCT CITY)
FROM STATION;

/* Weather Observation Station 5 */
WITH city_min AS (
    SELECT CITY
    FROM STATION
    WHERE LENGTH(CITY) = (SELECT MIN(LENGTH(CITY)) FROM STATION)
    ORDER BY CITY 
    LIMIT 1
),
city_max AS (
    SELECT CITY
    FROM STATION
    WHERE LENGTH(CITY) = (SELECT MAX(LENGTH(CITY)) FROM STATION)
)
SELECT CITY, LENGTH(CITY) FROM city_min
UNION
SELECT CITY, LENGTH(CITY) FROM city_max;


/* Weather Observation Station 6 */
SELECT DISTINCT CITY
FROM STATION 
WHERE UPPER(CITY) LIKE 'A%' OR 
    UPPER(CITY) LIKE 'E%' OR 
    UPPER(CITY) LIKE 'I%' OR 
    UPPER(CITY) LIKE 'O%' OR 
    UPPER(CITY) LIKE 'U%';

/* WOS 7
Query the list of CITY names ending with vowels (a, e, i, o, u) 
from STATION. Your result cannot contain duplicates.
*/
SELECT DISTINCT CITY
FROM STATION
WHERE RIGHT(LOWER(CITY), 1) IN (
    'a', 'e', 'i', 'o', 'u'
);

/* WOS 8
Last and first letters are vowels
*/
SELECT DISTINCT CITY
FROM STATION
WHERE RIGHT(LOWER(CITY), 1) IN (
    'a', 'e', 'i', 'o', 'u'
)
AND LEFT(LOWER(CITY), 1) IN (
    'a', 'e', 'i', 'o', 'u'
);

/* WOS 9 
Doesn't start with vowel
*/
SELECT DISTINCT CITY
FROM STATION
WHERE LEFT(LOWER(CITY), 1) NOT IN (
    'a', 'e', 'i', 'o', 'u'
);

/* WOS 10 
Doesn't end with vowel
*/
SELECT DISTINCT CITY
FROM STATION
WHERE RIGHT(LOWER(CITY), 1) NOT IN (
    'a', 'e', 'i', 'o', 'u'
);

/*
Query the Name of any student in STUDENTS who scored higher than  Marks. 
Order your output by the last three characters of each name. 
If two or more students both have names ending in the same last three characters 
(i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
*/
SELECT Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(NAME, 3), ID;