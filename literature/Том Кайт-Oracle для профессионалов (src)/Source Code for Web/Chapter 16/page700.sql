set echo on

create or replace procedure DynEmpProc( p_job in varchar2 )
as
    type refcursor is ref cursor;

    -- We must allocate our own host 
    -- variables and resources using dynamic sql.
    l_cursor   refcursor;
    l_ename    emp.ename%type;
begin
    
    -- We start by parsing the query
    open l_cursor for
    'select ename 
       from emp 
      where job = :x' USING in p_job;

    loop
        -- and explicitly FETCHING from the cursor.
        fetch l_cursor into l_ename;

        -- We have to do all error handling 
        -- and processing logic ourselves.
        exit when l_cursor%notfound;

        dbms_output.put_line( l_ename );
    end loop;

    -- Make sure to free up resources
    close l_cursor;
exception
    when others then
        -- and catch and handle any errors so 
        -- as to not 'leak' resources over time
        -- when errors occur.
        if ( l_cursor%isopen ) 
        then
            close l_cursor;
        end if;
        RAISE;
end;
/

create or replace procedure StaticEmpProc( p_job in varchar2 )
as
begin
    for x in ( select ename from emp where job = p_job )
    loop
        dbms_output.put_line( x.ename );
    end loop;
end;
/

set serveroutput on size 1000000
exec DynEmpProc( 'CLERK' )
exec StaticEmpProc( 'CLERK' )