set echo on

select text
from all_source
where name = 'DBMS_OUTPUT'
and type = 'PACKAGE BODY'
and line < 10
order by line
/

select text
  from all_source
 where name = 'DBMS_OUTPUT'
   and type = 'PACKAGE'
   and line < 26
 order by line
/