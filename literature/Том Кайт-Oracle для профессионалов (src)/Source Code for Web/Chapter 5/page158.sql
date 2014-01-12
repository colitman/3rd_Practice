set echo on

drop table t;

create table t ( x int );

set serveroutput on

declare
        l_start number default dbms_utility.get_time;
begin
        for i in 1 .. 1000
        loop
                insert into t values ( 1 );
        end loop;
        commit;
        dbms_output.put_line
        ( dbms_utility.get_time-l_start || ' hsecs' );
end;
/

declare
        l_start number default dbms_utility.get_time;
begin
        for i in 1 .. 1000
        loop
                insert into t values ( 1 );
                commit;
        end loop;
        dbms_output.put_line
        ( dbms_utility.get_time-l_start || ' hsecs' );
end;
/