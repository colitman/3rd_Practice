 set server output on
 set echo on
 
 drop table t;

 create table t
   ( x, y null, primary key (x) )
   as
   select rownum x, username
    from all_users
    where rownum <= 100;
   /

 analyze table t compute statistics;


 analyze table t compute statistics for all indexes;


 set autotrace on explain

 select count(y) from t where x < 50;
