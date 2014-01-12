set echo on

create or replace procedure p1
as
begin
        raise program_error;
end;
/

create or replace procedure p2
as
begin
        p1;
end;
/

create or replace procedure p3
as
begin
        p2;
end;
/

exec p3

create or replace procedure p3
as
begin
        p2;
exception
        when others then
              dbms_output.put_line( dbms_utility.format_error_stack );
end;
/

exec p3

create or replace procedure p3
as
begin
        p2;
exception
       when others then
                dbms_output.put_line( sqlerrm );
end;
/

exec p3

exec dbms_output.put_line( sqlerrm(-1) );