set echo on
set server output on

drop table t;

create table t 
nologging
as
select * from all_objects;


create index t_idx_1 on t(owner,object_type,object_name)
nologging pctfree 0;

create index t_idx_2 on t(object_name,object_type,owner)
nologging pctfree 0;

exec show_space( 'T_IDX_1', user, 'INDEX' );
exec show_space( 'T_IDX_2', user, 'INDEX' );


alter session set sql_trace=true;

declare
	cnt int;
begin
	for x in ( select owner, object_type, object_name from t )
	loop
		select /*+ INDEX( t t_idx_1 ) */ count(*) into cnt 
		  from t
		 where object_name = x.object_name
		   and object_type = x.object_type
		   and owner = x.owner;

		select /*+ INDEX( t t_idx_2 ) */ count(*) into cnt 
		  from t
		 where object_name = x.object_name
		   and object_type = x.object_type
		   and owner = x.owner;
	end loop;
end;
/
