-- Инструкция UPDATE со скалярным подзапросом в предложении SET

UPDATE team_info
SET franshizeId = franshizeId + (
    SELECT SUM(team_id)
    FROM team_info
    WHERE team_id > 100
)
WHERE franshizeId > 100;
