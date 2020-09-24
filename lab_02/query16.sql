-- Однострочная инструкция INSERT, выполняющая вставку в таблицу одной строки значений
-- Создадим новую команду (самая малая таблица, проще будет проверить и в дальнейшем оттуда убрать)

INSERT INTO team_info (team_id, franshizeId, shortName, teamName, abbreviation)
    VALUES (101, 101, 'Moscow', 'Spartak', 'SPA');
