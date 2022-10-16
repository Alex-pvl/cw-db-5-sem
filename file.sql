CREATE DATABASE tour_equip OWNER nstu;
-- города
CREATE TABLE cities(
    id serial NOT NULL,
    name text NOT NULL,
    PRIMARY KEY(id)
);
-- страны
CREATE TABLE countries(
    id serial NOT NULL,
    name text NOT NULL,
    PRIMARY KEY(id)
);
-- покупатели
CREATE TABLE customers(
    id serial PRIMARY KEY,
    fullname varchar(255) NOT NULL,
    type varchar(2) NOT NULL DEFAULT('ФЛ'),
    discount integer CHECK (discount > 0),
    wallet numeric CHECK (wallet >= 0)
);
