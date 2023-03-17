CREATE TABLE IF NOT EXISTS names(
id serial PRIMARY KEY,
name varchar(30)
);

CREATE TABLE IF NOT EXISTS department (
id serial PRIMARY KEY,
name varchar(30)
);

CREATE TABLE IF NOT EXISTS position (
id serial PRIMARY KEY,
name varchar(30)
);

CREATE TABLE IF NOT EXISTS employee (
id serial PRIMARY KEY,
name int,
position int,
department int,
boss_id int,
FOREIGN KEY (department) REFERENCES department(id),
FOREIGN KEY (boss_id) REFERENCES names (id),
FOREIGN KEY (position) REFERENCES POSITION (id),
FOREIGN KEY (name) REFERENCES names (id)
);