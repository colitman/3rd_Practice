set echo on

drop table stop_other_session;

create table stop_other_session ( x int );

declare
	l_cnt number := 0;
begin
    commit;
    set transaction use rollback segment rbs_small;
    update t
       set object_type = lower(object_type);
    commit;
  
    for x in ( select * from t )
    loop
		sys.dbms_lock.sleep(1);
    end loop;
end;
/

