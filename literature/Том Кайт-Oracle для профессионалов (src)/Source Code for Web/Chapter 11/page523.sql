@su scott

set echo on

set autotrace traceonly explain

select * from emp, dept where emp.deptno = dept.deptno;

select *
  from ( select /*+ use_hash(emp) */ * from emp ) emp,
       ( select /*+ use_hash(dept) */ * from dept ) dept
where emp.deptno = dept.deptno
/

set autotrace off


grant select on emp to tkyte;
grant select on dept to tkyte;

set echo off
@su tkyte
set echo on

drop table emp;
drop table dept;
drop view emp;
drop view dept;

create or replace view emp as
select /*+ use_hash(emp) */ * from scott.emp emp
/
create or replace view dept as
select /*+ use_hash(dept) */  * from scott.dept dept
/

create or replace outline my_outline
for category my_category
on select * from emp, dept where emp.deptno = dept.deptno;


set echo off
@su scott
set echo on

alter session set use_stored_outlines=my_category;
set autotrace traceonly explain
select * from emp, dept where emp.deptno = dept.deptno;
set autotrace off
