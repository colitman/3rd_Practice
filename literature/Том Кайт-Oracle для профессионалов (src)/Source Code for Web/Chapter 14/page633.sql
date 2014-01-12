drop table hash_example;
drop table range_example;
drop table composite_example;

CREATE TABLE range_example
( range_key_column date, 
  data             varchar2(20)
)
PARTITION BY RANGE (range_key_column)
( PARTITION part_1 VALUES LESS THAN
       (to_date('01-jan-1995','dd-mon-yyyy')),
  PARTITION part_2 VALUES LESS THAN
       (to_date('01-jan-1996','dd-mon-yyyy'))
)
/

insert into range_example
values ( to_date( '01-jan-1994', 'dd-mon-yyyy' ), 'application data' );

update range_example
set range_key_column = range_key_column+1
/

update range_example
set range_key_column = range_key_column+366
/

select rowid from range_example
/
alter table range_example enable row movement
/
update range_example
set range_key_column = range_key_column+366
/
select rowid from range_example
/



CREATE TABLE hash_example
( hash_key_column   date,
  data              varchar2(20)
)
PARTITION BY HASH (hash_key_column,data)
( partition part_1 tablespace p1,
  partition part_2 tablespace p2
)
/
insert into hash_example
values ( to_date( '01-jan-1994', 'dd-mon-yyyy' ), 'application data' );


CREATE TABLE composite_example
( range_key_column   date,
  hash_key_column    int,
  data               varchar2(20) 
)
PARTITION BY RANGE (range_key_column)
subpartition by hash(hash_key_column) subpartitions 2
(
PARTITION part_1 
     VALUES LESS THAN(to_date('01-jan-1995','dd-mon-yyyy'))
     (subpartition part_1_sub_1, 
      subpartition part_1_sub_2
     ),
PARTITION part_2 
    VALUES LESS THAN(to_date('01-jan-1996','dd-mon-yyyy'))
    (subpartition part_2_sub_1, 
     subpartition part_2_sub_2
    )
)
/
