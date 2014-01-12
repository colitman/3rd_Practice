set server output on
 set echo on
 
 drop table t;
 create table t ( x int, y int NOT NULL );

drop index t_idx;
 create unique index t_idx on t(x,y);


 insert into t values ( 1, 1 );


 insert into t values ( NULL, 1 );


 analyze table t compute statistics;


 set autotrace on


