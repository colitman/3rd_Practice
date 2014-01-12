set echo on
set serveroutput on

alter table added_a_column add ( y int );


alter table dropped_a_column drop column y;


delete from modified_a_column;


alter table modified_a_column modify y date;
/

host imp userid=tkyte/tkyte full=y ignore=y

