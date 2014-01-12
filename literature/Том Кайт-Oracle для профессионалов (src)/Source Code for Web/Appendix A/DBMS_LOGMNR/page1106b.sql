set echo on
disconnect
connect tkyte/tkyte

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

column ph1_name format a6
column ph2_name format a5
column ph3_name format a3
column ph1_undo format a3
column ph1_redo format a3
column ph2_undo format a10
column ph2_redo format a10
column ph3_undo format a8
column ph3_redo format a8

select scn, ph1_name, ph1_undo, ph1_redo,
            ph2_name, ph2_undo, ph2_redo,
            ph3_name, ph3_undo, ph3_redo
  from v$logmnr_contents
 where seg_name = 'DEPT'
/

exec sys.dbms_logmnr.end_logmnr