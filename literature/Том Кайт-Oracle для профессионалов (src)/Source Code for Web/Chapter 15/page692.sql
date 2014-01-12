set echo on

drop table temp;

create global temporary table temp
(  x int )
on commit delete rows
/

create or replace procedure auto_proc1
as
        pragma autonomous_transaction;
begin
    insert into temp values ( 1 );
    commit;
end;
/
create or replace procedure auto_proc2
as
        pragma autonomous_transaction;
begin
	for x in ( select * from temp )
	loop
		null;
	end loop;
    commit;
end;
/


insert into temp values ( 2 );

exec auto_proc1;
exec auto_proc2;
