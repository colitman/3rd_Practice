set echo on

@connect scott/tiger

exec dbms_application_info.set_client_info('KING');

select userenv('CLIENT_INFO') from dual;

select sys_context('userenv','client_info') from dual;

create or replace view
emp_view
as
select ename, empno
  from emp
 where ename = sys_context( 'userenv', 'client_info');

select * from emp_view;

exec dbms_application_info.set_client_info('BLAKE');

select * from emp_view;
