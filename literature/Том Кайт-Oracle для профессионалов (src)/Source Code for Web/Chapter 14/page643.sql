drop table partitioned;

CREATE TABLE partitioned
( timestamp date,
  id        int primary key
)
PARTITION BY RANGE (timestamp)
(
PARTITION part_1 VALUES LESS THAN
( to_date('01-jan-2000','dd-mon-yyyy') ) ,
PARTITION part_2 VALUES LESS THAN
( to_date('01-jan-2001','dd-mon-yyyy') )
)
/


select segment_name, partition_name, segment_type
  from user_segments;

drop table partitioned;

CREATE TABLE partitioned
( timestamp date,
  id        int
)
PARTITION BY RANGE (timestamp)
(
PARTITION part_1 VALUES LESS THAN
( to_date('01-jan-2000','dd-mon-yyyy') ) ,
PARTITION part_2 VALUES LESS THAN
( to_date('01-jan-2001','dd-mon-yyyy') )
)
/

create index partitioned_index
on partitioned(id)
LOCAL
/

select segment_name, partition_name, segment_type
  from user_segments;

alter table partitioned
add constraint partitioned_pk
primary key(id)
/
