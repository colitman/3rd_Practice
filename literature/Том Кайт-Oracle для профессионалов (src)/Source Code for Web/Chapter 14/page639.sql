drop table partitioned_table;


CREATE TABLE partitioned_table
( a int,
  b int
)
PARTITION BY RANGE (a)
(
PARTITION part_1 VALUES LESS THAN(2) ,
PARTITION part_2 VALUES LESS THAN(3)
)
/

create index local_prefixed on partitioned_table (a,b) local;



insert into partitioned_table values ( 1, 1 );

alter index local_prefixed modify partition part_2 unusable;


set autotrace on explain
select * from partitioned_table where a = 1 and b = 1;

create index local_nonprefixed on partitioned_table (b) local;
alter index local_nonprefixed modify partition part_2 unusable;

select * from partitioned_table where b = 1;
drop index local_prefixed;
select * from partitioned_table where a = 1 and b = 1;


set autotrace off
