set echo on

@su tkyte
drop user demo_ddl cascade;


create user demo_ddl identified by demo_ddl;

grant connect, resource to demo_ddl with admin option;

grant create user to demo_ddl;
grant drop user to demo_ddl;

@connect demo_ddl/demo_ddl


create table application_users_tbl
( uname         varchar2(30) primary key,
  pw            varchar2(30),
  role_to_grant varchar2(4000)
);

@wcm

create or replace trigger application_users_tbl_bid
before insert or delete on application_users_tbl
begin
    if ( my_caller not in ( 'DEMO_DDL.APPLICATION_USERS_IOI',
                            'DEMO_DDL.APPLICATION_USERS_IOD' ) )
    then
      raise_application_error(-20001, 'Cannot insert/delete directly');
    end if;
end;
/


create or replace view
application_users
as
select * from application_users_tbl
/

 
create or replace trigger application_users_IOI
instead of insert on application_users
declare
  pragma   autonomous_transaction;
begin
  insert into application_users_tbl
  ( uname, pw, role_to_grant )
  values
  ( upper(:new.uname), :new.pw, :new.role_to_grant );

  begin
    execute immediate
      'grant ' || :new.role_to_grant ||
      ' to ' || :new.uname ||
      ' identified by ' || :new.pw;
  exception
    when others then
        delete from application_users_tbl
         where uname = upper(:new.uname);
        commit;
        raise;
  end;
end;
/

create or replace trigger application_users_IOD
instead of delete on application_users
declare
  pragma   autonomous_transaction;
begin
     execute immediate 'drop user ' || :old.uname;
     delete from application_users_tbl
      where uname = :old.uname;
     commit;
end;
/



select * from all_users where username = 'NEW_USER';

insert into application_users values
( 'new_user', 'pw', 'connect, resource' );

select * from all_users where username = 'NEW_USER';

delete from application_users where uname = 'NEW_USER';

select * from all_users where username = 'NEW_USER';


insert into application_users_tbl values
( 'new_user', 'pw', 'connect, resource' );

delete from application_users_tbl;
