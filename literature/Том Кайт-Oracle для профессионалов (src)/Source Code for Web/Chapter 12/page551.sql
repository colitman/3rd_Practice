set echo on
set numformat 99999.99

select ename, sal, avg(sal) over ()
from emp
/

select ename, sal, avg(sal)  over ( ORDER BY ENAME )
from emp
order by ename
/