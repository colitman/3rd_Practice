set echo on

select max(count(*)) from emp group by deptno, job;

column deptno format 999
column sal_1 format 9999
column sal_2 format 9999
column sal_3 format 9999
column sal_4 format 9999
column ename_1 format a6
column ename_4 format a6

select deptno, job, 
       max( decode( rn, 1, ename, null )) ename_1,
       max( decode( rn, 1, sal, null )) sal_1,
       max( decode( rn, 2, ename, null )) ename_2,
       max( decode( rn, 2, sal, null )) sal_2,
       max( decode( rn, 3, ename, null )) ename_3,
       max( decode( rn, 3, sal, null )) sal_3,
       max( decode( rn, 4, ename, null )) ename_4,
       max( decode( rn, 4, sal, null )) sal_4
  from (  select deptno, job, ename, sal,
                 row_number() over ( partition by deptno, job
                                         order by sal, ename ) rn
            from emp
           )
group by deptno, job
/