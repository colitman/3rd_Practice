set echo on

create or replace
procedure  desc_query( p_query in varchar2 )
is
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_colCnt        number default 0;
    l_cnt           number default 0;
    l_line          long;

    /* We'll be using this to see what our query SELECTs
     */
    l_descTbl       dbms_sql.desc_tab;


    /* Step 1 - open cursor. */
    l_theCursor     integer default dbms_sql.open_cursor;
begin

    /* Step 2 - parse the input query so we can describe it. */
    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );

    /* Step 3 - now, describe the outputs of the query. 
     * L_COLCNT will contain the number of columns selected 
     * in the query. It will be equal to L_DESCTBL.COUNT 
     * actually and so it is redundant really. L_DESCTBL
     * contains the useful data about our SELECTed colums.
     */

    dbms_sql.describe_columns( c       => l_theCursor, 
                               col_cnt => l_colCnt, 
                               desc_t  => l_descTbl );

    for i in 1 .. l_colCnt 
    loop
        dbms_output.put_line
        ( 'Column Type...........' || l_descTbl(i).col_type );
        dbms_output.put_line
        ( 'Max Length............' || l_descTbl(i).col_max_len );
        dbms_output.put_line
        ( 'Name..................' || l_descTbl(i).col_name );
        dbms_output.put_line
        ( 'Name Length...........' || l_descTbl(i).col_name_len );
        dbms_output.put_line
        ( 'ObjColumn Schema Name.' || l_descTbl(i).col_schema_name );
        dbms_output.put_line
        ( 'Schema Name Length....' || l_descTbl(i).col_schema_name_len );
        dbms_output.put_line
        ( 'Precision.............' || l_descTbl(i).col_precision );
        dbms_output.put_line
        ( 'Scale.................' || l_descTbl(i).col_scale );
        dbms_output.put_line
        ( 'Charsetid.............' || l_descTbl(i).col_Charsetid );
        dbms_output.put_line
        ( 'Charset Form..........' || l_descTbl(i).col_charsetform );
        if ( l_desctbl(i).col_null_ok ) then
            dbms_output.put_line( 'Nullable..............Y' );
        else
            dbms_output.put_line( 'Nullable..............N' );
        end if;
		dbms_output.put_line( '------------------------' );
     end loop;

    /* Step 9 - close cursor to free up resources. */
    dbms_sql.close_cursor(l_theCursor);
exception
    when others then 
        dbms_sql.close_cursor( l_theCursor );
        raise;
end desc_query;
/

set serveroutput on
exec desc_query( 'select rowid, ename from emp' );
exec desc_query( 'select * from dept' );

set long 50000
select text 
  from all_views
 where view_name = 'ALL_TAB_COLUMNS'
/
/
