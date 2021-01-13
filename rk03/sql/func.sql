CREATE OR REPLACE FUNCTION cnt_young_leavers()
RETURNS bigint
AS $$
DECLARE
    res bigint default 0;
BEGIN
    WITH leavers AS ( -- Id тех, кто выходил более 3 раз
        SELECT id
        FROM empls_actions
        WHERE inout = 2
        GROUP BY id
        HAVING count(*) >= 3
    )
    SELECT count(*)
    INTO res
    FROM leavers
    JOIN empls_list el
    ON el.id = leavers.id
    WHERE extract(year from age(birthdate)) > 18 AND extract(year from age(birthdate)) < 40;
    RETURN res;
END;
$$ LANGUAGE PLPGSQL;
