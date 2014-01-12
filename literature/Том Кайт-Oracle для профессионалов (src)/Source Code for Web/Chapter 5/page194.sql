set echo on

drop table small;

create table small( x int );

insert into small values ( 0 );

begin
	commit;
   	set transaction use rollback segment rbs_small;
	for i in 1 .. 500000
	loop
		update small set x = x+1;
        commit;
        set transaction use rollback segment rbs_small;
		for x in ( select * from stop_other_session ) 
		loop
			return; -- stop when the other session tells us to
		end loop;
    end loop;
end;
/