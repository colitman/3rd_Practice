set echo on

@connect tkyte/tkyte


create or replace function rls_examp
( p_schema in varchar2, p_object in varchar2 )
return varchar2
as
begin
	return 'x > sys_context(''myctx'',''x'')';
end;
/

set serveroutput on
 
exec set_ctx( NULL )

exec dump_t

exec set_ctx( 1 )

exec dump_t( 0 )
