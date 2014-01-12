set echo on

create rollback segment rbs_small
storage
( initial 8k next 8k
  minextents 2 maxextents 3 )
tablespace rbs_test
/

alter rollback segment rbs_small online;

drop table t;

create table t
as
select *
  from all_objects
/

create index t_idx on t(object_id)
/

begin
        for x in ( select rowid rid from t )
        loop
                commit;
                set transaction use rollback segment rbs_small;
                update t
                   set object_name = lower(object_name)
                 where rowid = x.rid;
        end loop;
        commit;
end;
/

declare
        l_cnt number default 0;
begin
        for x in ( select rowid rid, t.* from t where object_id > 0 )
        loop
                if ( mod(l_cnt,100) = 0 )
                then
                        commit;
                        set transaction use rollback segment rbs_small;
                end if;
                update t
                   set object_name = lower(object_name)
                 where rowid = x.rid;
                l_cnt := l_cnt + 1;
        end loop;
    commit;
end;
/