set echo on

break on deptno skip 1
select ename, deptno, sal,
       sum(sal) over
              (order by deptno, ename) running_total,
       sum(sal) over
              (partition by deptno
               order by ename) department_total,
       row_number() over
              (partition by deptno
               order by ename  ) seq
from emp
order by deptno, ename
/