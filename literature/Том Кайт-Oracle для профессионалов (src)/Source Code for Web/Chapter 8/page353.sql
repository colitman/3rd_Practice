 set echo on
 set serveroutput on
 
 create table t
   ( x int,
    y int,
    constraint t_pk primary key(x)
  );
  /

drop index t_idx;
create index t_idx on t(x,y);

 create table t2
   ( x int primary key,
     y int
   );
/  

drop index t2_idx;

create index t2_idx on t2(x,y);
/  

 select object_type, object_name,
                   decode(status,'INVALID','*','') status,
                   tablespace_name
   from user_objects a, user_segments b
   where a.object_name = b.segment_name (+)
   order by object_type, object_name;
  


select object_type, object_name,
                  decode(status,'INVALID','*','') status,
                  tablespace_name
  from user_objects a, user_segments b
  where a.object_name = b.segment_name (+)
  order by object_type, object_name

drop index t_idx;