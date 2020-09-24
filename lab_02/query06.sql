-- Инструкция SELECT, использующая предикат сравнения с квантором
-- Все игроки, старше всех белорусов лиги.
SELECT firstName, lastName
FROM player_info
WHERE birthDate < all (
    SELECT birthDate
    FROM player_info
    WHERE nationality = 'BLR'
);
