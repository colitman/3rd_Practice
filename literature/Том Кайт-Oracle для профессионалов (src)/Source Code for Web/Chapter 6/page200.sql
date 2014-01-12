drop table t;

create table t ( x int );

create global temporary table sess_event
on commit preserve rows
as
select * from v$waitstat
where 1=0 
/

truncate table sess_event;

insert into sess_event
select * from v$waitstat
/

begin
        for i in 1 .. 100000
        loop
                insert into t values ( i );
                commit ;
        end loop;
end;
/

select a.class, b.count-a.count count, b.time-a.time time
  from sess_event a, v$waitstat b
 where a.class = b.class
/

create table t ( x int ) storage ( FREELISTS 2 );

alter table t storage ( FREELISTS 2 );

