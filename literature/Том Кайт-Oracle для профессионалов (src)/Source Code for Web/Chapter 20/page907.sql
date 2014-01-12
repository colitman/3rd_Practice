drop table dept_fy_budget;

create table dept_fy_budget
( deptno   number(2) references dept,
  fy       date,
  amount   number,
  constraint dept_fy_budget_pk primary key(deptno,fy)
)
/
insert into dept_fy_budget values
( 10, to_date( '01-jan-1999' ), 500 );
insert into dept_fy_budget values
( 10, to_date( '01-jan-2000' ), 750 );
insert into dept_fy_budget values
( 10, to_date( '01-jan-2001' ), 1000 );


select dept.*, empno, ename, job, mgr, hiredate, sal, comm
from emp, dept
where emp.deptno = dept.deptno
and dept.deptno = 10
/

select fy, amount
from dept_fy_budget
where deptno = 10
/

select 
	dept.deptno, dept.dname, 
	cursor(select empno from emp where deptno = dept.deptno),
	cursor(select fy, amount from dept_fy_budget where deptno = dept.deptno)
from dept
where deptno = 10
/
