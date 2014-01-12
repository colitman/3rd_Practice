set echo on
/*
drop table colocated;
drop table disorganized;

create table colocated ( x int, y varchar2(2000) ) pctfree 0;


begin
	for i in 1 .. 100000
	loop
		insert into colocated values ( i, rpad(dbms_random.random,75,'*') );
	end loop;
end;
/


create table disorganized nologging pctfree 0
as
select x, y from colocated ORDER BY y
/

alter table colocated    add constraint colocated_pk    primary key(x);
alter table disorganized add constraint disorganized_pk primary key(x);

commit;

exec show_space( 'COLOCATED' )
exec show_space( 'DISORGANIZED' )

*/

set timing on
set autotrace traceonly
select count(*) from colocated;
select count(*) from disorganized;
select * from COLOCATED where x between 20000 and 40000;
select /*+ FULL(COLOCATED) */ * from COLOCATED where x between 20000 and 40000;
select /*+ FULL(DISORGANIZED) */ * from DISORGANIZED where x between 20000 and 40000;
set autotrace off
