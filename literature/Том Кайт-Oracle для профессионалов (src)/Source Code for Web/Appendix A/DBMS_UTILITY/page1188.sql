set echo on

declare
    l_a      varchar2(30);
    l_b      varchar2(30);
    l_c      varchar2(30);
    l_dblink varchar2(30);
    l_next   number;

    type vcArray is table of varchar2(255);
    l_names vcArray :=
        vcArray( 'owner.pkg.proc@database_link',
                 'owner.tbl@database_link',
                 'tbl',
                 '"Owner".tbl',
                 'pkg.proc',
                 'owner.pkg.proc',
                 'proc',
                 'owner.pkg.proc@dblink with junk',
                 '123' );
begin
    for i in 1 .. l_names.count
    loop
    begin
        dbms_utility.name_tokenize(name   => l_names(i),
                                   a      => l_a,
                                   b      => l_b,
                                   c      => l_c,
                                   dblink => l_dblink,
                                   nextpos=> l_next );

        dbms_output.put_line( 'name    ' || l_names(i) );
        dbms_output.put_line( 'A       ' || l_a );
        dbms_output.put_line( 'B       ' || l_b );
        dbms_output.put_line( 'C       ' || l_c );
        dbms_output.put_line( 'dblink  ' || l_dblink );
        dbms_output.put_line( 'next    ' || l_next || ' ' ||
                                length(l_names(i)));
        dbms_output.put_line( '-----------------------' );
    exception
        when others then
            dbms_output.put_line( 'name    ' || l_names(i) );
            dbms_output.put_line( sqlerrm );
    end;
    end loop;
end;
/
