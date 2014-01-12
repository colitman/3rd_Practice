set echo on

REM SCOTT must have GRANT CREATE ANY CONTEXT TO SCOTT;
REM or a role with that for this to work.
create or replace context bv_context using dyn_demo
/

create or replace package body dyn_demo
as

procedure do_query( p_cnames    in array,
                    p_operators in array,
                    p_values    in array )
is
    type rc is ref cursor;

    l_query      long;
    l_sep        varchar2(20) default ' where ';
    l_cursor     rc;
    l_ename      emp.ename%type;
    l_empno      emp.empno%type;
    l_job        emp.job%type;
begin
    /*
     * This is our constant SELECT list - we'll always
     * get these three columns. The predicate is what
     * changes.
     */
    l_query := 'select ename, empno, job from emp';

    for i in 1 .. p_cnames.count loop
        l_query := l_query || l_sep ||
                   p_cnames(i) || ' ' ||
                   p_operators(i) || ' ' ||
                   'sys_context( ''BV_CONTEXT'', ''' ||
                                   p_cnames(i) || ''' )';
        l_sep := ' and ';
        dbms_session.set_context( 'bv_context',
                                   p_cnames(i),
                                   p_values(i) );
    end loop;

    open l_cursor for l_query;
    loop
        fetch l_cursor into l_ename, l_empno, l_job;
        exit when l_cursor%notfound;
        dbms_output.put_line( l_ename ||','|| l_empno ||','|| l_job );
    end loop;
    close l_cursor;
end;

end dyn_demo;
/

set serveroutput on
begin
     dyn_demo.do_query( dyn_demo.array( 'ename', 'job' ),
                        dyn_demo.array( 'like',  '=' ),
                        dyn_demo.array( '%A%',   'CLERK' ) );
end;
/