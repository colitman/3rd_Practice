set echo on

break on deptno skip 1

select deptno, ename, hiredate,
       lag( hiredate, 1, null ) over ( partition by deptno
                                 order by hiredate, ename ) last_hire,
       hiredate - lag( hiredate, 1, null )
                      over ( partition by deptno
                         order by hiredate, ename ) days_last,
       lead( hiredate, 1, null )
        over ( partition by deptno
              order by hiredate, ename ) next_hire,
       lead( hiredate, 1, null )
        over ( partition by deptno
              order by hiredate, ename ) - hiredate days_next
from emp
order by deptno, hiredate
/

select deptno, ename, hiredate,
       lag( hiredate, 1, null ) over ( partition by deptno
                                       order by hiredate, ename ) last_hire,
       hiredate - lag( hiredate, 1, null )
                      over ( partition by deptno
                         order by hiredate, ename ) days_last,
       lead( hiredate, 1, null )
        over ( partition by deptno
              order by hiredate, ename ) next_hire, 
       lead( hiredate, 1, null )
        over ( partition by deptno
              order by hiredate, ename ) - hiredate days_next
from emp
order by deptno, hiredate
/

drop table t;

create table t
as
select object_name ename,
       created hiredate,
	   mod(object_id,50) deptno
  from all_objects
/

alter table t modify deptno not null;
create index t_idx on t(deptno,hiredate,ename)
/

analyze table t
compute statistics
for table
for all indexes
for all indexed columns
/

alter session set optimizer_goal=first_rows;
alter session set sql_trace=true;
set termout off

select deptno, ename, hiredate,
       lag( hiredate, 1, null ) over ( partition by deptno
                                       order by hiredate, ename ) last_hire,
       hiredate - lag( hiredate, 1, null )
                      over ( partition by deptno
                         order by hiredate, ename ) days_last,
       lead( hiredate, 1, null )
        over ( partition by deptno
              order by hiredate, ename ) next_hire,
       lead( hiredate, 1, null )
        over ( partition by deptno
              order by hiredate, ename ) - hiredate days_next
from t
order by deptno, hiredate
/

select deptno, ename, hiredate,
       hiredate-(select max(hiredate)
                   from t e2
                  where e2.deptno = e1.deptno
                    and e2.hiredate < e1.hiredate ) last_hire,
       hiredate-(select max(hiredate)
                   from t e2
                  where e2.deptno = e1.deptno
                    and e2.hiredate < e1.hiredate ) days_last,
       ( select min(hiredate)
           from t e3
          where e3.deptno = e1.deptno
            and e3.hiredate > e1.hiredate ) next_hire,
       ( select min(hiredate)
           from t e3
          where e3.deptno = e1.deptno
            and e3.hiredate > e1.hiredate ) - hiredate days_next
 from t e1
order by deptno, hiredate
/

set termout on