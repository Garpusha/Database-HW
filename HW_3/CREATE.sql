CREATE TABLE IF NOT EXISTS genre (
genre_id serial PRIMARY KEY,
name varchar(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS musician (
musician_id serial PRIMARY KEY,
name varchar(50) NOT NULL,
url varchar(100)
);

CREATE TABLE IF NOT EXISTS album (
album_id serial PRIMARY KEY,
name varchar(50) NOT NULL,
year integer NOT NULL CONSTRAINT real_year CHECK (year > 1900 AND year < 2100),
url varchar(100)
);

CREATE TABLE IF NOT EXISTS track (
track_id serial PRIMARY KEY,
name varchar(50) NOT NULL,
length int NOT NULL CONSTRAINT real_len CHECK (length > 0),
album_id integer, 
FOREIGN KEY (album_id) REFERENCES album (album_id),
url varchar(100)
);

CREATE TABLE IF NOT EXISTS collection (
collection_id serial PRIMARY KEY,
name varchar(50) NOT NULL,
year integer NOT NULL CONSTRAINT real_year CHECK (year > 1900 AND year < 2100)
);

CREATE TABLE IF NOT EXISTS genre_musician (
id serial PRIMARY KEY,
musician_id integer,
genre_id integer,
FOREIGN KEY (musician_id) REFERENCES musician (musician_id),
FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
);

CREATE TABLE IF NOT EXISTS musician_album (
id serial PRIMARY KEY,
musician_id integer,
album_id integer,
FOREIGN KEY (musician_id) REFERENCES musician (musician_id),
FOREIGN KEY (album_id) REFERENCES album (album_id)
);

CREATE TABLE IF NOT EXISTS collection_track (
id serial PRIMARY KEY,
collection_id integer,
track_id integer,
FOREIGN KEY (collection_id) REFERENCES collection (collection_id),
FOREIGN KEY (track_id) REFERENCES track (track_id)
);