set server output on
set echo on
 
 drop table t;

 create table t ( x int, y int );

 drop index t_idx;

 create unique index t_idx on t(x,y);


 insert into t values ( 1, 1 );


 insert into t values ( 1, NULL );


 insert into t values ( NULL, 1 );


 insert into t values ( NULL, NULL );


 analyze index t_idx validate structure;


 select name, lf_rows from index_stats;



 insert into t values ( NULL, NULL );


 insert into t values ( NULL, 1 );

 insert into t values ( 1, NULL );

select x, y, count(*) 
  from t
  group by x,y
  having count(*) > 1;
