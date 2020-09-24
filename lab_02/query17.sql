-- Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзарпоса.
-- Добавление с использованием запроса

-- INSERT INTO team_info (team_id, franshizeId, shortName, teamName, abbreviation)
-- SELECT SUM(team_id), SUM(franshizeId), 'Moscow', 'Spartak', 'SPA'
-- FROM team_info;

INSERT INTO team_info (team_id, franshizeId, shortName, teamName, abbreviation)
SELECT team_id * 1000, franshizeId * 1000, shortName, teamName, abbreviation
FROM team_info;
