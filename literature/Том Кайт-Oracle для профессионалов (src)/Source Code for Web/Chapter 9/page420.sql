drop table t;
drop type myTableType;


create or replace type myTableType
as table of number(12,2)
/

create table t
( x int primary key, y myTableType )
nested table y store as y_tab
/

