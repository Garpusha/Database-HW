--Количество исполнителей в каждом жанре.
SELECT g.name, count(*) FROM genre g 
JOIN genre_musician gm ON g.genre_id = gm.genre_id 
GROUP BY g.name 
ORDER BY count(*) DESC;

--Количество треков, вошедших в альбомы 2019–2020 годов.
SELECT count(*) FROM album a 
JOIN track t ON a.album_id = t.album_id
WHERE a.year BETWEEN 2019 AND 2020;

--Средняя продолжительность треков по каждому альбому.
SELECT a.name, round(avg(t.length), 2) FROM album a 
JOIN track t ON a.album_id = t.album_id
GROUP BY a.name;

--Все исполнители, которые не выпустили альбомы в 2020 году.
SELECT m.name FROM musician m
WHERE m.name <> (SELECT m.name FROM musician m 
JOIN musician_album ma ON m.musician_id = ma.musician_id
JOIN album a ON ma.album_id = a.album_id
WHERE a.year = 2020 
GROUP BY m.name);

--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
SELECT DISTINCT c.name FROM collection c 
JOIN collection_track ct ON c.collection_id = ct.collection_id 
JOIN track t ON ct.track_id = t.track_id 
JOIN musician_album ma ON t.album_id = ma.album_id
JOIN musician m ON ma.musician_id = m.musician_id 
WHERE m.name = 'Анна Пингина'

--Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
SELECT DISTINCT a.name FROM album a 
JOIN musician_album ma ON a.album_id = ma.album_id
JOIN musician m ON ma.musician_id = m.musician_id
JOIN genre_musician gm ON m.musician_id = gm.musician_id
GROUP BY a.name, gm.musician_id
HAVING count(genre_id) > 1;

--Наименования треков, которые не входят в сборники.
SELECT t.name FROM track t
LEFT JOIN collection_track ct ON t.track_id = ct.track_id
WHERE ct.track_id IS NULL;

--Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
SELECT DISTINCT m.name FROM musician m 
JOIN musician_album ma ON m.musician_id = ma.musician_id 
JOIN track t ON ma.album_id = t.album_id 
WHERE t.length = (SELECT min(t.length) FROM track t);

--Названия альбомов, содержащих наименьшее количество треков.
SELECT a.name FROM album a
JOIN track t ON t.album_id = a.album_id
GROUP BY a.name
HAVING COUNT(t.track_id) = (
	SELECT COUNT(t.track_id) FROM track t
	JOIN album a ON a.album_id = t.album_id
	GROUP BY a.name
	ORDER BY COUNT(t.track_id)
	LIMIT 1);