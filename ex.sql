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
FROM PC