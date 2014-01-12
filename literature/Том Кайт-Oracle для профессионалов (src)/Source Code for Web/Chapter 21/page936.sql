set echo on

@connect adams/adams

column namespace format a10
column attribute format a10
column value     format a10
select * from session_context;

set serveroutput on
exec tkyte.hr_app.listEmps
exec tkyte.hr_app.updateSal
exec tkyte.hr_app.deleteAll
exec tkyte.hr_app.insertNew(20);
rollback;
