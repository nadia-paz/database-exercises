/* 
The database scheme consists of four tables:
Product(maker - varchar10, model-varchar50, type-varchar50)
PC(code - int, model - varchar50, speed-smallint, ram-smallint, hd-real, cd-varchar10, price-currency)
Laptop(code, model, speed, ram, hd, screen-tinyint, price)
Printer(code, model, color-char1, type-varchar10, price)

The Product table contains data on the maker, model number, and type of product ('PC', 'Laptop', or 'Printer'). 
It is assumed that model numbers in the Product table are unique for all makers and product types. 
Each personal computer in the PC table is unambiguously identified by a unique code, and is additionally 
characterized by its model (foreign key referring to the Product table), processor speed (in MHz) – 
speed field, RAM capacity (in Mb) - ram, hard disk drive capacity (in Gb) – hd, 
CD-ROM speed (e.g, '4x') - cd, and its price. 
The Laptop table is similar to the PC table, except that instead of the CD-ROM speed, 
it contains the screen size (in inches) – screen. 
For each printer model in the Printer table, its output type (‘y’ for color and ‘n’ for monochrome)
 – color field, printing technology ('Laser', 'Jet', or 'Matrix') – type, and price are specified.

 SHIPS:
Classes(class -varchar50, type-varchar2, country-varchar20, numGuns-tinyint, bore-real, displacement-int)
Ships(name-varchar50, class-varchar50, launched-smallint)
Battles(name-varchar20, date-datetime)
Outcomes(ship-vc50, battle-vc20, result-vc10)

Ships in classes all have the same general design. 
A class is normally assigned either the name of the first ship built according to 
the corresponding design, or a name that is different from any ship name in the database. 
The ship whose name is assigned to a class is called a lead ship.
The Classes relation includes the name of the class, 
type (can be either bb for a battle ship, or bc for a battle cruiser), 
country the ship was built in, 
the number of main guns, 
gun caliber (bore diameter in inches), 
and displacement (weight in tons). 
The Ships relation holds information about the ship name, the name of its corresponding class, 
and the year the ship was launched. T
he Battles relation contains names and dates of battles the ships participated in, 
and the Outcomes relation - the battle result for a given ship (may be sunk, damaged, or OK, 
the last value meaning the ship survived the battle unharmed).
Notes: 
1) The Outcomes relation may contain ships not present in the Ships relation. 
2) A ship sunk can’t participate in later battles. 
3) For historical reasons, lead ships are referred to as head ships in many exercises.
4) A ship found in the Outcomes table but not in the Ships table is still considered in the database. 
This is true even if it is sunk.

Recycling firm

Income (code-int, point - tinyint, date - datetime, inc - smallmoney) PK = code
Outcome (code-int, point - tinyint, date - datetime, out - smallmoney) PK = code
Income_o (point, date, inc) PK = (point, date)
Outcome_0 (point, date, out) PK = (point, date)

The firm owns several buy-back centers for collection of recyclable materials. 
Each of them receives funds to be paid to the recyclables suppliers. 
Data on funds received is recorded in the table Income_o(point, date, inc)
The primary key is (point, date), where point holds the identifier of the buy-back center, 
and date corresponds to the calendar date the funds were received. 
The date column doesn’t include the time part, thus, money (inc) arrives no more than once a day for each center. 
Information on payments to the recyclables suppliers is held in the table Outcome_o(point, date, out)
In this table, the primary key (point, date) ensures each buy-back center reports about payments (out) no more than once a day, too.
For the case income and expenditure may occur more than once a day, 
another database schema with tables having a primary key consisting of the single column code is used:
Income(code, point, date, inc)
Outcome(code, point, date, out)
Here, the date column doesn’t include the time part, either.
*/

/* 
9. Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.
*/
SELECT DISTINCT maker
FROM Product P 
JOIN PC USING(model) 
WHERE PC.speed >= 450;

/*
10. Find the printer models having the highest price. Result set: model, price.
*/

SELECT model, price
FROM Printer
WHERE price IN (SELECT MAX(price) FROM Printer);

/*
11. Find out the average speed of PCs.
*/
SELECT AVG(speed)
FROM PC;

/*
12. Find out the average speed of the laptops priced over $1000.
*/
SELECT AVG(speed)
FROM Laptop
WHERE price > 1000;

/*
13. Find out the average speed of the PCs produced by maker A.
*/
SELECT AVG(speed)
FROM PC
JOIN Product p USING(model)
WHERE p.maker = 'A';

/*
14. For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
*/
SELECT sh.class, sh.name, cl.country
FROM Ships sh
JOIN Classes cl USING(class)
WHERE cl.numGuns >= 10;

/*
15. Get hard drive capacities that are identical for two or more PCs.
Result set: hd.
*/
-- PGSQL
WITH hd_table AS
(
SELECT hd, COUNT(hd)
FROM PC
GROUP BY hd
HAVING COUNT(hd) >= 2
)
SELECT hd
FROM hd_table;
-- MYSQL
SELECT hd
FROM (
    SELECT hd, COUNT(hd)
    FROM PC
    GROUP BY hd
    HAVING COUNT(hd) >=2
) any_name;

