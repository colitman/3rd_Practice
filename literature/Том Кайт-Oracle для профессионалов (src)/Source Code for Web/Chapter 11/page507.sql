drop table emp;


set echo on

create table emp
as
select ename, empno from scott.emp group by ename, empno
/

alter table emp 
add constraint emp_pk
primary key(empno)
/

alter session set optimizer_goal=choose
/
set autotrace traceonly explain
select empno, ename from emp where empno > 0
/
set autotrace off

create or replace outline MyOutline
for category mycategory
ON
select empno, ename from emp where empno > 0
/


analyze table emp compute statistics 
/

set autotrace traceonly explain
select empno, ename from emp where empno > 0
/
set autotrace off

alter session set use_stored_outlines = mycategory
/
set autotrace traceonly explain
select empno, ename from emp where empno > 0
/
set autotrace off
