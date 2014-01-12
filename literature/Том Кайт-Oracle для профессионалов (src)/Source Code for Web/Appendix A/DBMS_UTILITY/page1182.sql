set echo

create or replace function my_caller return varchar2

as
    owner       varchar2(30);
    name        varchar2(30);
    lineno      number;
    caller_t    varchar2(30);
    call_stack  varchar2(4096) default dbms_utility.format_call_stack;
    n           number;
    found_stack BOOLEAN default FALSE;
    line        varchar2(255);
    cnt         number := 0;
begin
--
    loop
        n := instr( call_stack, chr(10) );
        exit when ( cnt = 3 or n is NULL or n = 0 );
--
        line := substr( call_stack, 1, n-1 );
        call_stack := substr( call_stack, n+1 );
--
        if ( NOT found_stack ) then
            if ( line like '%handle%number%name%' ) then
                found_stack := TRUE;
            end if;
        else
            cnt := cnt + 1;
            -- cnt = 1 is ME
            -- cnt = 2 is MY Caller
            -- cnt = 3 is Their Caller
            if ( cnt = 3 ) then
                lineno := to_number(substr( line, 13, 6 ));
                line   := substr( line, 21 );
                if ( line like 'pr%' ) then
                    n := length( 'procedure ' );
                elsif ( line like 'fun%' ) then
                    n := length( 'function ' );
                elsif ( line like 'package body%' ) then
                    n := length( 'package body ' );
                elsif ( line like 'pack%' ) then
                    n := length( 'package ' );
                elsif ( line like 'anonymous block%' ) then
                    n := length( 'anonymous block ' );
                else -- must be a trigger
                    n := 0;    
                end if;
                if ( n <> 0 ) then
                    caller_t := ltrim(rtrim(upper(substr( line, 1, n-1 ))));
                    line := substr( line, n );
                else
                    caller_t := 'TRIGGER';
                    line := ltrim( line );
                end if;
                   n := instr( line, '.' );
                   owner := ltrim(rtrim(substr( line, 1, n-1 )));
                   name  := ltrim(rtrim(substr( line, n+1 )));
            end if;
        end if;
    end loop;
    return owner || '.' || name;
end;
/

create or replace function who_am_i return varchar2
as
begin
    return my_caller;
end;
/

create or replace procedure p1
as
begin
    dbms_output.put_line( 'i am ' || who_am_i );
    dbms_output.put_line( 'i was called by ' || my_caller );
end;
/

create or replace procedure p2
as
begin
    dbms_output.put_line( 'i am ' || who_am_i );
    dbms_output.put_line( 'i was called by ' || my_caller );
    p1;
end;
/

exec p2
exec p3