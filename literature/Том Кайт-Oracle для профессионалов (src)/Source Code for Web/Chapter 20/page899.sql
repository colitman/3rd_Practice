column emps format a40

select dname, d.emps
  from dept_or d
/

select deptno, dname, loc, count(*)
  from dept_or d, table ( d.emps )
 group by deptno, dname, loc
/

