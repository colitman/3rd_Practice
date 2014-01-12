drop table counter;

create table counter ( x int );
insert into counter values (0);


create or replace function f return number
as
	pragma autonomous_transaction;
begin
	update counter set x = x+1;
	commit;
	return 1;
end;
/

select count(*) 
  from ( select f from emp )
/

select * from counter;


select count(*) 
from ( select f from emp union select f from emp )
/
select * from counter;

update counter set x = 0;
commit;
select f from emp union ALL select f from emp
/
select * from counter;


update counter set x = 0;
commit;
select f from emp union select f from emp 
/
select * from counter;
