set echo on

@connect tkyte/tkyte


create or replace function rls_examp
( p_schema in varchar2, p_object in varchar2 )
return varchar2
as
	l_uid number;
begin
	select user_id
	  into l_uid
	  from all_users
	 where username = 'SOME_USER_WHO_DOESNT_EXIST';

    return 'x > sys_context(''myctx'',''x'')';
end;
/

exec set_ctx( 0 ) ;
select * from t;

@gettrace
