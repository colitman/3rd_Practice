set echo on

set pagesize 30
set pause on
prompt remember to hit ENTER to start reading

select text
  from all_source
 where name = 'DBMS_SQL'
   and type = 'PACKAGE'
 order by line
/