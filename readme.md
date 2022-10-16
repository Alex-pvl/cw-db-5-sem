# Снаряжение для горного туризма

## Таблицы и справочники:

cities(id, name) справочник городов
countries(id, name) справочник стран
customers(id, fullname, type, discount, wallet) таблица покупателей
vendors(id, name, phone, id_city) таблица поставщиков
manufacturers(id, name, id_country) таблица производителей
equip(id, name, price, id_vendor, id_manufacturer, date_release) таблица доступного снаряжения
orders(id, id_customer, equip_name, quantity, date_sold) таблица заказов

## Роли:

operator оператор
user пользователь
admin админ
