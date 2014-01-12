set echo on

break on deptno skip 1

update emp set sal = 99 where deptno = 30;

select *
  from (select deptno, ename, sal,
               row_number() over ( partition by deptno
                                   order by sal desc ) rn
          from emp )
 where rn <= 3
/

rollback;