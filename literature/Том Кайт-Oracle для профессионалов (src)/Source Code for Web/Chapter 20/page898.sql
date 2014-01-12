create or replace type emp_type
as object
(empno       number(4),
 ename       varchar2(10),
 job         varchar2(9),
 mgr         number(4),
 hiredate    date,
 sal         number(7, 2),
 comm        number(7, 2)
);
/


create or replace type emp_tab_type
as table of emp_type
/


create or replace type dept_type
as object
( deptno number(2),
  dname  varchar2(14),
  loc    varchar2(13),
  emps   emp_tab_type
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
              as emp_tab_type )
  from dept
/

