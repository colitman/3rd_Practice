set echo on

alter system archive log current;

update emp set ename = lower(ename);

update dept set dname = lower(dname);

commit;

alter system archive log current;

column name format a80
select name 
  from v$archived_log 
 where completion_time = ( select max(completion_time) 
                             from v$archived_log )
/