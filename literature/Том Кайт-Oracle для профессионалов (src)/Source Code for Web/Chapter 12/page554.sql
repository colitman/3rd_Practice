set echo on
break on deptno skip 1

select deptno, ename, sal, 
  sum(sal) over 
    (partition by deptno
     order by ename
     rows 2 preceding) sliding_total
from emp
order by deptno, ename
/