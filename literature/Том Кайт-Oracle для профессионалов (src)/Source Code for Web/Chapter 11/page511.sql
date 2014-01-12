set serveroutput on

set echo on
exec outln_pkg.drop_by_cat( 'HR_APPLICATION' );
alter system flush shared_pool;


alter session set optimizer_goal=CHOOSE;
alter session set create_stored_outlines = hr_application;
exec show_emps
alter session set create_stored_outlines = FALSE;

column sql_text format a47 word_wrapped
column name new_value OUTLINE_NAME
select name, sql_text 
  from user_outlines
 where category = 'HR_APPLICATION'
/


alter session set optimizer_goal=first_rows
/
set autotrace traceonly explain
SELECT ENAME,EMPNO   FROM EMP  WHERE EMPNO > 0;
set autotrace off

alter outline &OUTLINE_NAME rebuild
/

alter system flush shared_pool;
alter session set optimizer_goal=CHOOSE;
alter session set USE_STORED_OUTLINES = hr_application;
alter session set sql_trace=true;
exec show_emps

@gettrace

exit
