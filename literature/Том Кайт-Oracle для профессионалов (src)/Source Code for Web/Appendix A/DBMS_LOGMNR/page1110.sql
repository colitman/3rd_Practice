set echo on

alter system archive log current;

drop table dept;

alter system archive log current;

declare
    l_name v$archived_log.name%type;
begin
    select name into l_name
      from v$archived_log 
     where completion_time = ( select max(completion_time) 
                                 from v$archived_log );

    sys.dbms_logmnr.add_logfile( l_name, sys.dbms_logmnr.NEW );
end;
/

begin
   sys.dbms_logmnr.start_logmnr
   ( dictFileName => 'c:\temp\miner_dictionary.dat',
     options => sys.dbms_logmnr.USE_COLMAP );
end;
/

column scn format 9999999999 
column sql_redo format a40

select scn, sql_redo
  from v$logmnr_contents
 where sql_redo like 'delete from SYS.OBJ$ %''DEPT''%'
/