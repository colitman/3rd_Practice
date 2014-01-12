set echo on

create or replace
procedure  dump_query( p_query in varchar2 )
is
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_colCnt        number default 0;
    l_cnt           number default 0;
    l_line          long;

    /* We'll be using this to see how many columns
     * we have to fetch so we can define them and
     * then retrieve their values.
     */
    l_descTbl       dbms_sql.desc_tab;


    /* Step 1 - open cursor. */
    l_theCursor     integer default dbms_sql.open_cursor;
begin

    /* Step 2 - parse the input query so we can describe it. */
    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );

    /* Step 3 - now, describe the outputs of the query. */
    dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );

    /* Step 4 - we do not use in this example, no BINDING needed.
     * Step 5 - for each column, we need to define it, tell the database
     * what we will fetch into. In this case, all data is going
     * to be fetched into a single varchar2(4000) variable.
     */
    for i in 1 .. l_colCnt 
    loop
        dbms_sql.define_column( l_theCursor, i, l_columnValue, 4000 );
     end loop;

    /* Step 6 - execute the statement. */
    l_status := dbms_sql.execute(l_theCursor);

    /* Step 7 - fetch all rows. */
    while ( dbms_sql.fetch_rows(l_theCursor) > 0 )
    loop
        /* Build up a big output line, this is more efficient than calling
         * DBMS_OUTPUT.PUT_LINE inside the loop.
         */
        l_cnt := l_cnt+1;
        l_line := l_cnt;
        /* Step 8 - get and process the column data. */
        for i in 1 .. l_colCnt loop
            dbms_sql.column_value( l_theCursor, i, l_columnValue );
            l_line := l_line || ',' || l_columnValue;
        end loop;

        /* Now print out this line. */
        dbms_output.put_line( l_line );
    end loop;

    /* Step 9 - close cursor to free up resources.. */
    dbms_sql.close_cursor(l_theCursor);
exception
    when others then 
        dbms_sql.close_cursor( l_theCursor );
        raise;
end dump_query;
/

set serveroutput on
exec dump_query( 'select rowid, empno, ename from emp' );
exec dump_query( 'select * from dept' );