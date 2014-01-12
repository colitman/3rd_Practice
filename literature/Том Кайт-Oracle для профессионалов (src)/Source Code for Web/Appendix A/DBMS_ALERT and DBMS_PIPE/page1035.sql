set echo on

drop table alert_messages
/

create table alert_messages
( job_id     int primary key,
  alert_name varchar2(30),
  message    varchar2(2000)
)
/

create or replace procedure background_alert( p_job in int )
as
    l_rec alert_messages%rowtype;
begin
    select * into l_rec from alert_messages where job_id = p_job;

    dbms_alert.signal( l_rec.alert_name, l_rec.message );
    delete from alert_messages where job_id = p_job;
    commit;
end;
/

drop table t;

create table t ( x int );

create or replace trigger t_trigger
after insert or update of x on t for each row
declare
	l_job number;
begin
	dbms_job.submit( l_job, 'background_alert(JOB);' );
	insert into alert_messages 
	( job_id, alert_name, message )
	values
	( l_job, 'MyAlert', 'X in T has value ' || :new.x );
end;
/