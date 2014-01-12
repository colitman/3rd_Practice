create or replace procedure emp_dept_rpt
AUTHID CURRENT_USER
as
begin
  dbms_output.put_line( 'Salaries and Employee Count by Deptno' );
  dbms_output.put_line( chr(9)||'Deptno   Salary   Count' );
  dbms_output.put_line( chr(9)||'------   ------   ------' );
  for x in ( select dept.deptno, sum(sal) sal, count(*) cnt
          from emp, dept
         where dept.deptno = emp.deptno
         group by dept.deptno )
  loop
      dbms_output.put_line( chr(9) ||
             to_char(x.deptno,'99999') || ' ' ||
             to_char(x.sal,'99,999') || ' ' ||
             to_char(x.cnt,'99,999') );
  end loop;
  dbms_output.put_line( '=====================================' );
end;
/

grant execute on emp_dept_rpt to public
/

set serveroutput on format wrapped
exec emp_dept_rpt;

@connect scott/tiger

set serveroutput on format wrapped
exec application.emp_dept_rpt

@connect tkyte/tkyte

set serveroutput on format wrapped
exec application.emp_dept_rpt
