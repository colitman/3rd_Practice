set echo on

select ename, hiredate, sal
  from ( select ename, hiredate, sal,
                row_number() over ( order by ename ) rn
                   from emp
           )
 where rn between 5 and 10
 order by rn
/