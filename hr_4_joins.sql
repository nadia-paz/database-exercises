-- Population Cencus
SELECT SUM(C.POPULATION)
FROM CITY C
JOIN COUNTRY CN ON C.COUNTRYCODE = CN.CODE
WHERE CONTINENT = 'Asia';

-- African Cities
SELECT C.NAME
FROM CITY C
JOIN COUNTRY CN ON C.COUNTRYCODE = CN.CODE
WHERE CONTINENT = 'Africa';

-- AVG population of each continent

/*
query the names of all the continents (COUNTRY.Continent) 
and their respective average city populations (CITY.Population) 
rounded down to the nearest integer.
*/

SELECT CN.CONTINENT, FLOOR(AVG(C.POPULATION))
FROM CITY C
JOIN COUNTRY CN ON C.COUNTRYCODE = CN.CODE
GROUP BY (CN.CONTINENT);

-- The Report
/*
Ketty gives Eve a task to generate a report containing three columns: 
Name, Grade and Mark. Ketty doesn't want the NAMES of those students 
who received a grade lower than 8. The report must be in descending order by grade -- 
i.e. higher grades are entered first. 
If there is more than one student with the same grade (8-10) assigned to them, 
order those particular students by their name alphabetically. 
Finally, if the grade is lower than 8, use "NULL" as their name and list them by 
their grades in descending order. 
If there is more than one student with the same grade (1-7) assigned to them, 
order those particular students by their marks in ascending order.
*/

SELECT CASE 
    WHEN g.grade >= 8 THEN s.Name ELSE NULL END AS name,
    g.Grade, s.Marks
FROM Students s
JOIN Grades g ON s.Marks BETWEEN g.Min_Mark AND g.Max_Mark
ORDER BY g.Grade DESC, s.Name ASC;

-- Top Competitors
/*
Write a query to print the respective hacker_id and name of hackers 
who achieved full scores for more than one challenge. 
Order your output in descending order by the total number of challenges 
in which the hacker earned a full score. If more than one hacker 
received full scores in same number of challenges, then sort them by ascending hacker_id.
*/
SELECT h.hacker_id, h.name
FROM Submissions AS s
JOIN Hackers AS h ON s.hacker_id = h.hacker_id
JOIN Challenges AS c ON c.challenge_id = s.challenge_id
JOIN Difficulty AS d ON d.difficulty_level = c.difficulty_level
WHERE d.score = s.score
GROUP BY h.hacker_id, h.name
HAVING COUNT(s.challenge_id) > 1
ORDER BY COUNT(s.challenge_id) DESC, hacker_id;

-- Symmetric Pairs
SELECT fa.X, fa.Y
FROM Functions fa
JOIN Functions fb ON fa.X = fb.Y AND fb.X = fa.Y
WHERE fa.X <= fa.Y
GROUP BY fa.X, fa.Y
HAVING COUNT(*) > 1 or fa.X <> fa.Y
ORDER By fa.X;

