set echo on

break on deptno skip 1

select *
  from ( select deptno, ename, sal,
                count(*) over ( partition by deptno
                                    order by sal desc
                                    range unbounded preceding ) cnt
           from emp )
  where cnt <= 3
  order by deptno, sal desc
/

select *
  from ( select deptno, ename, sal,
                count(*) over ( partition by deptno
                                    order by sal desc, ename
                                    range unbounded preceding ) cnt
           from emp )
  where cnt <= 3
  order by deptno, sal desc
/

update emp set sal = 99 where deptno = 30;

select *
from (select deptno, ename, sal,
      count(*) over (partition by deptno
                     order by sal desc
                     range unbounded preceding)
      cnt from emp)
where cnt <= 3
order by deptno, sal desc
/

rollback;