-- Инструкция SELECT, использующая предикат сравнения с квантором
-- Все такие продукты, у которых срок годности истекает позже завоза последнего продукта

SELECT id, name
FROM products
WHERE available_until > ALL(
    SELECT man_date
    FROM products
);
