COPY album FROM 'C:\HW_DB\HW_3\albums.csv' DELIMITER ';' CSV;
COPY musician FROM 'C:\HW_DB\HW_3\bands.csv' DELIMITER ';' CSV;
COPY genre FROM 'C:\HW_DB\HW_3\genres.csv' DELIMITER ';' CSV;
COPY track FROM 'C:\HW_DB\HW_3\tracks.csv' DELIMITER ';' CSV;
COPY collection FROM 'C:\HW_DB\HW_3\collections.csv' DELIMITER ';' CSV;
COPY collection_track FROM 'C:\HW_DB\HW_3\collection_track.csv' DELIMITER ';' CSV;
COPY musician_album FROM 'C:\HW_DB\HW_3\band_album.csv' DELIMITER ';' CSV;
COPY genre_musician FROM 'C:\HW_DB\HW_3\band_genre.csv' DELIMITER ';' CSV;

INSERT INTO genre_musician (id, musician_id, genre_id)
VALUES (13,2,1);

INSERT INTO collection_track (id, collection_id, track_id)
VALUES (151, 10, 995);