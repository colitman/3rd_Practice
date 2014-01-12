drop table iot;
set echo on

create table iot
( owner, object_type, object_name,
  constraint iot_pk primary key(owner,object_type,object_name)
)
organization index
compress 2
as
select owner, object_type, object_name from all_objects
/

