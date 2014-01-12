@connect scott/tiger
set echo on

create or replace
procedure emp_report
as
begin
    dbms_output.put_line
    ( rpad( 'Empno', 7 ) ||
      rpad('Ename',12) ||
      rpad('Job',11) );

    dbms_output.put_line
    ( rpad( '-', 5, '-' ) ||
      rpad('  -',12,'-') ||
      rpad('  -',11,'-') );

    for x in ( select * from emp )
    loop
        dbms_output.put_line
        ( to_char( x.empno, '9999' ) || '  ' ||
          rpad( x.ename, 12 ) ||
          rpad( x.job, 11 ) );
    end loop;
end;
/

set serveroutput on format wrapped
exec emp_report