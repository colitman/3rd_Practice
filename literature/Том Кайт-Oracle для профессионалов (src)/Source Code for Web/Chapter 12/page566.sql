set echo on
break on deptno skip 1

select *
  from ( select deptno, ename, sal,
                dense_rank() over ( partition by deptno
                                    order by sal desc ) dr
          from emp )
 where dr <= 3
 order by deptno, sal desc
/

select deptno, ename, sal, 
       dense_rank() over ( partition by deptno
                               order by sal desc ) dr,
       rank() over ( partition by deptno
                         order by sal desc ) r
  from emp
 order by deptno, sal desc
/