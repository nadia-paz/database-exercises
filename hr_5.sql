-- Ollivander's Inventory
SELECT id, age, coins_needed, power
FROM
(
    SELECT id, age, coins_needed, power, is_evil, RANK() OVER(PARTITION BY age, power ORDER BY coins_needed) as r 
    FROM Wands w 
    JOIN Wands_Property wp ON w.code = wp.code
    WHERE is_evil = 0
 ) t
 WHERE t.r = 1
 ORDER BY power DESC, age DESC