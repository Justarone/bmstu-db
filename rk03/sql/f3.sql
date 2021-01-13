with bad_ids as (
    select id
    from empls_actions
    where inout = 1 AND dt = '2020-12-19'
    group by id
    having min(t) > '9:30'
)
select distinct department
from empls_list
where id in (
    select id
    from bad_ids
);
