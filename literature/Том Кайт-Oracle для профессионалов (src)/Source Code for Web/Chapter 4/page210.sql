drop table t;

create table t
( x int primary key ,
  y date,
  z clob )
/

REM insert your own userid and password here

host exp userid=tkyte/tkyte tables=t
host imp userid=tkyte/tkyte full=y indexfile=t.sql


