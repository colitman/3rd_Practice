set echo on

@connect scott/tiger
revoke select on dept from another_user;

@connect tkyte/tkyte

drop user utils_acct cascade;
grant connect to another_user identified by another_user;

create user utils_acct identified by utils_acct;

grant create session, create procedure to utils_acct;

@connect utils_acct/utils_acct;

create or replace 
procedure print_table( p_query in varchar2 )
AUTHID CURRENT_USER
is
    l_theCursor     integer default dbms_sql.open_cursor;
    l_columnValue   varchar2(4000);
    l_status        integer;
    l_descTbl       dbms_sql.desc_tab;
    l_colCnt        number;
begin
    dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
    dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl);

    for i in 1 .. l_colCnt loop
        dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;

    l_status := dbms_sql.execute(l_theCursor);

    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
        for i in 1 .. l_colCnt loop
           dbms_sql.column_value( l_theCursor, i, l_columnValue );
           dbms_output.put_line( rpad( l_descTbl(i).col_name, 30 )
                                  || ': ' ||
                                  l_columnValue );
        end loop;
        dbms_output.put_line( '-----------------' );
    end loop;
exception
    when others then 
        dbms_sql.close_cursor( l_theCursor );
        RAISE;
end;
/

grant execute on print_table to public;

@connect tkyte/tkyte
revoke create session, create procedure 
from utils_acct;

@connect scott/tiger

set serverout on
exec utils_acct.print_table('select * from scott.dept')

@connect another_user/another_user

desc scott.dept

set serverout on
exec utils_acct.print_table('select * from scott.dept' );

@connect scott/tiger
grant select on dept to another_user;

@connect another_user/another_user
set serverout on
exec utils_acct.print_table('select * from scott.dept' );
