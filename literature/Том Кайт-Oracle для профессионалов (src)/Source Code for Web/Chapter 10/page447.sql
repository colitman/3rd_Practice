
declare
    l_theCursor     integer default dbms_sql.open_cursor;
    l_descTbl       dbms_sql.desc_tab;
    l_colCnt        number;
begin
    execute immediate 'alter session set cursor_sharing=exact';
    dbms_output.put_line( 'Without Cursor Sharing:' );
    for i in 1 .. 2
    loop
        dbms_sql.parse(  l_theCursor,
                        'select substr( object_name, 1, 5 ) c1,
                                55 c2,
                               ''Hello'' c3
                          from all_objects t'||i,
                        dbms_sql.native );

        dbms_sql.describe_columns( l_theCursor,
                                       l_colCnt, l_descTbl );
 
        for i in 1 .. l_colCnt loop
            dbms_output.put_line( 'Column ' ||
                                  l_descTbl(i).col_name ||
                                  ' has a length of ' ||
                                  l_descTbl(i).col_max_len ) ;
        end loop;
        execute immediate 'alter session set cursor_sharing=force';
        dbms_output.put_line( 'With Cursor Sharing:' );
    end loop;

    dbms_sql.close_cursor(l_theCursor);
    execute immediate 'alter session set cursor_sharing=exact';
end;
/

