set echo on

drop table t;

create table t
( x char(2000) default 'x',
  y char(2000) default 'y',
  z char(2000) default 'z' )
/

insert into t
select 'x','y','z'
from all_objects where rownum < 500
/

commit;

column value new_value old_value

select * from redo_size;

select *
  from t
 where x = y;

select value-&old_value  REDO_GENERATED from redo_size;

commit;

select value from redo_size;

select *
  from t
 where x = y;

select value-&old_value  REDO_GENERATED from redo_size;