set echo on

create or replace
function get_row_cnts( p_tname in varchar2 ) return number
as
    l_theCursor     integer;
    l_columnValue   number  default NULL;
    l_status        integer;
begin

    -- Step 1, open the cursor.
    l_theCursor := dbms_sql.open_cursor;
    begin

        -- Step 2, parse the query.
        dbms_sql.parse(  c             => l_theCursor,
                         statement     => 'select count(*) from ' || p_tname,
                         language_flag => dbms_sql.native );

        -- Step 5, define the output of this query as a NUMBER.
        dbms_sql.define_column ( c        => l_theCursor,  
                                 position => 1, 
                                 column   => l_columnValue );

        -- Step 6, execute the statement.
        l_status := dbms_sql.execute(l_theCursor);

        -- Step 7, fetch the rows.
        if ( dbms_sql.fetch_rows( c => l_theCursor) > 0 )
        then
            -- Step 8, retrieve the outputs.
            dbms_sql.column_value( c        => l_theCursor, 
                                   position => 1, 
                                   value    => l_columnValue );
        end if;

        -- Step 9, close the cursor.
        dbms_sql.close_cursor( c => l_theCursor );
        return l_columnValue;
    exception
        when others then
            dbms_output.put_line( '===> ' || sqlerrm );
            dbms_sql.close_cursor( c => l_theCursor );
            RAISE;
    end;
end;
/

set serveroutput on
begin
   dbms_output.put_line('Emp has this many rows ' ||
                         get_row_cnts('emp'));
end;
/

begin
   dbms_output.put_line('Not a table has this many rows ' ||
                         get_row_cnts('NOT_A_TABLE'));
end;
/