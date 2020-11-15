-- fake players перед вызовом процедуры
SELECT *
FROM fake_player_info;
CALL remove_fakes();
-- fake player после вызова процедуры
SELECT *
FROM fake_player_info;
