declare
    l_rows    number;
begin
    l_rows := unloader.run
              ( p_query      => 'select EMPNO, ENAME EMP_NAME,
                                        JOB , MGR, HIREDATE,
                                        SAL, COMM, DEPTNO
                                   from emp
                                  order by empno',
                p_tname      => 'emp',
                p_mode       => 'TRUNCATE',
                p_dir        => 'c:\temp',
                p_filename   => 'emp',
                p_separator  => ',',
                p_enclosure  => '"',
                p_terminator => '~' );

    dbms_output.put_line( to_char(l_rows) ||
                          ' rows extracted to ascii file' );
end;
/
truncate table emp;
alter table emp drop column ename;
alter table emp add emp_name varchar2(10);
host sqlldr userid=tkyte/tkyte control=c:\temp\emp.ctl
desc emp
select emp_name from emp;

