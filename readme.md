# Снаряжение для горного туризма

## Таблицы и справочники:

-   `countries(id, name)` - справочник стран
-   `customers(id, fullname, type, discount, wallet)` - таблица покупателей
-   `vendors(id, name, phone, id_country)` - таблица поставщиков
-   `manufacturers(id, name, id_country)` - таблица производителей
-   `equip(id, name, price, id_vendor, id_manufacturer, date_release)` - таблица доступного снаряжения
-   `orders(id, id_customer, equip_name, quantity, date_sold)` - таблица заказов

## Роли:

-   `operator` - оператор
-   `user` - пользователь
-   `admin` - админ

## Функции:

-   `get_data()` - получить сведения (наименование, дату выпуска, поставщик, производитель, цена, дата продажи) о снаряжении;
-   получить список товаров, отсортированный по:
    1. `sort_date_release()` - дате выпуска
    2. `sort_vendor()` - поставщику
    3. `sort_price()` - стоимости
    4. `sort_date_sold()` - дате продажи
-   найти:
    1. `max_price()` - самое дорогое снаряжение
    2. `min_price()` - самое дешевое снаряжение
    3. `avg_price()` - средню стоимость снаряжения
-   `between_price(numeric, numeric)` - найти снаряжение в заданных пределах стоимости
-   `get_by_vendor(varchar)` - найти снаряжение заданного производителя
-   `get_less_than(numeric)` - найти долю дешевого снаряжения
-   `get_by_release(date)` - найти снаряжение с заданной датой выпуска
-   `by_interval(interval)`, `by_date_and_manuf(interval, varchar)` - снаряжение, чья дата продажи находится в заданных пределах для заданного производителя и в целом
-   `by_date(date, date)` - снаряжение, проданное за опеределенный период
-   `most_popular()` - самое популярное снаряжение
-   `by_vendor_with_price(varchar, text)` - найти все снаряжение, поступившее от заданного поставщика, чья стоимость больше, чем средняя стоимость снаряжения, поступившего из заданной страны
-   `greater_than(numeric)`, `greater_than(numeric, varchar)` - найти долю дорогого снаряжения, чья стоимость больше заданной, поступившего от заданного поставщика и в целом
-   `avg_price_by_date(date, date)` - найти среднюю стоимость снаряжения, проданного за определенный период времени
-   `price_greater_than_avg_manufac(text)` - найти снаряжение, чья стоимость выше, чем средняя стоимость снаряжения заданного производителя
-   `is_regular_delivery()` - определить долю регулярных поставок снаряжения
-   `count_with_price_status(integer)` - найти объем продаж снаряжения за месяц, квартал, год за этот же период найти среднюю стоимость, `equip_with_price_by_period(integer, text)` - самое дорогое, самое дешевое
