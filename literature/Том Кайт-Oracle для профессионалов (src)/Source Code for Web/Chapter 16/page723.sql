set echo on

create or replace
function  dump_fixed_width( p_query     in varchar2,
                            p_dir       in varchar2 ,
                            p_filename  in varchar2 )
return number
is
    l_output        utl_file.file_type;
    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_colCnt        number default 0;
    l_cnt           number default 0;
     l_line          long;
    l_descTbl       dbms_sql.desc_tab;
    l_dateformat    nls_session_parameters.value%type;
begin
    select value into l_dateformat
      from nls_session_parameters 
     where parameter = 'NLS_DATE_FORMAT';

    /* Use a date format that includes the time. */
    execute immediate 
    'alter session set nls_date_format=''dd-mon-yyyy hh24:mi:ss'' ';
    l_output := utl_file.fopen( p_dir, p_filename, 'w', 32000 );

    /* Parse the input query so we can describe it. */
    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );

    /* Now, describe the outputs of the query. */
    dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );

    /* For each column, we need to define it, to tell the database
     * what we will fetch into. In this case, all data is going
     * to be fetched into a single varchar2(4000) variable.
     *
     * We will also adjust the max width of each column. We do
     * this so when we OUTPUT the data. Each field starts and
     * stops in the same position for each record.
     */
    for i in 1 .. l_colCnt loop
        dbms_sql.define_column( l_theCursor, i, l_columnValue, 4000 );

        if ( l_descTbl(i).col_type = 2 )  /* number type */
        then
             L_descTbl(i).col_max_len := l_descTbl(i).col_precision+2;
        elsif ( l_descTbl(i).col_type = 12 ) /* date type */
        then
             /* length of my format above */
             l_descTbl(i).col_max_len := 20; 
        end if;
     end loop;

    l_status := dbms_sql.execute(l_theCursor);

     while ( dbms_sql.fetch_rows(l_theCursor) > 0 )
     loop
        /* Build up a big output line. This is more efficient than
         * calling UTL_FILE.PUT inside the loop.
         */
        l_line := null;
        for i in 1 .. l_colCnt loop
            dbms_sql.column_value( l_theCursor, i, l_columnValue );
            l_line := l_line ||
                      rpad( nvl(l_columnValue,' '), 
                      l_descTbl(i).col_max_len );
        end loop;

        /* Now print out that line and increment a counter. */
        utl_file.put_line( l_output, l_line );
        l_cnt := l_cnt+1;
    end loop;

    /* Free up resources. */
    dbms_sql.close_cursor(l_theCursor);
    utl_file.fclose( l_output );

    /* Reset the date format ... and return. */
    execute immediate 
    'alter session set nls_date_format=''' || l_dateformat || ''' ';
    return l_cnt;
exception
    when others then
        dbms_sql.close_cursor( l_theCursor );
        execute immediate 
        'alter session set nls_date_format=''' || l_dateformat || ''' ';

end dump_fixed_width;
/

set serveroutput on
declare
    l_rows    number;
begin
    l_rows := dump_fixed_width( 'select * from emp' ,
                                'c:\temp',
                                'test.dat' );
    dbms_output.put_line( to_char(l_rows) ||
                          ' rows extracted to ascii file' );
end;
/