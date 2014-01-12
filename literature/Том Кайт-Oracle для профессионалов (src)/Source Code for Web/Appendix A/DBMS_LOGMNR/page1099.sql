set echo on

disconnect
connect tkyte/tkyte

drop table emp;
drop table dept;

create table emp as select * from scott.emp;
create table dept as select * from scott.dept;

begin
   sys.dbms_logmnr.add_logfile
   ( logfilename => 'C:\oracle\oradata\tkyte816\archive\TKYTE816T001S01263.ARC',
     options     => sys.dbms_logmnr.NEW );
end;
/

begin
   sys.dbms_logmnr.start_logmnr;
end;
/

column sql_redo format a30
column sql_undo format a30
select scn, sql_redo, sql_undo from v$logmnr_contents
/

select utl_raw.cast_to_varchar2(hextoraw('787878')) from dual;
select utl_raw.cast_to_varchar2(hextoraw('534d495448')) from dual;

select object_name
from all_objects
where data_object_id = 30551;