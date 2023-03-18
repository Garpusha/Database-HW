SELECT g.name, count(*) FROM genre g 
JOIN genre_musician gm ON g.genre_id = gm.genre_id 
GROUP BY g.name 
ORDER BY count(*) DESC;