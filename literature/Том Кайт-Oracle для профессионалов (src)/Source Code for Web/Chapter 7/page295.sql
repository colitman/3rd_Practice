set server out put on
set echo on

create or replace view emp_v
as
select ename, substr(my_soundex(ename),1,6) ename_soundex, hiredate
  from emp
/

exec stats.cnt := 0;

set timing on
set autotrace on explain
select ename, hiredate
  from emp_v
 where ename_soundex = my_soundex('Kings')
/
set autotrace off
set timing off


exec dbms_output.put_line( stats.cnt )
