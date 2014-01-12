set echo on

drop table t;

create table t ( msg varchar2(20), cnt int );

insert into t select 'from SQL*PLUS', count(*) from session_roles;

variable n number
exec dbms_job.submit(:n,'insert into t select ''from job'', count(*) from session_roles;');

print n

exec dbms_job.run(:n);

select * from t;