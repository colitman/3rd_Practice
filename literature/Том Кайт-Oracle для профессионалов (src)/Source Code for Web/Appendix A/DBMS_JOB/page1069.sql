set echo on

drop table t;
create table t ( msg varchar2(80) );

create or replace 
procedure p( p_job in number, p_next_date in OUT date )
as
    l_next_date date default p_next_date;
begin
    p_next_date := trunc(sysdate)+1+3/24;

    insert into t values
    ( 'Next date was "' || 
       to_char(l_next_date,'dd-mon-yyyy hh24:mi:ss') ||
      '" Next date IS ' || 
       to_char(p_next_date,'dd-mon-yyyy hh24:mi:ss') );
end;
/

variable n number

exec dbms_job.submit( :n, 'p(JOB,NEXT_DATE);' );

select what, interval,
       to_char(last_date,'dd-mon-yyyy hh24:mi:ss') last_date,
       to_char(next_date,'dd-mon-yyyy hh24:mi:ss') next_date
  from user_jobs
 where job = :n
/

exec dbms_job.run( :n );

select * from t;

select what, interval,
       to_char(last_date,'dd-mon-yyyy hh24:mi:ss') last_date,
       to_char(next_date,'dd-mon-yyyy hh24:mi:ss') next_date
  from user_jobs
 where job = :n
/

exec dbms_job.remove( :n );
