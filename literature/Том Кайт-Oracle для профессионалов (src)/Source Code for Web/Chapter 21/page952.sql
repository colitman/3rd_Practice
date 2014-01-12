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

begin
   dbms_rls.drop_policy( 'TKYTE', 'T', 'T_POLICY' );
end;
/

begin
   dbms_rls.add_policy
   ( object_name => 'T',
     policy_name => 'T_POLICY',
     policy_function => 'rls_examp',
     statement_types => 'select, insert',
	 update_check    => TRUE );
end;
/

delete from t;
commit;

exec set_ctx( null );

insert into t values ( 1 );

exec set_ctx( 0 ) ;

insert into t values ( 1 );
