set echo on
disconnect
connect tkyte/tkyte

declare
    l_cnt  number default 0;
begin
    for x in (select name 
                from v$archived_log 
               order by completion_time desc )
    loop
        l_cnt := l_cnt+1;
        exit when ( l_cnt > 2 );

        sys.dbms_logmnr.add_logfile( x.name );
    end loop;

    sys.dbms_logmnr.start_logmnr
    ( dictFileName => 'c:\temp\miner_dictionary.dat',
      options => sys.dbms_logmnr.USE_COLMAP );
end;
/

select count(*) from v$logmnr_contents;

declare
    l_name v$archived_log.name%type;
begin
    
    select name into l_name
      from v$archived_log 
     where completion_time = ( select max(completion_time) 
                                 from v$archived_log );

    sys.dbms_logmnr.add_logfile( l_name, dbms_logmnr.NEW );

   sys.dbms_logmnr.start_logmnr
   ( dictFileName => 'c:\temp\miner_dictionary.dat',
     options => sys.dbms_logmnr.USE_COLMAP );
end;
/

select count(*) from v$logmnr_contents;