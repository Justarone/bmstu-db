select department
from empls_list
group by department
having count(*) > 10;
