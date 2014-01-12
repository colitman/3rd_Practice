set echo on

@connect tkyte/tkyte

create or replace function rls_examp
( p_schema in varchar2, p_object in varchar2 )
return varchar2
as
begin
    this is an error
    return 'x > sys_context(''myctx'',''x'')';
end;
/

exec set_ctx( 0 ) ;
select * from t;

column pf_owner format a10
column package format a10
column function format a10
select pf_owner, package, function
  from user_policies a
 where exists ( select null
                  from all_objects
                 where owner = pf_owner
                   and object_type in ( 'FUNCTION', 'PACKAGE',
                                        'PACKAGE BODY' )
                   and status = 'INVALID'
                  and object_name in ( a.package, a.function ) 
              )
/

show errors function rls_examp