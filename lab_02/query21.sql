-- Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE
DELETE FROM team_info
WHERE team_id IN (
    SELECT team_id
    FROM team_info
    WHERE franshizeId > 100
);
