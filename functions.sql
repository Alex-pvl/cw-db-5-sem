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
        date_release date,
        regular_delivery boolean
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
        vendor varchar(255)
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
        date_release date,
        regular_delivery boolean
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
        sold date
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
        date_release date,
        regular_delivery boolean
    ) as $$ begin return query
select *
from equip e
where e.price = (
        select MAX(e.price)
        from equip e
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
        date_release date,
        regular_delivery boolean
    ) as $$ begin return query
select *
from equip e
where e.price = (
        select MIN(e.price)
        from equip e
    );
end;
$$ language plpgsql;
-- 3) среднюю стоимость
create or replace function avg_price() returns numeric language sql as $$
select AVG(e.price)
from equip e;
$$;
--
-- найти снаряжение в заданных пределах
create or replace function between_price(min numeric, max numeric) returns table (
        id integer,
        name text,
        price numeric,
        id_vendor integer,
        id_manufacturer integer,
        date_release date,
        regular_delivery boolean
    ) as $$ begin return query
select *
from equip e
where e.price between min and max;
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
        date_release date,
        regular_delivery boolean
    ) as $$ begin return query
select *
from equip e
where e.price < _price;
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
        date_release date,
        regular_delivery boolean
    ) as $$ begin return query
select *
from equip e
where e.date_release = _release;
end;
$$ language plpgsql;
--
-- снаряжение, чья дата продажи находится в заданных пределах для заданного производителя и в целом
-- для производителя
create or replace function by_date_and_manuf(_interval interval, _manuf varchar(255)) returns table (
        id integer,
        name text,
        date_sold date,
        manufacturer varchar(255)
    ) as $$ begin return query
select e.id,
    e.name,
    o.date_sold,
    m.name as manufacturer
from equip e
    join orders o on e.name = o.equip_name
    join manufacturers m on e.id_manufacturer = m.id
where now() - o.date_sold <= _interval
    and now() - o.date_sold >= '1 days'
    and upper(m.name) = upper(_manuf);
end;
$$ language plpgsql;
--
-- в целом
create or replace function by_interval(_interval interval) returns table (
        id integer,
        name text,
        date_sold date,
        vendor varchar(255)
    ) as $$ begin return query
select e.id,
    e.name,
    o.date_sold,
    v.name as vendor
from equip e
    join orders o on e.name = o.equip_name
    join vendors v on e.id_vendor = v.id
where now() - o.date_sold <= _interval
    and now() - o.date_sold >= '1 days';
end;
$$ language plpgsql;
-- найти долю снаряжения, проданного за определенный период
create or replace function by_date(_start date, _end date) returns table (
        id integer,
        name text,
        date_sold date
    ) as $$ begin return query
select e.id,
    e.name,
    o.date_sold
from equip e
    join orders o on e.name = o.equip_name
where o.date_sold >= _start
    and o.date_sold <= _end;
end;
$$ language plpgsql;
--
-- самое популярное снаряжение
create or replace function most_popular() returns table (name text, quantity bigint) as $$ begin return query
select e.name,
    sum(o.quantity) as quantity
from orders o
    left join equip e on o.equip_name = e.name
group by e.name
order by quantity desc
limit 1;
end;
$$ language plpgsql;
--
-- найти все снаряжение, поступившее от заданного поставщика, чья стоимость больше, чем средняя стоимость снаряжения, поступившего из заданной страны
create or replace function by_vendor_with_price(_vendor varchar(255), _country text) returns table (
        id integer,
        name text,
        avg_price numeric,
        price numeric,
        vendor varchar(255)
    ) as $$
declare _avg numeric;
begin
select AVG(e.price) into _avg
from equip e
    join vendors v on v.id = e.id_vendor
    join countries c on c.id = v.id_country
where upper(c.name) = upper(_country);
return query
select e.id,
    e.name,
    round(_avg, 2),
    e.price,
    v.name as vendor
from equip e
    join vendors v on v.id = e.id_vendor
where upper(v.name) = upper(_vendor)
    and e.price > _avg;
