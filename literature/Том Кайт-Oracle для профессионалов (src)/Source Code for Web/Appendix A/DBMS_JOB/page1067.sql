@connect scott/tiger

create or replace procedure analyze_my_tables
as
begin
    for x in ( select table_name from user_tables )
    loop
        execute immediate
            'analyze table ' || x.table_name || ' compute statistics';
    end loop;
end;
/

declare
    l_job number;
begin
    dbms_job.submit( job       => l_job,
                     what      => 'analyze_my_tables;',
                     next_date => trunc(sysdate)+1+3/24,
                     interval  => 'trunc(sysdate)+1+3/24' );
end;
/

select job, to_char(sysdate,'dd-mon'), 
                  to_char(next_date,'dd-mon-yyyy hh24:mi:ss'),
                  interval, what
from user_jobs
/