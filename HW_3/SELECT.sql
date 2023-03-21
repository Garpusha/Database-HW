SELECT name, year FROM album
WHERE YEAR = 2018;

SELECT name, length FROM track
WHERE length = (SELECT max(length) FROM track);

SELECT name, length FROM track
WHERE length > 210; 

SELECT name, year FROM collection
WHERE YEAR >= 2018 AND YEAR <= 2020;

SELECT name FROM musician
WHERE name NOT LIKE '% %';

SELECT name FROM track
WHERE name ILIKE '%my%';