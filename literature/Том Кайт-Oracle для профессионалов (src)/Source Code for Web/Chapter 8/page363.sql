set echo on
set serveroutput on

drop table t1;
drop table t2;
drop table t3;


create table t1
  ( x int primary key, y varchar2(25) )
  organization index
  overflow tablespace data
/


create table t2
  ( x int, y clob )
/


create table t3
  ( x int,
    a int default to_char(sysdate,'d')
  )
  PARTITION BY RANGE (a)
  (
  PARTITION part_1 VALUES LESS THAN(2),
  PARTITION part_2 VALUES LESS THAN(3),
  PARTITION part_3 VALUES LESS THAN(4),
  PARTITION part_4 VALUES LESS THAN(5),
  PARTITION part_5 VALUES LESS THAN(6),
  PARTITION part_6 VALUES LESS THAN(7),
  PARTITION part_7 VALUES LESS THAN(8)
  )
/


host imp userid=tkyte/tkyte full=y ignore=y


