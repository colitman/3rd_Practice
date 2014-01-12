set echo on

select a.name, b.value
  from v$statname a, v$mystat b
 where a.statistic# = b.statistic#
   and lower(a.name) like '%pga%'
/

declare
	l_name varchar2(255) default 
	      'C:\oracle\ORADATA\tkyte816\archive\TKYTE816T001S012';
begin
	for i in 49 .. 50 
    loop
        sys.dbms_logmnr.add_logfile( l_name || i || '.ARC' );
    end loop;

    sys.dbms_logmnr.start_logmnr
    ( dictFileName => 'c:\temp\miner_dictionary.dat',
      options => sys.dbms_logmnr.USE_COLMAP );
end;
/

select a.name, b.value
  from v$statname a, v$mystat b
 where a.statistic# = b.statistic#
   and lower(a.name) like '%pga%'
/

select count(*) from v$logmnr_contents;

create table tmp_logmnr_contents unrecoverable
as
select * from v$logmnr_contents
/

exec sys.dbms_logmnr.end_logmnr

select a.name, b.value
  from v$statname a, v$mystat b
 where a.statistic# = b.statistic#
   and lower(a.name) like '%pga%'
/