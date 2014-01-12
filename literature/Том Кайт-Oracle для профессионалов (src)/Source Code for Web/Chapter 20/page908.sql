create or replace type dept_budget_type
as object
( fy        date,
  amount number
)
/

create or replace type dept_budget_tab_type
as table of dept_budget_type
/

create or replace type dept_type
as object
( deptno number(2),
  dname  varchar2(14),
  loc       varchar2(13),
  emps      emp_tab_type,
  budget dept_budget_tab_type
)
/

create or replace view dept_or
of dept_type
with object identifier(deptno)
as
select deptno, dname, loc,
       cast ( multiset (
               select empno, ename, job, mgr, hiredate, sal, comm
                 from emp
                where emp.deptno = dept.deptno )
              as emp_tab_type ) emps,
       cast ( multiset (
               select fy, amount
                 from dept_fy_budget
                where dept_fy_budget.deptno = dept.deptno )
              as dept_budget_tab_type ) budget
  from dept
/

select * from dept_or where deptno = 10
/


select 
	dept.deptno, dept.dname, 
	cursor(select empno from emp where deptno = dept.deptno),
	cursor(select fy, amount from dept_fy_budget where deptno = dept.deptno)
from dept
where deptno = 10
/
