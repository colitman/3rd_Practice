set echo on

drop table t;

create table t ( x int primary key,
                 a char(2000),
                 b char(2000),
                 c char(2000),
                 d char(2000),
                 e char(2000),
                 f char(2000),
                 g char(2000),
                 h char(2000),
                 i char(2000) );

begin
   sys.dbms_logmnr_d.build( 'miner_dictionary.dat',
                            'c:\temp' );
end;
/

alter system archive log current;

insert into t ( x, a ) values ( 1, 'non-chained' );

commit;

update t set a = 'chained row', 
             b = 'x', c = 'x', 
             d = 'x', e = 'x' 
 where x = 1;

commit;

update t set a = 'chained row', 
             b = 'x', c = 'x', 
             d = 'x', e = 'x',
             f = 'x', g = 'x',
             h = 'x', i = 'x'
 where x = 1;

commit;

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
   ( dictFileName => 'c:\temp\miner_dictionary.dat' );
end;
/

column sql_redo format a27
column sql_undo format a27
column scn format 999999999999999

select scn, sql_redo, sql_undo
  from v$logmnr_contents
 where sql_redo is not null or sql_undo is not null
/