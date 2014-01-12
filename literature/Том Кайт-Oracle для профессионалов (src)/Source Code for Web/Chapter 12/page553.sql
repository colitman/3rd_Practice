set echo on

select ename, deptno,
  sum(sal) over (order by ename, deptno) sum_ename_deptno,
  sum(sal) over (order by deptno, ename) sum_deptno_ename
from emp
order by ename, deptno
/