set echo on
set timing on

variable n number

drop table t;

create table t
as
select object_name ename,
       mod(object_id,50) deptno,
       object_id sal
  from all_objects
 where rownum <= 1000
/

create index t_idx on t(deptno,sal desc);

analyze table t 
compute statistics 
for table 
for all indexed columns 
for all indexes
/

spool x
alter session set sql_trace=true;

select *
from (select deptno, ename, sal,
      dense_rank() over (partition by deptno
                         order by sal desc) dr
          from t )
 where dr <= 3
 order by deptno, sal desc
/

select deptno, ename, sal
from t e1
where sal in (select sal
              from (select distinct sal , deptno
                    from t e3
                    order by deptno, sal desc) e2
              where e2.deptno = e1.deptno
              and rownum <= 3)
 order by deptno, sal desc
/

select *
from (select deptno, ename, sal,
      count(*) over (partition by deptno
                     order by sal desc
                     range unbounded preceding)
      cnt from t)
where cnt <= 3
order by deptno, sal desc
/

select deptno, ename, sal
from t e1
where (select count(*)
       from t e2
       where e2.deptno = e1.deptno
       and e2.sal >= e1.sal) <= 3
order by deptno, sal desc
/


select *
from (select deptno, ename, sal,
      row_number() over (partition by deptno
                         order by sal desc) 
      rn from t)
where rn <= 3
/

select deptno, ename, sal
from t e1
where (select count(*)
       from t e2
       where e2.deptno = e1.deptno
       and e2.sal >= e1.sal 
       and (e2.sal > e1.sal OR e2.rowid > e1.rowid) ) < 3 
order by deptno, sal desc
/

set autotrace off
spool off