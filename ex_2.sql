/*
35. В таблице Product найти модели, которые состоят 
только из цифр или только из латинских букв 
(A-Z, без учета регистра).
Вывод: номер модели, тип модели.
*/

SELECT model, type
FROM Product
WHERE UPPER(model) not LIKE "%[^A-Za-z]%" 
OR model not LIKE "%[^0-9]%";

/*
36. Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).
*/
SELECT c.class FROM Ships s
JOIN Classes c USING(class)
WHERE c.class = s.name
UNION
SELECT c.class FROM Outcomes o
JOIN Classes c ON o.ship = c.class;

/*
37. Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
*/
WITH temp_ships AS (
    SELECT c.class, s.name
    FROM Classes c 
    JOIN Ships s USING(class)
    UNION
    SELECT c.class, o.ship
    FROM Classes c
    JOIN Outcomes o ON c.class = o.ship
)
SELECT class
FROM temp_ships
GROUP BY class
HAVING COUNT(name) = 1;

/*
38. Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') 
и имевшие когда-либо классы крейсеров ('bc').
*/
SELECT country
FROM Classes c
WHERE type = "bb"

INTERSECT

SELECT country
FROM Classes c
WHERE type = "bc";

/*
39. Найдите корабли, `сохранившиеся для будущих сражений`; 
т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, произошедшей позже.
*/
WITH temp_battles AS (
    SELECT ship, result, date FROM Outcomes o
    JOIN Battles b ON o.battle = b.name
)
SELECT DISTINCT ship FROM temp_battles tb1
WHERE result = "damaged" AND ship IN (
SELECT ship FROM temp_battles tb2
WHERE tb1.date < tb2.date
)

select distinct ship from outcomes o join battles s on battle=name
where result = 'damaged' and
exists (select ship from outcomes join battles on battle=name where ship=o.ship and s.date<date)

/*
40. Найти производителей, которые выпускают более одной модели, при этом 
все выпускаемые производителем модели являются продуктами одного типа.
Вывести: maker, type
*/
SELECT maker, type
FROM Product
GROUP BY maker
HAVING COUNT(model) > 1 AND COUNT(DISTINCT type) = 1

/*
41. Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц 
PC, Laptop или Printer, определить максимальную цену на его продукцию.
Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL, 
то выводить для этого производителя NULL, иначе максимальную цену.
NOTE: Failed with LEFT JOIN even the logic is correct with the LEFT JOIN
*/
WITH temp AS (
    SELECT p.maker, p.model, l.price FROM Product p LEFT JOIN laptop l USING(model) WHERE p.type = "laptop"
    UNION
    SELECT p.maker, p.model, PC.price FROM Product p LEFT JOIN PC USING(model) WHERE p.type = "PC"
    UNION 
    SELECT p.maker, p.model, pr.price FROM Product p LEFT JOIN Printer pr USING(model) WHERE p.type = "printer"
)
SELECT DISTINCT maker, CASE 
WHEN maker IN (SELECT maker FROM temp WHERE price IS NULL)
THEN NULL
ELSE MAX(price)
END price
FROM temp GROUP BY maker
-------------------
WITH temp AS (
    SELECT  p.maker, p.model, l.price FROM Product p JOIN laptop l USING(model)
    UNION
    SELECT  p.maker, p.model, PC.price FROM Product p JOIN PC USING(model)
    UNION 
    SELECT  p.maker, p.model, pr.price FROM Product p JOIN Printer pr USING(model)
)

SELECT DISTINCT maker, CASE 
WHEN maker IN (SELECT maker FROM temp WHERE price IS NULL) THEN NULL ELSE MAX(price) END price
FROM temp GROUP BY maker

/* 
42.
*/
SELECT ship, battle FROM Outcomes 
WHERE result = "sunk"

/*
43
*/

