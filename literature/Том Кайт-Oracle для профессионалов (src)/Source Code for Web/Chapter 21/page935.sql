@su tkyte


create or replace package hr_app
as
    procedure listEmps;

    procedure updateSal;

    procedure deleteAll;

    procedure insertNew( p_deptno in number );
end;
/


create or replace package body hr_app
as

procedure listEmps
as
    l_cnt number default 0;
begin
    dbms_output.put_line
    ( rpad('ename',10) || rpad('sal', 6 )  || ' ' ||
      rpad('dname',10) || rpad('mgr',5) || ' ' ||
      rpad('dno',3) );
    for x in ( select ename, sal, dname, mgr, emp.deptno
                 from emp, dept
                where emp.deptno = dept.deptno )
    loop
        dbms_output.put_line( rpad(nvl(x.ename,'(null)'),10) || 
                              to_char(x.sal,'9,999') || ' ' ||
                              rpad(x.dname,10) ||
                              to_char(x.mgr,'9999') || ' ' ||
                              to_char(x.deptno,'99') );
        l_cnt := l_cnt + 1;
    end loop;
    dbms_output.put_line( l_cnt || ' rows selected' );
end;


procedure updateSal
is
begin
    update emp set sal = 9999;
    dbms_output.put_line( sql%rowcount || ' rows updated' );
end;

procedure deleteAll
is
begin
    delete from emp where empno <> sys_context('Hr_app_Ctx','EMPNO' );
    dbms_output.put_line( sql%rowcount || ' rows deleted' );
end;

procedure insertNew( p_deptno in number )
as
begin
    insert into emp (empno, deptno, sal) values (123, p_deptno, 1111);
end;

end hr_app;
/


grant execute on hr_app to public
/
