set echo on

select ename, comm from emp order by comm desc
/

select ename, comm, dr
from (select ename, comm, 
      dense_rank() over (order by comm desc) 
      dr from emp)
where dr <= 3
order by comm desc
/

select ename, comm, dr
from (select ename, comm, 
      dense_rank() over (order by comm desc) 
      dr from emp
      where comm is not null)
where dr <= 3
order by comm desc
/


select ename, comm, dr
from (select ename, comm, 
      dense_rank() over (order by comm desc nulls last)
      dr from emp
      where comm is not null)
where dr <= 3
order by comm desc
/

select ename, comm from emp order by comm desc nulls last
/