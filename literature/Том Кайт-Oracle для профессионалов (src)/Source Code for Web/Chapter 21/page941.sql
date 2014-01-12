set echo on

drop table c;
drop table p;

create table p ( x int primary key );

create table c ( x int references p on delete cascade );

create or replace function pred_function
( p_schema in varchar2, p_object in varchar2 )
return varchar2
as
begin
	return '1=0';
end;
/

begin
   dbms_rls.add_policy
   ( object_name => 'P',
    policy_name => 'P_POLICY',
     policy_function => 'pred_function',
     statement_types => 'select' );
end;
/

insert into c values ( 1 );
insert into p values ( 1 );
insert into c values ( 1 );
insert into c values ( 2 );
select * from p;
select * from c;

begin
  dbms_rls.drop_policy
  ( 'mankee', 'P', 'P_POLICY' );
end;
/

begin
   dbms_rls.add_policy
   ( object_name => 'C',
     policy_name => 'C_POLICY',
     policy_function => 'pred_function',
     statement_types => 'SELECT, DELETE' );
end;
/

delete from C;
select * from C;
delete from P;
select * from C;

drop table c;

create table c ( x int references p on delete set null );

insert into p values ( 1 );
insert into c values ( 1 );

begin
   dbms_rls.add_policy
   ( object_name => 'C',
     policy_name => 'C_POLICY',
     policy_function => 'pred_function',
     statement_types => 'UPDATE',
	 update_check => TRUE );
end;
/

update c set x = NULL;
select * from c;
delete from p;
select * from c;

delete from c;
insert into p values ( 1 );
insert into c values ( 1 );

create or replace function pred_function
( p_schema in varchar2, p_object in varchar2 )
return varchar2
as
begin
	return 'x is not null';
end;
/

update c set x = NULL;
select * from c;
delete from p;
select * from c;