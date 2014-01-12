drop table t;
drop type myArrayType;

create type myArrayType
as varray(10) of number(12,2)
/

create table t
( x int primary key, y myArrayType )
/

