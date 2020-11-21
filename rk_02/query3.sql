-- Создание новой временной локально таблицы из результирующего набора данных интсрукции SELECT
-- Создадим временную таблицу вида "имя меню - тип меню - имя блюда"

SELECT m.name as mname, mtype, d.name as dname
INTO temp table temp_md_named
FROM menu m
JOIN md
on md.mid = m.id
JOIN dishes d
ON d.id = md.did;
