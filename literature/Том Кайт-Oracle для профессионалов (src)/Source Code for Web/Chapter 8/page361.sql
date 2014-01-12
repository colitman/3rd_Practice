set echo on
set serveroutput on

drop table t1;
drop table t2;
drop table t3;
drop table t4;

create tablespace exp_test
  datafile 'c:\oracle\oradata\tkyte816\exp_test.dbf'
  size 1m
  extent management local
  uniform size 64k
/


alter user tkyte default tablespace exp_test
/


create table t1
  ( x int primary key, y varchar2(25) )
  organization index
  overflow tablespace exp_test
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


create table t4 ( x int )
/


host exp userid=tkyte/tkyte owner=tkyte

drop tablespace exp_test including contents;


alter user tkyte default tablespace data;

host imp userid=tkyte/tkyte full=y


