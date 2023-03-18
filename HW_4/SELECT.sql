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