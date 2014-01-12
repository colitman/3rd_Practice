set echo on

drop table t;

create table t 
as
select object_name ename,
       mod(object_id,50) deptno,
       object_id sal
  from all_objects
  where rownum <= 1000
/

create index t_idx on t(deptno,ename);

set autotrace traceonly
set timing on
select ename, deptno, sal,
  sum(sal) over
    (order by deptno, ename) running_total,
  sum(sal) over
    (partition by deptno
     order by ename) department_total,
  row_number() over
    (partition by deptno
     order by ename) seq
from t emp
order by deptno, ename
/

select ename, deptno, sal,
  (select sum(sal)
    from t e2
    where e2.deptno < emp.deptno
    or (e2.deptno = emp.deptno and e2.ename <= emp.ename ))
running_total,
  (select sum(sal)
    from t e3
    where e3.deptno = emp.deptno
    and e3.ename <= emp.ename)
department_total,
  (select count(ename)
    from t e3
    where e3.deptno = emp.deptno
    and e3.ename <= emp.ename)
seq
from t emp
order by deptno, ename
/

set autotrace off 