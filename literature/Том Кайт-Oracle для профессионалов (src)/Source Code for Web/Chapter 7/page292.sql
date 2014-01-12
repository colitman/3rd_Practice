

set echo on
set server output on

REM reset our counter
exec stats.cnt := 0

set timing on
set autotrace on explain
select ename, hiredate
  from emp
 where my_soundex(ename) = my_soundex('Kings')
/
set autotrace off
set timing off


exec dbms_output.put_line( stats.cnt );


