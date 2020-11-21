-- Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
-- вывести все пары вида 'блюдо - продукт и его срок годности' и для этой пары вывести наиболее ранний истекающий срок годности продукта в блюде

SELECT d.name, p.name, p.available_until, MIN(p.available_until) OVER (PARTITION BY d.id) as ends_in
FROM dishes d
JOIN pd
ON pd.did = d.id
JOIN products p
ON pd.pid = p.id;
