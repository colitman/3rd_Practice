@su tkyte

set echo on

create or replace
function security_policy_function( p_schema in varchar2,
               p_object in varchar2 )
return varchar2
as
begin
  if ( user = p_schema ) then
        return '';
    else
        return 'owner = USER';
    end if;
end;
/

drop table data_table;

create table data_table
(   some_data   varchar2(30),
    OWNER       varchar2(30) default USER
)
/

grant all on data_table to public;

create public synonym data_table for data_table;

insert into data_table ( some_data ) values ( 'Some Data' );

insert into data_table ( some_data, owner )
values ( 'Some Data Owned by SCOTT', 'SCOTT' );

commit;

select * from data_table;

begin
  dbms_rls.add_policy
   ( object_schema   => 'TKYTE',
     object_name     => 'data_table',
     policy_name     => 'MY_POLICY',
     function_schema => 'TKYTE',
     policy_function => 'security_policy_function',
     statement_types => 'select, insert, update, delete' ,
     update_check    => TRUE,
     enable          => TRUE
   );
end;
/

@connect system/manager
select * from data_table;

@connect scott/tiger
select * from data_table;

@connect scott/tiger

insert into data_table ( some_data )
values ( 'Some New Data' );

insert into data_table ( some_data, owner )
values ( 'Some New Data Owned by SYS', 'SYS' )
/

select * from data_table;

@connect tkyte/tkyte

insert into data_table ( some_data, owner )
values ( 'Some New Data Owned by SYS', 'SYS' )
/

select * from data_table
/

@connect sys/manager
select * from data_table;