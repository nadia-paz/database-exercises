/*
-- The Blunder --

Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, 
but did not realize her keyboard's 0 key was broken until after completing the calculation. 
She wants your help finding the difference between her miscalculation 
(using salaries with any zeros removed), and the actual average salary.

Write a query calculating the amount of error (i.e.:  average monthly salaries),
 and round it up to the next integer.
*/

SELECT CEILING(AVG(Salary) - AVG(CAST(REPLACE(CONVERT(Salary, CHAR), '0', '') AS DECIMAL)))
FROM EMPLOYEES;

--
SELECT COUNT(NAME) AS CITY_CNT
FROM CITY
WHERE POPULATION > 100000;

--
SELECT SUM(POPULATION)
FROM CITY
WHERE DISTRICT = 'California';

/* Top Earners
find ppl who earned max amount
*/
WITH temp AS
(
SELECT months * salary AS totals
FROM Employee
WHERE months * salary = (SELECT MAX(months * salary) FROM Employee)
)
SELECT totals, COUNT(totals) FROM temp GROUP BY totals;

--
SELECT ROUND(SUM(LAT_N), 2) AS lat, ROUND(SUM(LONG_W), 2) AS lon
FROM STATION

--
-- TRUNCATE works only in MySQL
SELECT TRUNCATE(SUM(LAT_N), 4)
FROM STATION
WHERE LAT_N > 38.7880 AND LAT_N < 137.2345;

-- WOS 15
/*
Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION 
that is less than 37.2345. Round your answer to 4 decimal places.
*/
SELECT ROUND(LONG_W, 4)
FROM STATION
WHERE LAT_N = (SELECT MAX(LAT_N) FROM STATION WHERE LAT_N < 137.2345);

-- WOS 18
/*
Consider P1(a, b) and P2(c, d) to be two points on a 2D plane.

a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
Query the Manhattan Distance between points  and  and round it to a scale of  decimal places.
*/

WITH sides AS (
    SELECT MIN(LAT_N) AS a, MIN(LONG_W) AS b, MAX(LAT_N) AS c, MAX(LONG_W) AS d
    FROM STATION
)
SELECT ROUND((ABS(a - c) + ABS(b - d)), 4)
FROM sides;

-- WOS 19
/*
Consider P1(a, c) and P2(b,d) to be two points on a 2D plane where (a, b) are the respective minimum and maximum values 
of Northern Latitude (LAT_N) and (c, d) are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.

Query the Euclidean Distance between points  and  and format your answer to display  decimal digits.
*/
-- POWER instead of POW for Oracle
WITH sides AS (
    SELECT MIN(LAT_N) AS a, MIN(LONG_W) AS b, MAX(LAT_N) AS c, MAX(LONG_W) AS d
    FROM STATION
)
SELECT ROUND( SQRT( POW((a-c), 2) + POW((b-d), 2) ), 4)
FROM sides;

-- WOS 20
/* find median of LAT_N */

/*
Query the median of the Northern Latitudes (LAT_N) from 
STATION and round your answer to  decimal places.
*/

-- for Oracle:
SELECT ROUND(MEDIAN(LAT_N),4)
FROM STATION;

-- FOR MySQL (it will fail in case of even count)
SET @med = (
SELECT CEILING(COUNT(*) / 2) FROM STATION
);
WITH temp AS(
SELECT LAT_N, ROW_NUMBER() OVER(ORDER BY LAT_N) AS rn FROM STATION
)
SELECT ROUND(LAT_N, 4)
FROM temp
WHERE rn = @med;

-- works with even count
-- check the remainder 1 means odd, 0 - even
SET @evenodd = (
SELECT MOD(COUNT(*), 2)
);
-- select medium count
SET @med = (
SELECT CEILING(COUNT(*) / 2) FROM STATION
);
-- temp table with window function
WITH temp AS(
SELECT LAT_N, ROW_NUMBER() OVER(ORDER BY LAT_N) AS rn FROM STATION
)
SELECT 
    CASE @evenodd WHEN 1 THEN (SELECT ROUND(LAT_N, 4) FROM temp WHERE rn = @med) 
    ELSE ROUND((
    (SELECT LAT_N FROM temp WHERE rn = @med) +
    (SELECT LAT_N FROM temp WHERE rn = (@med+1))
    ) / 2 , 2)
    END;