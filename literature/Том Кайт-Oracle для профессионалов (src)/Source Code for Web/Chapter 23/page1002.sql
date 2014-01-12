@connect tkyte/tkyte


drop user a cascade;

drop user b cascade;

create user a identified by a default tablespace data temporary tablespace temp;
grant connect, resource to a;

create user b identified by b default tablespace data temporary tablespace temp;
grant connect, resource to b;

@connect a/a

create table t ( x varchar2(255) );

insert into t values ( 'A''s table' );

create function Invoker_rights_function return varchar2
AUTHID CURRENT_USER
as
	l_data varchar2(4000);
begin
   dbms_output.put_line( 'I am an IR PROC owned by A' );
   select 'current_user=' || 
	       sys_context( 'userenv', 'current_user' ) ||
          ' current_schema=' ||   
		   sys_context( 'userenv', 'current_schema' ) ||
		  ' active roles=' || cnt || 
          ' data from T=' || t.x
       into l_data
	   from (select count(*) cnt from session_roles), t;

   return l_data;
end;
/

grant execute on Invoker_rights_function to public;

create procedure Definer_rights_procedure
as
	l_data varchar2(4000);
begin
   dbms_output.put_line( 'I am a DR PROC owned by A' );
   select 'current_user=' || 
	       sys_context( 'userenv', 'current_user' ) ||
          ' current_schema=' ||   
		   sys_context( 'userenv', 'current_schema' ) ||
		  ' active roles=' || cnt || 
          ' data from T=' || t.x
       into l_data
	   from (select count(*) cnt from session_roles), t;

   dbms_output.put_line( l_data );
   dbms_output.put_line( 'Going to call the INVOKER rights procedure now...' );
   dbms_output.put_line( Invoker_rights_function );
end;
/

grant execute on Definer_rights_procedure to public;

create view V
as
select invoker_rights_function from dual
/

grant select on v to public
/

@connect b/b

create table t ( x varchar2(255) );

insert into t values ( 'B''s table' );

exec dbms_output.put_line( a.Invoker_rights_function )
exec a.Definer_rights_procedure
select a.invoker_rights_function from dual;
select * from a.v;

alter session set current_schema=system;
exec dbms_output.put_line( a.Invoker_rights_function )
exec a.Definer_rights_procedure
