-- Инструкция SELECT, использующая агрегатные функции в выражениях столбцов
-- Средний возраст игроков в таблице

SELECT avg_in_days AS AVG_age,
calced_avg AS Calc_AVG
FROM (
    SELECT AVG(AGE(birthDate)) as avg_in_days,
    SUM(AGE(birthDate)) / COUNT(*) as calced_avg
    FROM player_info
) AS AVGS_IN_DAYS;
