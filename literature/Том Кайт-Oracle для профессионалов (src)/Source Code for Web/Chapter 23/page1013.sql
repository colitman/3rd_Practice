set echo on

alter system flush shared_pool;
alter system set timed_statistics=true;
alter session set sql_trace=true;

declare
    type rc is ref cursor;
    l_cursor rc;
begin
    for i in 1 .. 500 loop
        open l_cursor for 'select * from all_objects t' || i;
        close l_cursor;
    end loop;
  end;
/

alter system flush shared_pool;
alter system set timed_statistics=true;
alter session set sql_trace=true;

declare
    type rc is ref cursor;
    l_cursor rc;
begin
    for i in 1 .. 500 loop
        open l_cursor for 'select * from all_objects t';
        close l_cursor;
    end loop;
  end;
/