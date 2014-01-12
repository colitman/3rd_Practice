
set echo on
drop table t;

create table t as
select * from all_objects;

create index t_idx1 on t(object_name);

create index t_idx2 on t(object_type);

analyze table t compute statistics
for all indexed columns
for table;

compute sum of cnt on report
break on report
select object_type, count(*) cnt from t group by object_type;

variable search_str varchar2(25)
exec :search_str := '%';

set autotrace traceonly
select * from t t1 where object_name like :search_str
and object_type in( 'FUNCTION','PROCEDURE', 'TRIGGER' );

alter session set cursor_sharing = force;

select * from t t2 where object_name like :search_str
and object_type in( 'FUNCTION','PROCEDURE', 'TRIGGER' );
