set echo on
column first_asc format a16
column first_desc format a16
column last_asc format a16
column last_desc format a16

select ename, sal, hiredate,
       first_value( ename )
           over ( order by hiredate asc
                  rows 5 preceding ) ename_prec,
       first_value( hiredate )
           over ( order by hiredate asc
                  rows 5 preceding ) hiredate_prec
  from emp
 order by hiredate asc
/

select ename, sal, hiredate, 
       first_value( ename )
           over ( order by hiredate desc
                  rows 5 preceding ) ename_prec,
       first_value( hiredate )
           over ( order by hiredate desc
                  rows 5 preceding ) hiredate_prec
  from emp
 order by hiredate desc
/

set numformat 9999.99
select ename, hiredate, sal,
       avg(sal)
       over ( order by hiredate asc rows 5 preceding ) avg_5_before,
           count(*)
       over ( order by hiredate asc rows 5 preceding ) obs_before,
       avg(sal)
       over ( order by hiredate desc rows 5 preceding ) avg_5_after,
           count(*)
       over ( order by hiredate desc rows 5 preceding ) obs_after
  from emp
 order by hiredate
/