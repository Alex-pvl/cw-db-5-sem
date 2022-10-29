-- админ
CREATE ROLE admin WITH PASSWORD '***' LOGIN NOSUPERUSER CREATEROLE CREATEDB;
-- оператор
CREATE ROLE operator WITH PASSWORD '***' LOGIN;
GRANT SELECT,
    UPDATE,
    INSERT ON countries,
    customers,
    equip,
    manufacturers,
    orders,
    vendors TO operator;
-- пользователь
CREATE ROLE user_db WITH PASSWORD '***' LOGIN;
GRANT SELECT,
    INSERT,
    UPDATE,
    DELETE ON countries,
    customers,
    equip,
    manufacturers,
    orders,
    vendors TO user_db;