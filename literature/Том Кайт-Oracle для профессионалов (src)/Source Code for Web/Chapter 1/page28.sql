set echo on

alter system flush shared_pool;

set timing on
declare
    type rc is ref cursor;
    l_rc rc;
    l_dummy all_objects.object_name%type;
    l_start number default dbms_utility.get_time;
begin
    for i in 1 .. 1000
    loop
        open l_rc for
        'select object_name
           from all_objects
          where object_id = ' || i;
        fetch l_rc into l_dummy;
        close l_rc;
    end loop;
    dbms_output.put_line
    ( round( (dbms_utility.get_time-l_start)/100, 2 ) ||
      ' seconds...' );
end;
/

declare
    type rc is ref cursor;
    l_rc rc;
    l_dummy all_objects.object_name%type;
    l_start number default dbms_utility.get_time;
begin
    for i in 1 .. 1000
    loop
        open l_rc for
        'select object_name
           from all_objects
          where object_id = :x'
        using i;
        fetch l_rc into l_dummy;
        close l_rc;
    end loop;
    dbms_output.put_line
    ( round( (dbms_utility.get_time-l_start)/100, 2 ) ||
      ' seconds...' );
end;
/

set timing off