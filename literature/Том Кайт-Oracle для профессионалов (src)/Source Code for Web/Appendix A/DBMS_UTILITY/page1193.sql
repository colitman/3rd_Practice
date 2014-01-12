set echo on

declare
    l_version        varchar2(255);
    l_compatibility varchar2(255);
begin
    dbms_utility.db_version( l_version, l_compatibility );
    dbms_output.put_line( l_version );
    dbms_output.put_line( l_compatibility );
end;
/

select dbms_utility.port_string from dual;