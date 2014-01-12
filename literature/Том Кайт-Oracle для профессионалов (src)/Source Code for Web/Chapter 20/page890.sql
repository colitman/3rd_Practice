declare
    f fileType := fileType.open( 'c:\temp', 'foo.txt', 'w' );
begin
    if ( f.isOpen )
    then
        dbms_output.put_line( 'File is OPEN' );
    end if;

    for i in 1 .. 10 loop
        f.put( i || ',' );
    end loop;
    f.put_line( 11 );

    f.new_line( 5 );
    for i in 1 .. 5
    loop
        f.put_line( 'line ' || i );
    end loop;

    f.putf( '%s %s', 'Hello', 'World' );

    f.flush;

    f.close;
end;
/

declare
    f fileType := fileType.open( 'c:\temp', 'foo.txt' );
begin
    if ( f.isOpen )
    then
        dbms_output.put_line( 'File is OPEN' );
    end if;

    dbms_output.put_line
    ( 'line 1: (should be 1,2,...,11)' || f.get_line );

    for i in 2 .. 6
    loop
        dbms_output.put_line
        ( 'line ' || i || ': (should be blank)' || f.get_line);
    end loop;

    for i in 7 .. 11
    loop
        dbms_output.put_line
        ( 'line ' || to_char(i+1) ||
          ': (should be line N)' || f.get_line);
    end loop;

    dbms_output.put_line
    ( 'line 12: (should be Hello World)' || f.get_line);

    begin
        dbms_output.put_line( f.get_line );
        dbms_output.put_line( 'the above is an error' );
    exception
        when NO_DATA_FOUND then
            dbms_output.put_line( 'got a no data found as expected' );
    end;
    f.close;
end;
/

