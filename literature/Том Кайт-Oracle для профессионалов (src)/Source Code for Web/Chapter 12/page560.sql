set echo on
break on deptno skip 1

select deptno, ename, hiredate,
  count(*) over (partition by deptno
                 order by hiredate nulls first
                 range 100 preceding) cnt_range,
  count(*) over (partition by deptno
                 order by hiredate nulls first
                 rows 2 preceding) cnt_rows
from emp
where deptno in (10, 20)
order by deptno, hiredate
/