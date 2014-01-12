set echo on

drop table done;

create table done( object_id int );

insert into done values ( 0 );

declare
        l_cnt number;
        l_max number;
begin
        select object_id into l_cnt from done;
        select max(object_id) into l_max from t;

        while ( l_cnt < l_max )
        loop
                update t
                   set object_name = lower(object_name)
                 where object_id > l_cnt
                   and object_id <= l_cnt+100;

                update done set object_id = object_id+100;

                commit;
                set transaction use rollback segment rbs_small;
                l_cnt := l_cnt + 100;
        end loop;
end;
/
