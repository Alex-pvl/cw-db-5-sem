-- админ
CREATE ROLE admin WITH PASSWORD 'admin' LOGIN NOSUPERUSER CREATEROLE CREATEDB;
GRANT SELECT,
    INSERT,
    UPDATE,
    DELETE ON countries,
    customers,
    equip,
    manufacturers,
    orders,
    vendors TO admin;
-- оператор
CREATE ROLE operator WITH PASSWORD 'operator' LOGIN;
GRANT SELECT,
    UPDATE,
    INSERT ON countries,
    customers,
    equip,
    manufacturers,
    orders,
    vendors TO operator;
-- пользователь
CREATE ROLE user_db WITH PASSWORD 'user' LOGIN;
GRANT SELECT,
    INSERT,
    UPDATE,
    DELETE ON countries,
    customers,
    equip,
    manufacturers,
    orders,
    vendors TO user_db;