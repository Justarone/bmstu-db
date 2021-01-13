with bad_ids as (
    select distinct id 
    from empls_actions
    where inout = 2
    group by id, dt
    having count(*) > 1
)
select fio
from empls_list
where id not in (
    select id
    from bad_ids
);
