set echo on
drop table sess_event;
drop table t;


create global temporary table sess_event
on commit preserve rows
as
select * from v$session_event where 1=0;

create table t
( c1 int, c2 int, c3 int, c4 int )
storage ( freelists 10 );

truncate table sess_event;

insert into sess_event
select * from v$session_event
where sid = ( select sid from v$mystat where rownum = 1 );

declare
    l_number number;
begin
    for i in 1 .. 10000
    loop
        l_number := dbms_random.random;
  
        execute immediate
        'insert into t values ( ' || l_number || ',' ||
                                     l_number || ',' ||
                                     l_number || ',' ||
                                     l_number || ')';
    end loop;
    commit;
end;
/

select a.event,
       (a.total_waits-nvl(b.total_waits,0)) total_waits,
       (a.time_waited-nvl(b.time_waited,0)) time_waited
  from ( select *
           from v$session_event
          where sid = (select sid from v$mystat where rownum = 1 )) a,
       sess_event b
 where a.event = b.event(+)
   and (a.total_waits-nvl(b.total_waits,0)) > 0
/

