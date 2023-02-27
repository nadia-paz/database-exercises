/* Name of the product with the max total amount */
SELECT a.name
FROM (SELECT name, (price * quantity) as total
    from Products
) a
WHERE a.total = (select max(price * quantity) from Products)
ORDER by name
LIMIT 1;

/*the names of the participants who took the 4th to 8th places inclusive*/
SELECT name
FROM leaderboard
ORDER BY score DESC
LIMIT 5 OFFSET 3; /*start from 4rth (after 3) and show 5 */

/* query the name and id of all the students whose best grade comes from Option 3, 
sorted based on the first 3 characters of their name. 
If the first 3 characters of two names are the same, then the student with the lower ID value comes first.
option 3 = Final, other options are in where conditions */
SELECT Name, ID
FROM Grades
WHERE Final > (Midterm1*0.25 + Midterm2*0.25 + Final*0.5) AND Final > (Midterm1*0.5 + 			Midterm2*0.5)
ORDER BY SUBSTRING(Name, 1, 3), ID;

/*
- Monday set to 0
- Custom order with CASE
*/
SELECT (DAYOFWEEK(date1) +5) % 7 as weekday, date1, author, title
FROM mischief
ORDER BY weekday, 
    CASE
    WHEN author = 'Author3' THEN 1
    WHEN author = 'Author1' THEN 2
    WHEN author = 'Author2' THEN 3
    END,
    date1, title;


SELECT id, name, surname
FROM Suspect
WHERE LOWER(name) LIKE 'b%' 
AND LENGTH(surname) = 5
AND LOWER(surname) LIKE ('gre%n')
AND height <= 170;

/*
_ one characher
_% one or more
% zero or more
binary -> case sensitive
*/
SELECT *
FROM users
WHERE attribute LIKE CONCAT('_%\%', binary first_name, '_', binary second_name, '\%%')
ORDER BY attribute;

/* IF statement in SELECT, almost as np.where */
SELECT id, 
    IF (ISNULL(given_answer), 'no answer', 
    IF (given_answer = correct_answer, 'correct', 'incorrect') ) AS checks
FROM answers
ORDER BY id;

/* CASE WHEN in WHERE clause */
SELECT id, a, b, operation, c
FROM expressions
WHERE c = (
        CASE operation
            WHEN '+' THEN a + b
            WHEN '-' THEN a - b
            WHEN '*' THEN a * b
            WHEN '/' THEN a / nullif(b, 0)
        END) 
ORDER BY id;

/* UNION returns DISTINCT values */
SELECT subscriber FROM full_year WHERE newspaper LIKE '%Daily%' 
UNION
SELECT subscriber FROM HALF_year WHERE newspaper LIKE '%Daily%'
ORDER BY subscriber;

/* save unique countries from the column into the list, separate with ';' */
SELECT GROUP_CONCAT(DISTINCT country ORDER BY country SEPARATOR ';') AS coutries
FROM diary;

/* GROUP concatanation */
SELECT GROUP_CONCAT(first_name, ' ', surname, ' #', player_number
            ORDER BY player_number
            SEPARATOR '; ') as players
FROM soccer_team;

/* Without LIMIT the sorting doesn't work */
(SELECT country, COUNT(*) AS competitors
FROM foreignCompetitors
GROUP BY country
ORDER BY country ASC
LIMIT 1000000)
UNION 
SELECT 'Total:', count(*)  FROM foreignCompetitors;

/* count legs */
SELECT SUM(CASE type WHEN  'human' THEN 2 ELSE 4 END) as summary_legs
FROM creatures
ORDER BY id;
/*
count all possible combinations
calculate the lenght of the word and multiply the length of all words in the column
use the rule log(x) + log(y) = log(xy) to multiply
 */
SELECT round(exp(sum(log(length(characters)))),0) as combinations
from discs;

/*  Translate bytes into Kb and Mb*/
SELECT id, email_title, 
    CASE
        WHEN size < POWER(2, 20) THEN CONCAT(FLOOR(size / POWER(2, 10)), ' Kb')
        ELSE CONCAT(FLOOR(size / POWER(2, 20)), ' Mb')
        END AS short_size
FROM emails
ORDER BY size DESC;