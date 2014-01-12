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
   ( dictFileName => 'c:\temp\miner_dictionary.dat' );
end;
/


column sql_redo format a20 word_wrapped
column sql_undo format a20 word_wrapped

select scn, sql_redo, sql_undo from v$logmnr_contents
/

exec sys.dbms_logmnr.end_logmnr