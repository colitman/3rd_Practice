set echo on

select ename, hiredate,
   first_value(ename) over
     (order by hiredate asc
      range between 100 preceding and 100 following),
      last_value(ename) over
     (order by hiredate asc
      range between 100 preceding and 100 following)
from emp
order by hiredate asc
/
