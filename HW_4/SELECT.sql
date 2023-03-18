--���������� ������������ � ������ �����.
SELECT g.name, count(*) FROM genre g 
JOIN genre_musician gm ON g.genre_id = gm.genre_id 
GROUP BY g.name 
ORDER BY count(*) DESC;

--���������� ������, �������� � ������� 2019�2020 �����.
SELECT a.name, count(*) FROM album a 
JOIN track t ON a.album_id = t.album_id
WHERE a.year >= 2019 AND a.YEAR <= 2020
GROUP BY a.name
ORDER BY count(*) DESC;

--������� ����������������� ������ �� ������� �������.
SELECT a.name, round(avg(t.length), 2) FROM album a 
JOIN track t ON a.album_id = t.album_id
GROUP BY a.name;

--��� �����������, ������� �� ��������� ������� � 2020 ����.
SELECT m.name FROM musician m
WHERE m.name <> (SELECT m.name FROM musician m 
JOIN musician_album ma ON m.musician_id = ma.musician_id
JOIN album a ON ma.album_id = a.album_id
WHERE a.year = 2020 
GROUP BY m.name);

--�������� ���������, � ������� ������������ ���������� ����������� (�������� ��� ����).
SELECT c.name FROM collection c 
JOIN collection_track ct ON c.collection_id = ct.collection_id 
JOIN track t ON ct.track_id = t.track_id 
JOIN musician_album ma ON t.album_id = ma.album_id
JOIN musician m ON ma.musician_id = m.musician_id 
WHERE m.name = 'Nickelback'

--�������� ��������, � ������� ������������ ����������� ����� ��� ������ �����.
SELECT DISTINCT a.name FROM album a 
JOIN musician_album ma ON a.album_id = ma.album_id 
WHERE ma.musician_id IN (SELECT gm.musician_id FROM genre_musician gm 
GROUP BY gm.musician_id
HAVING count(*) > 1);

--������������ ������, ������� �� ������ � ��������.
SELECT t.name FROM track t 
WHERE t.track_id NOT IN (SELECT ct.track_id FROM collection_track ct);

--����������� ��� �����������, ���������� ����� �������� �� ����������������� ����, � ������������ ����� ������ ����� ���� ���������.
SELECT DISTINCT m.name FROM musician m 
JOIN musician_album ma ON m.musician_id = ma.musician_id 
JOIN track t ON ma.album_id = t.album_id 
WHERE t.length = (SELECT min(t.length) FROM track t);

--�������� ��������, ���������� ���������� ���������� ������.
SELECT a.name FROM album a 
WHERE a.album_id IN (SELECT album_id FROM 
(SELECT t.album_id, count(t.album_id) FROM track t 
GROUP BY t.album_id) AS test
WHERE count = (SELECT min(count) from (SELECT t.album_id, count(t.album_id) FROM track t 
GROUP BY t.album_id) AS z));