@connect scott/tiger
grant select on emp to public;

revoke select on emp from public;
grant select on emp to connect;

@connect tkyte/tkyte
grant create procedure to another_user;

@connect another_user/another_user
select count(*) from scott.emp;

begin
  for x in ( select count(*) cnt from scott.emp )
  loop
        dbms_output.put_line( x.cnt );
  end loop;
end;
/

create or replace procedure P
as
begin
  for x in ( select count(*) cnt from scott.emp )
  loop
        dbms_output.put_line( x.cnt );
  end loop;
end;
/

show err

set role none;
select count(*) from scott.emp;