end;
$$ language plpgsql;
--
-- найти долю дорогого снаряжения, чья стоимость больше заданной, поступившего от заданного поставщика и в целом
-- от поставщика
create or replace function greater_than(_price numeric, _vendor varchar(255)) returns table (
        id integer,
        name text,
        price numeric,
        vendor varchar(255)
    ) as $$ begin return query
select e.id,
    e.name,
    e.price,
    v.name
from equip e
    join vendors v on v.id = e.id_vendor
where e.price > _price
    and upper(v.name) = upper(_vendor);
end;
$$ language plpgsql;
-- в целом
create or replace function greater_than(_price numeric) returns table (
        id integer,
        name text,
        price numeric
    ) as $$ begin return query
select e.id,
    e.name,
    e.price
from equip e
where e.price > _price;
end;
$$ language plpgsql;
--
-- найти среднюю стоимость снаряжения, проданного за определенный период времени
create or replace function avg_price_by_date(_start date, _end date) returns real language sql as $$
select AVG(e.price)
from equip e
    join orders o on e.name = o.equip_name
where o.date_sold >= _start
    and o.date_sold <= _end;
$$;
--
-- найти снаряжение, чья стоимость выше, чем средняя стоимость снаряжения заданного производителя
create or replace function price_greater_than_avg_manufac(_manufacturer varchar(255)) returns table (
        id integer,
        name text,
        avg_price numeric,
        price numeric,
        manufacturer varchar(255)
    ) as $$
declare _avg numeric;
begin
select avg(e.price) into _avg
from equip e
    join manufacturers m on e.id_manufacturer = m.id
where upper(m.name) = upper(_manufacturer);
return query
select e.id,
    e.name,
    round(_avg, 2),
    e.price,
    m.name as manufacturer
from equip e
    join manufacturers m on e.id_manufacturer = m.id
    left join _avg;
where e.price > _avg;
end;
$$ language plpgsql;
--
-- определить долю регулярных поставок снаряжения
create or replace function is_regular_delivery() returns table (
        id integer,
        name text,
        regular_delivery boolean
    ) as $$ begin return query
select e.id,
    e.name,
    e.regular_delivery
from equip e
where e.regular_delivery = true;
end;
$$ language plpgsql;
--
-- найти объем продаж снаряжения за:
--  1) месяц
--  2) квартал
--  3) год
-- за этот же период найти:
--  а) среднюю стоимость
--  б) самое дорогое
--  в) самое дешевое
create or replace function count_with_price_status(_period integer) returns table (
        count bigint,
        avg_price numeric
    ) as $$ begin return query
select COUNT(e.id) as volume,
    AVG(e.price) as avg_price
from equip e
    join orders o on e.name = o.equip_name
where now() - o.date_sold <= _period * interval '1 month'
    and now() - o.date_sold >= '1 days';
end;
$$ language plpgsql;
--
create or replace function equip_with_price_by_period(_period integer, _property text) returns table (
        id integer,
        name text,
        price numeric,
        date_sold date
    ) as $$
declare _max numeric;
declare _min numeric;
begin
select MAX(e.price) into _max
from equip e
    join orders o on e.name = o.equip_name
where now() - o.date_sold <= _period * interval '1 month'
    and now() - o.date_sold >= '1 days';
select MIN(e.price) into _min
from equip e
    join orders o on e.name = o.equip_name
where now() - o.date_sold <= _period * interval '1 month'
    and now() - o.date_sold >= '1 days';
if (upper(_property) like upper('max')) then return query
select e.id,
    e.name,
    e.price,
    o.date_sold
from equip e
    join orders o on e.name = o.equip_name
where e.price = _max
    and now() - o.date_sold <= _period * interval '1 month'
    and now() - o.date_sold >= '1 days';
end if;
if (upper(_property) like upper('min')) then return query
select e.id,
    e.name,
    e.price,
    o.date_sold
from equip e
    join orders o on e.name = o.equip_name
where e.price = _min
    and now() - o.date_sold <= _period * interval '1 month'
    and now() - o.date_sold >= '1 days';
end if;
end;
$$ language plpgsql;