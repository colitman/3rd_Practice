set echo on

create or replace procedure native_dynamic_select
as
    type rc is ref cursor;
    l_cursor rc;
    l_oname  varchar2(255);
    l_cnt           number := 0;
    l_start  number default dbms_utility.get_time;
begin
    open l_cursor for 'select object_name from all_objects';

    loop
        fetch l_cursor into l_oname;
        exit when l_cursor%notfound;
        l_cnt := l_cnt+1;
    end loop;

    close l_cursor;
    dbms_output.put_line( L_cnt || ' rows processed' );
    dbms_output.put_line
    ( round( (dbms_utility.get_time-l_start)/100, 2 ) || ' seconds' );
exception
    when others then
        if ( l_cursor%isopen ) 
        then
            close l_cursor;
        end if;
        raise;
end;
/

create or replace procedure dbms_sql_select
as
    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   dbms_sql.varchar2_table;
    l_status        integer;
    l_cnt           number := 0;
    l_start  number default dbms_utility.get_time;
begin

    dbms_sql.parse( l_theCursor, 
                   'select object_name from all_objects',
                    dbms_sql.native );

    dbms_sql.define_array( l_theCursor, 1, l_columnValue, 100, 1 );
    l_status := dbms_sql.execute( l_theCursor );
    loop
        l_status := dbms_sql.fetch_rows(l_theCursor);
        dbms_sql.column_value(l_theCursor,1,l_columnValue);

        l_cnt := l_status+l_cnt;
        exit when l_status <> 100;
    end loop;
    dbms_sql.close_cursor( l_theCursor );
    dbms_output.put_line( L_cnt || ' rows processed' );
    dbms_output.put_line
    ( round( (dbms_utility.get_time-l_start)/100, 2 ) || ' seconds' );
exception
    when others then
        dbms_sql.close_cursor( l_theCursor );
        raise;
end;
/

set serveroutput on
exec native_dynamic_select
exec native_dynamic_select
exec dbms_sql_select
exec dbms_sql_select