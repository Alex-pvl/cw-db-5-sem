CREATE DATABASE tour_equip OWNER nstu;
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
    discount integer CHECK (discount >= 0),
    wallet numeric CHECK (wallet >= 0)
);
-- поставщики
CREATE TABLE vendors(
    id serial PRIMARY KEY,
    name varchar(255) NOT NULL,
    phone text NOT NULL,
    id_country integer NOT NULL REFERENCES countries(id)
);
-- производители
CREATE TABLE manufacturers(
    id serial PRIMARY KEY,
    name varchar(255) NOT NULL,
    id_country integer NOT NULL REFERENCES countries(id)
);
-- снаряжение
CREATE TABLE equip(
    id serial PRIMARY KEY,
    name text NOT NULL UNIQUE,
    price numeric CHECK (price > 0),
    id_vendor integer NOT NULL REFERENCES vendors(id),
    id_manufacturer integer NOT NULL REFERENCES manufacturers(id),
    date_release date NOT NULL,
    regular_delivery boolean NOT NULL DEFAULT (false)
);
-- заказы
CREATE TABLE orders(
    id serial PRIMARY KEY,
    id_customer integer NOT NULL REFERENCES customers(id),
    equip_name text NOT NULL REFERENCES equip(name),
    quantity integer NOT NULL CHECK (quantity > 0),
    date_sold date NOT NULL DEFAULT(now()::date)
);