create index partitioned_index2
on partitioned(timestamp,id)
GLOBAL
partition  by range(id)
(
partition part_1 values less than(1000),
partition part_2 values less than (MAXVALUE)
)
/

