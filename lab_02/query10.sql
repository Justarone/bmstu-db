-- Инструкция SELECT, использующая поисковое выражение CASE
-- Маркируем игроков по возрасту

SELECT firstName, lastName, birthDate
    CASE
        WHEN EXTRACT(YEAR FROM birthDate) >= 2000 THEN 'Молодой и перспективный'
        WHEN EXTRACT(YEAR FROM birthDate) >= 1990 THEN 'В самом рассвете сил'
        WHEN EXTRACT(YEAR FROM birthDate) >= 1980 THEN 'На закате карьеры'
        ELSE 'Скорее всего уже не играет'
    END AS Description
FROM player_info;
