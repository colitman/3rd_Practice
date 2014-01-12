set echo on 
set serrveroutput on
 
 
create table t ( x int, y int );
/

create index t_idx on t(x,y);
/

alter table t add constraint t_pk primary key(x);
/

select object_type, object_name,
                   decode(status,'INVALID','*','') status,
                   tablespace_name
  from user_objects a, user_segments b
  where a.object_name = b.segment_name (+)
  order by object_type, object_name;
/