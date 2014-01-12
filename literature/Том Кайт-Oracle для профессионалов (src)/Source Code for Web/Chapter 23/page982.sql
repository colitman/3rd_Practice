@connect tkyte/tkyte
set echo on

create or replace procedure definer_proc
as
begin
    for x in 
    ( select sys_context( 'userenv', 'current_user' ) current_user, 
             sys_context( 'userenv', 'session_user' ) session_user,
             sys_context( 'userenv', 'current_schema' ) current_schema
        from dual )
    loop
        dbms_output.put_line( 'Current User:   ' || x.current_user );
        dbms_output.put_line( 'Session User:   ' || x.session_user );
        dbms_output.put_line( 'Current Schema: ' || x.current_schema );
    end loop;    
end;
/

grant execute on definer_proc to scott;

create or replace procedure invoker_proc
AUTHID CURRENT_USER
as
begin
    for x in 
    ( select sys_context( 'userenv', 'current_user' ) current_user, 
             sys_context( 'userenv', 'session_user' ) session_user,
             sys_context( 'userenv', 'current_schema' ) current_schema
        from dual )
    loop
        dbms_output.put_line( 'Current User:   ' || x.current_user );
        dbms_output.put_line( 'Session User:   ' || x.session_user );
        dbms_output.put_line( 'Current Schema: ' || x.current_schema );
    end loop;    
end;
/

grant execute on invoker_proc to scott;

@connect scott/tiger

set serveroutput on
exec tkyte.definer_proc
exec tkyte.invoker_proc
alter session set current_schema = system;
exec tkyte.definer_proc
exec tkyte.invoker_proc
