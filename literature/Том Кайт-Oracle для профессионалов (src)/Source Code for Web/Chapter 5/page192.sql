set echo on

drop table small;

create table small( x int );

insert into small values ( 0 );

begin
    commit;
    set transaction use rollback segment rbs_small;
    update t
       set object_type = lower(object_type);
    commit;

        for x in ( select * from t )
        loop
                for i in 1 .. 20
                loop
                        update small set x = x+1;
                        commit;
                        set transaction use rollback segment rbs_small;
                end loop;
        end loop;
end;
/

select * from small;