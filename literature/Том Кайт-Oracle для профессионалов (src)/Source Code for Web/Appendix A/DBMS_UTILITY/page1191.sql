set echo on

declare
    type vcArray is table of varchar2(4000);

    l_names  vcArray := vcArray( 'emp,dept,bonus',
                                 'a,  b  ,   c',
                                 '123, 456, 789',
                                 '"123", "456", "789"',
         '"This is a long string, longer than 32 characters","b",c');
    l_tablen number;
    l_tab    dbms_utility.uncl_array;
begin
    for i in 1 .. l_names.count
    loop
        dbms_output.put_line( chr(10) ||
                              '[' || l_names(i) || ']' );
    begin

        dbms_utility.comma_to_table( l_names(i),
                                     l_tablen, l_tab );

        for j in 1..l_tablen
        loop
            dbms_output.put_line( '[' || l_tab(j) || ']' );
        end loop;

        l_names(i) := null;
        dbms_utility.table_to_comma( l_tab,
                                     l_tablen, l_names(i) );
        dbms_output.put_line( l_names(i) );
    exception
        when others then
            dbms_output.put_line( sqlerrm );
    end;
    end loop;
end;
/