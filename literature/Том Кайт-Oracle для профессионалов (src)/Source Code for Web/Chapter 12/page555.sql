set echo on
column first_asc format a16
column first_desc format a16
column last_asc format a16
column last_desc format a16

select ename, sal, hiredate, hiredate-100 windowtop,
       first_value( ename )
           over ( order by hiredate asc
                  range 100 preceding ) ename_prec,
       first_value( hiredate )
           over ( order by hiredate asc
                  range 100 preceding ) hiredate_prec
  from emp
 order by hiredate asc
/

select ename, sal, hiredate, hiredate+100 windowtop,
       first_value( ename )
           over ( order by hiredate desc
                  range 100 preceding ) ename_prec,
       first_value( hiredate )
           over ( order by hiredate desc
                  range 100 preceding ) hiredate_prec
  from emp
 order by hiredate desc
/

set numformat 9999.99
select ename, hiredate, sal,
    avg(sal)
    over ( order by hiredate asc  range 100 preceding ) avg_sal_100_days_BEFORE,
       avg(sal)
       over ( order by hiredate desc  range 100 preceding ) avg_sal_100_days_AFTER
  from emp
 order by hiredate
/