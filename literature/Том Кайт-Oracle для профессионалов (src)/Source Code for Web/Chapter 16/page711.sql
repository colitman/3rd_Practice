set echo on

create or replace package my_pkg
as
    type refcursor_Type is ref cursor;

    procedure get_emps( p_ename  in varchar2 default NULL,
                        p_deptno in varchar2 default NULL,
                        p_cursor in out refcursor_type );
end;
/

create or replace package body my_pkg
as
    procedure get_emps( p_ename  in varchar2 default NULL,
                        p_deptno in varchar2 default NULL,
                        p_cursor in out refcursor_type )
    is
        l_query long;
        l_bind  varchar2(30);
    begin
        l_query := 'select deptno, ename, job from emp';

        if ( p_ename is not NULL ) 
        then
            l_query := l_query || ' where ename like :x';
            l_bind := '%' || upper(p_ename) || '%';
        elsif ( p_deptno is not NULL ) 
        then
            l_query := l_query || ' where deptno = to_number(:x)';
            l_bind := p_deptno;
        else
            raise_application_error( -20001, 'Missing search criteria' );
        end if;

        open p_cursor for l_query using l_bind;
    end;
end;
/

variable C refcursor
set autoprint on
exec my_pkg.get_emps( p_ename =>  'a', p_cursor => :C )
exec my_pkg.get_emps( p_deptno=> '10', p_cursor => :C )