set echo on
disconnect
connect tkyte/tkyte

begin
   sys.dbms_logmnr.add_logfile
   ( logfilename => 'C:\oracle\oradata\tkyte816\archive\TKYTE816T001S01263.ARC',
     options     => sys.dbms_logmnr.NEW );
end;
/

begin
   sys.dbms_logmnr.start_logmnr
   ( dictFileName => 'c:\temp\miner_dictionary.dat' );
end;
/

column sql_redo format a30
column sql_undo format a30
select scn, sql_redo, sql_undo from v$logmnr_contents
/