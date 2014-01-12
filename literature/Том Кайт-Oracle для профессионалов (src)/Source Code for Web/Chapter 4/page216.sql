
drop table t1;

create table t1
(  x int primary key,
   y varchar2(25),
   z date
)
organization index;

drop table t2;

create table t2
(  x int primary key,
   y varchar2(25),
   z date
)
organization index
OVERFLOW;

drop table t3;

create table t3
(  x int primary key,
   y varchar2(25),
   z date
)
organization index
overflow INCLUDING y;


