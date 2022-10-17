# Снаряжение для горного туризма

## Таблицы и справочники:

-   `countries(id, name)` справочник стран
-   `customers(id, fullname, type, discount, wallet)` таблица покупателей
-   `vendors(id, name, phone, id_country)` таблица поставщиков
-   `manufacturers(id, name, id_country)` таблица производителей
-   `equip(id, name, price, id_vendor, id_manufacturer, date_release)` таблица доступного снаряжения
-   `orders(id, id_customer, equip_name, quantity, date_sold)` таблица заказов

## Роли:

-   `operator` оператор
-   `user` пользователь
-   `admin` админ

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
-   `TODO` снаряжение, чья дата продажи находится в заданных пределах для заданного производителя и в целом
-   `most_popular()` - самое популярное снаряжение
