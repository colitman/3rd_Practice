set echo on


create or replace procedure show_emps
as
begin
    for x in ( select ename, empno
                 from emp 
                where empno > 0 )
    loop
        dbms_output.put_line( x.empno || ',' || x.ename );
    end loop;
end;
/

alter session set sql_trace=true;
exec show_emps

@gettrace

exit