/* solution with WHERE EXISTS */
SELECT DISTINCT pc1.hd
FROM PC pc1
WHERE EXISTS (
    SELECT *
    FROM PC pc2
    WHERE pc1.hd = pc2.hs AND pc1.model <> pc2.model
);

/*
16. Get pairs of PC models with identical speeds and the same RAM capacity. 
Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
Result set: model with the bigger number, model with the smaller number, speed, and RAM.
*/
SELECT DISTINCT pca.model, pcb.model, pca.speed, pcb.ram
FROM PC, PC AS pca, PC AS pcb
WHERE pca.speed = pcb.speed 
    AND pca.ram = pcb.ram 
    AND pca.model > pcb.model;

/* site solution */
SELECT MAX(model) AS 'model', MIN(model) AS 'model', speed, ram
FROM PC
GROUP BY speed, ram
HAVING MAX(model) > MIN(model);

/*
17. Get the laptop models that have a speed smaller than the speed of any PC.
Result set: type, model, speed.
*/

SELECT DISTINCT pr.type, l.model, l.speed
FROM Laptop l 
JOIN product pr USING(model)
WHERE l.speed < ALL(SELECT speed FROM PC); 

/*
18. Find the makers of the cheapest color printers.
Result set: maker, price.
*/
SELECT DISTINCT prod.maker, prin.price
FROM Printer prin
JOIN Product prod  USING(model)
WHERE prin.price = (SELECT MIN(price) FROM Printer WHERE color = 'y') AND prin.color='y';

/*
19. For each maker having models in the Laptop table, 
find out the average screen size of the laptops he produces.
Result set: maker, average screen size.
*/
SELECT p.maker, AVG(l.screen)
FROM Product p 
JOIN Laptop l USING(model)
GROUP BY maker;

/*
20. Find the makers producing at least three distinct models of PCs.
Result set: maker, number of PC models.
*/
SELECT maker, COUNT(model)
FROM Product
WHERE type = 'PC'
GROUP BY maker
HAVING COUNT(model) >= 3;

/*
21. Find out the maximum PC price for each maker having models in the PC table. 
Result set: maker, maximum price.
*/
SELECT maker, MAX(price)
FROM Product
JOIN PC USING(model)
GROUP BY maker;

/*
22. Для каждого значения скорости ПК, превышающего 600 МГц, 
определите среднюю цену ПК с такой же скоростью. 
Вывести: speed, средняя цена.
*/
SELECT speed, AVG(price)
FROM PC
WHERE speed > 600
GROUP BY speed;

/*
23. Найдите производителей, которые производили бы как ПК
со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker
*/
SELECT maker
FROM Product
JOIN PC USING(model)  
WHERE PC.speed >= 750
INTERSECT
SELECT maker
FROM Product
JOIN Laptop l USING(model)
WHERE l.speed >= 750;

/*
24. Перечислите номера моделей любых типов, 
имеющих самую высокую цену по всей имеющейся в базе данных продукции.
*/
WITH un_table AS
(
    SELECT model, price FROM PC WHERE price = (SELECT MAX(price) FROM PC)
    UNION
    SELECT model, price FROM Laptop WHERE price = (SELECT MAX(price) FROM Laptop)
    UNION
    SELECT model, price FROM Printer WHERE price = (SELECT MAX(price) FROM Printer)
)
SELECT model
FROM un_table
WHERE price = (SELECT MAX(price) FROM un_table);

/*
25. Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM 
и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. 
Вывести: Maker
*/
WITH min_ram AS (
    SELECT model, speed, ram
    FROM PC
    WHERE ram = (SELECT MIN(ram) FROM PC)
)
SELECT DISTINCT maker
FROM Product p 
JOIN min_ram mr USING(model)
WHERE p.maker IN (
    SELECT maker
    FROM Product
    WHERE type = 'Printer'
) AND mr.speed = (
    SELECT MAX(speed) FROM min_ram
); /* didn't pass an additional test -- upd. workd with DISTINCT */

/*
26. Find out the average price of PCs and laptops produced by maker A.
Result set: one overall average price for all items.
*/
WITH u_table AS (
    SELECT model, price
    FROM PC
    UNION ALL
    SELECT model, price
    FROM Laptop
)
SELECT AVG(price)
FROM u_table
JOIN Product p USING(model)
WHERE p.maker = 'A';

/* 2nd solution */
SELECT AVG(price)
FROM (
    SELECT model, maker, price
    FROM Product 
    JOIN PC USING(model)
    UNION ALL
    SELECT model, maker, price
    FROM Product 
    JOIN Laptop USING(model)
) a
WHERE maker='A';

/*
27. Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
Result set: maker, average HDD capacity.
*/
/* with IN you have to use a subquery!!! not WITH table AS!!!*/

SELECT p.maker, AVG(PC.hd)
FROM Product p 
JOIN PC USING(model)
WHERE p.maker IN (
    SELECT maker
    FROM Product
    WHERE type = 'Printer'
)
GROUP BY p.maker;

/*
28. Using Product table, find out the number of makers who produce only one model.
*/
WITH count_table AS(
    SELECT maker, COUNT(model) AS mdl
    FROM Product
    GROUP BY maker
)
SELECT COUNT(*)
FROM count_table
WHERE mdl = 1;