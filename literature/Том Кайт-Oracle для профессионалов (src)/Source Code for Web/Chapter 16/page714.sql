set echo on

create or replace package dyn_demo
as
    type array is table of varchar2(2000);


    /*
     * DO_QUERY will dynamically query the emp
     * table and process the results. You might
     * call it like this:
     *
     * dyn_demo.do_query( array( 'ename', 'job' ),
                          array( 'like',  '=' ),
                          array( '%A%',   'CLERK' ) );
     *
     * to have it query up:
     *
     * select * from emp where ename like '%A%' and job = 'CLERK'
     *
     * for example.
     */
    procedure do_query( p_cnames    in array,
                        p_operators in array,
                        p_values    in array );

end;
/

create or replace package body dyn_demo
as

/*
 * DBMS_SQL-based implementation of dynamic
 * query with unknown bind variables
 */
g_cursor int default dbms_sql.open_cursor;


procedure do_query( p_cnames       in array,
                    p_operators in array,
                    p_values    in array )
is
    l_query     long;
    l_sep       varchar2(20) default ' where ';
    l_comma     varchar2(1) default '';
    l_status    int;
    l_colValue  varchar2(4000);
begin
    /*
     * This is our constant SELECT list - we'll always
     * get these three columns. The predicate is what
     * changes.
     */
    l_query := 'select ename, empno, job from emp';

    /*
     * We build the predicate by putting:
     *
     * cname operator :bvX
     *
     * into the query first.
     */
    for i in 1 .. p_cnames.count loop
        l_query := l_query || l_sep || p_cnames(i) || ' ' ||
                                       p_operators(i) || ' ' ||
                                       ':bv' || i;
        l_sep := ' and ';
    end loop;

    /*
     * Now we can parse the query
     */
    dbms_sql.parse(g_cursor, l_query, dbms_sql.native);

    /*
     * and then define the outputs. We fetch all three
     * columns into a VARCHAR2 type. 
     */
    for i in 1 .. 3 loop
        dbms_sql.define_column( g_cursor, i, l_colValue, 4000 );
    end loop;

    /*
     * Now, we can bind the inputs to the query
     */
    for i in 1 .. p_cnames.count loop
        dbms_sql.bind_variable( g_cursor, ':bv'||i, p_values(i), 4000);
    end loop;

    /*
     * and then execute it. This defines the resultset
     */
    l_status := dbms_sql.execute(g_cursor);

    /*
     * and now we loop over the rows and print out the results.
     */
    while( dbms_sql.fetch_rows( g_cursor ) > 0 )
    loop
        l_comma := '';
        for i in 1 .. 3 loop
            dbms_sql.column_value( g_cursor, i, l_colValue );
            dbms_output.put( l_comma || l_colValue  );
            l_comma := ',';
        end loop;
        dbms_output.new_line;
    end loop;
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