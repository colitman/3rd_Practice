set echo on

create or replace procedure run_by_jobs
as
        l_cnt   number;
begin
        select user_id into l_cnt from all_users;
        -- other code here
end;
/

variable n number
exec dbms_job.submit( :n, 'run_by_jobs;' );

commit;

exec dbms_lock.sleep(60);

select job, what, failures
  from user_jobs
 where job = :n;