set sqlprompt "SQL> "
set echo on
set serveroutput on

declare
    l_input    number;
    l_output number;
begin
    dbms_output.put_line( 'Pass Number' );

    dbms_output.put_line( 'first test passing nulls to see that works' );
    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );

    l_input := 123;
    dbms_output.put_line( 'Now test passing non-nulls to see that works' );
    dbms_output.put_line( 'We expect the output to be -123' );
    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );
end;
/

pause

declare
    l_input date;
    l_output date;
begin
    dbms_output.put_line( 'Pass date' );

    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );

    l_input := sysdate;
    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );
end;
/


declare
    l_input varchar2(255);
    l_output varchar2(255);
    l_sm_output varchar2(1);
begin
    dbms_output.put_line( 'Pass Str' );

    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );

    l_input := 'Hello World';
    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );

    begin
        demo_passing_pkg.pass( l_input, l_sm_output );
        dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );
    exception
        when others then
            dbms_output.put_line( 'Caught expected exception' );
            dbms_output.put_line( sqlerrm );
    end;
end;
/


declare
    l_input binary_integer;
    l_output binary_integer;
begin
    dbms_output.put_line( 'Pass Int' );

    demo_passing_pkg.pass_int( l_input, l_output );
    dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );

    l_input := 456;
    demo_passing_pkg.pass_int( l_input, l_output );
    dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );
end;
/

declare
    l_input boolean;
    l_output boolean;
    function str(x in boolean) return varchar2
    is
    begin
        if (x) then return 'TRUE';
        elsif(NOT x) then return 'FALSE';
        else return 'NULL';
        end if;
    end;
begin
    dbms_output.put_line( 'Pass Bool' );

    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = ' || str(l_input) || ' l_output = ' || str(l_output) );

    l_input := TRUE;
    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = ' || str(l_input) || ' l_output = ' || str(l_output) );

    l_input := FALSE;
    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = ' || str(l_input) || ' l_output = ' || str(l_output) );
end;
/


declare
    l_input    raw(32760);
    l_output raw(32760);
    l_sm_output raw(4096);
begin
    dbms_output.put_line( 'Pass Raw' );

    demo_passing_pkg.pass_raw( l_input, l_output );
    dbms_output.put_line( 'l_input = '||l_input||' l_output = '||l_output );

    l_input := utl_raw.cast_to_raw( rpad( '*', 32760, '*' ) );
    demo_passing_pkg.pass_raw( l_input, l_output );
    dbms_output.put_line( 'l_input = ' || utl_raw.length(l_input) || ' l_output = ' || utl_raw.length(l_output) );
    if ( l_input <> l_output ) then
        raise program_error;
    end if;

    begin
        demo_passing_pkg.pass_raw( l_input, l_sm_output );
    exception
        when others then 
            dbms_output.put_line( 'Caught expected exception' );
            dbms_output.put_line( sqlerrm );
    end;
end;
/

declare
    l_input      clob;
    l_output  clob;
    l_temp    varchar2(20000);
begin
    dbms_output.put_line( 'Pass Clob' );

    dbms_lob.createtemporary( l_input, TRUE );
    dbms_lob.createtemporary( l_output, TRUE );

    l_temp := rpad( '*', 20000, '*' );
    for i in 1 .. 100 loop
        dbms_lob.writeappend( l_input, length(l_temp), l_temp );
    end loop;


    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input = ' || dbms_lob.getlength(l_input) || 
                          ' l_output = ' || dbms_lob.getlength(l_output) );

    dbms_output.put_line( 'compare = ' || dbms_lob.compare( l_input, l_output ) );
end;
/


declare
    l_input   dateArray := dateArray();
    l_output  dateArray := dateArray();
begin
    dbms_output.put_line( 'Pass dateArray' );
    for i in 1 .. 100 loop
        l_input.extend;
        l_input(i) := sysdate+i;
    end loop;
    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input.count = ' || l_input.count ||
                          ' l_output.count = ' || l_output.count );
    for i in 1 .. l_input.count loop
        if ( l_input(i) != l_output(i) ) then
            raise program_error;
        end if;
    end loop;
end;
/


declare
    l_input   numArray := numArray();
    l_output  numArray := numArray();
begin
    dbms_output.put_line( 'Pass numArray' );
    for i in 1 .. 100 loop
        l_input.extend;
        l_input(i) := i;
    end loop;
    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input.count = ' || l_input.count ||
                          ' l_output.count = ' || l_output.count );
    for i in 1 .. l_input.count loop
        if ( l_input(i) != l_output(i) ) then
            raise program_error;
        end if;
    end loop;
end;
/


declare
    l_input   strArray := strArray();
    l_output  strArray := strArray();
begin
    dbms_output.put_line( 'Pass strArray' );
    for i in 1 .. 100 loop
        l_input.extend;
        l_input(i) := 'Element ' || i;
    end loop;
    demo_passing_pkg.pass( l_input, l_output );
    dbms_output.put_line( 'l_input.count = ' || l_input.count ||
                          ' l_output.count = ' || l_output.count );
    for i in 1 .. l_input.count loop
        if ( l_input(i) != l_output(i) ) then
            raise program_error;
        end if;
    end loop;
end;
/

exec dbms_output.put_line( 'Calling return number =' || demo_passing_pkg.return_number );
exec dbms_output.put_line( 'Calling return date   =' || demo_passing_pkg.return_date );
exec dbms_output.put_line( 'Calling return string =' || demo_passing_pkg.return_string );
