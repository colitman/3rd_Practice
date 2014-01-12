set echo on

create or replace 
function update_row( p_owner    in varchar2,
                     p_newDname in varchar2,
                     p_newLoc   in varchar2,
                     p_deptno   in varchar2,
                     p_rowid    out varchar2 )
return number
is
    l_theCursor     integer;
    l_columnValue   number  default NULL;
    l_status        integer;
    l_update        long;
begin
    l_update := 'update ' || p_owner || '.dept
                    set dname = :bv1, loc = :bv2
                  where deptno = to_number(:pk)
              returning rowid into :out';

    -- Step 1, open the cursor.
    l_theCursor := dbms_sql.open_cursor;

    begin
        -- Step 2, parse the query.
        dbms_sql.parse(  c             => l_theCursor,
                         statement     => l_update,
                         language_flag => dbms_sql.native );

        -- Step 3, bind all of the INPUTS and OUTPUTS.
        dbms_sql.bind_variable( c     => l_theCursor,
                                name  => ':bv1',
                                value => p_newDname );
        dbms_sql.bind_variable( c     => l_theCursor,
                                name  => ':bv2',
                                value => p_newLoc );
        dbms_sql.bind_variable( c     => l_theCursor,
                                name  => ':pk',
                                value => p_deptno );
        dbms_sql.bind_variable( c     => l_theCursor,
                                name  => ':out',
                                value => p_rowid,
                                out_value_size => 4000 );

        -- Step 4, execute the statement. Since this is a DML
        -- statement, L_STATUS is be the number of rows updated.
        -- This is what we'll return.

        l_status := dbms_sql.execute(l_theCursor);

        -- Step 5, retrieve the OUT variables from the statement.
        dbms_sql.variable_value( c     => l_theCursor,
                                 name  => ':out',
                                 value => p_rowid );

        -- Step 6, close the cursor.
        dbms_sql.close_cursor( c => l_theCursor );
        return l_columnValue;
    exception
        when dup_val_on_index then
            dbms_output.put_line( '===> ' || sqlerrm );
            dbms_sql.close_cursor( c => l_theCursor );
            RAISE;
    end;
end;
/


set serveroutput on
declare
    l_rowid   varchar(50);
    l_rows    number;
begin
    l_rows := update_row( 'SCOTT', 'CONSULTING', 'WASHINGTON', '10', l_rowid );

    dbms_output.put_line( 'Updated ' || l_rows || ' rows' );
    dbms_output.put_line( 'its rowid was ' || l_rowid );
end;
/

select * from dept;

rollback;

select * from dept;