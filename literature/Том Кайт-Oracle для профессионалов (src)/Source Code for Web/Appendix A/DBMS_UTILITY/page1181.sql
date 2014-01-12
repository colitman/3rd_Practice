set echo on

create or replace procedure p1
as
    l_owner     varchar2(30);
    l_name      varchar2(30);
    l_lineno    number;
    l_type      varchar2(30);
begin
    dbms_output.put_line( '----------------------' );
    dbms_output.put_line( dbms_utility.format_call_stack );
    dbms_output.put_line( '----------------------' );
    who_called_me( l_owner, l_name, l_lineno, l_type );
    dbms_output.put_line( l_type || ' ' ||
                          l_owner || '.' || l_name ||
                          '(' || l_lineno || ')' );
    dbms_output.put_line( '----------------------' );
    dbms_output.put_line( who_am_i );
    dbms_output.put_line( '----------------------' );
    raise program_error;
end;
/

exec p3