-- получить сведения (наименование, дату выпуска, поставщик, производитель, цена, дата продажи)
create or replace function get_data() returns table (
        id integer,
        name text,
        release date,
        vendor varchar(255),
        manufacturer varchar(255),
        price numeric,
        sold date
    ) as $$ BEGIN RETURN QUERY
select e.id,
    e.name,
    e.date_release as release,
    v.name as vendor,
    m.name as manufacturer,
    e.price,
    o.date_sold as sold
from equip e
    join vendors v on v.id = e.id_vendor
    join manufacturers m on m.id = e.id_manufacturer
    join orders o on o.equip_name = e.name;
END;
$$ language plpgsql;
-- получить список товаров, отсортированный по:
-- 1) дате выпуска
create or replace function sort_date_release() returns table (
        id integer,
        name text,
        price numeric,
        id_vendor integer,
        id_manufacturer integer,
        date_release date
    ) as $$ begin return query
select *
from equip
order by date_release;
end;
$$ language plpgsql;
-- 2) поставщику
create or replace function sort_vendor() returns table (
        id integer,
        name text,
        price numeric,
        vendor text
    ) as $$ begin return query
select e.id,
    e.name,
    e.price,
    v.name
from equip e
    join vendors v on e.id_vendor = v.id
order by v.name;
end;
$$ language plpgsql;
-- 3) стоимости
create or replace function sort_price() returns table (
        id integer,
        name text,
        price numeric,
        id_vendor integer,
        id_manufacturer integer,
        date_release date
    ) as $$ begin return query
select *
from equip
order by price;
end;
$$ language plpgsql;
-- 4) дате продажи
create or replace function sort_date_sold() returns table (
        id integer,
        name text,
        price numeric,
        release date
    ) as $$ begin return query
select e.id,
    e.name,
    e.price,
    o.date_sold
from equip e
    join orders o on e.name = o.equip_name
order by o.date_sold;
end;
$$ language plpgsql;
--
-- найти ? снаряжение:
-- 1) самое дорогое
create or replace function max_price() returns table (
        id integer,
        name text,
        price numeric,
        id_vendor integer,
        id_manufacturer integer,
        date_release date
    ) as $$ begin return query
select *
from equip
where price = (
        select MAX(price)
        from equip
    );
end;
$$ language plpgsql;
-- 2) самое дешевое
create or replace function min_price() returns table (
        id integer,
        name text,
        price numeric,
        id_vendor integer,
        id_manufacturer integer,
        date_release date
    ) as $$ begin return query
select *
from equip
where price = (
        select MIN(price)
        from equip
    );
end;
$$ language plpgsql;
-- 3) среднюю стоимость
create or replace function avg_price() returns numeric as $$ begin
select AVG(price)
from equip;
end;
$$ language plpgsql;
--
-- найти снаряжение в заданных пределах
create or replace function between_price(min numeric, max numeric) returns table (
        id integer,
        name text,
        price numeric,
        id_vendor integer,
        id_manufacturer integer,
        date_release date
    ) as $$ begin return query
select *
from equip
where price between min and max;
end;
$$ language plpgsql;
--
-- найти снаряжение заданного производителя
create or replace function get_by_vendor(_vendor varchar(255)) returns table (
        id integer,
        name text,
        price numeric,
        vendor varchar(255)
    ) as $$ begin return query
select e.id,
    e.name,
    e.price,
    v.name as vendor
from equip e
    join vendors v on v.id = e.id_vendor
where upper(v.name) = upper(_vendor);
end;
$$ language plpgsql;
--
-- найти долю дешевого снаряжения
create or replace function get_less_than(_price numeric) returns table (
        id integer,
        name text,
        price numeric,
        id_vendor integer,
        id_manufacturer integer,
        date_release date
    ) as $$ begin return query
select *
from equip
where price < _price;
end;
$$ language plpgsql;
--
-- найти снаряжение с заданной датой выпуска
create or replace function get_by_release(_release date) returns table (
        id integer,
        name text,
        price numeric,
        id_vendor integer,
        id_manufacturer integer,
        date_release date
    ) as $$ begin return query
select *
from equip
where date_release = _release;
end;
$$ language plpgsql;
--
-- снаряжение, чья дата продажи находится в заданных пределах для заданного производителя и в целом
--
-- самое популярное снаряжение
create or replace function most_popular() returns text as $$ begin
select e.name
from equip e
    join orders on o.equip_name = e.name
where o.quantity = (
        select MAX(quantity)
        from orders
    );
end;
$$ language plpgsql;