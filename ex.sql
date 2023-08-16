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
