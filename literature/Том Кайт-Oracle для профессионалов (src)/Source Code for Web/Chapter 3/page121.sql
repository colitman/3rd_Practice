create or replace procedure p as begin null; end;
/

exec p

select * from dba_ddl_locks;

alter procedure p compile;

select * from dba_ddl_locks;
