set echo on
drop table t;
create table t
as
select * from all_objects
/
create index t_idx on
t(owner,object_type,object_name);

exec show_space('T_IDX',user,'INDEX')

drop index t_idx;

create index t_idx on
t(owner,object_type,object_name)
compress 1;

exec show_space('T_IDX',user,'INDEX')


drop index t_idx;

create index t_idx on
t(owner,object_type,object_name)  
compress 2;

exec show_space('T_IDX',user,'INDEX')
