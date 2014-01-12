set echo on
set serveroutput on

drop table t;
/

create table t
  ( x int check ( x > 5 ),
    y int constraint my_rule check ( y > 10 ),
    z int not null ,
    a int unique,
    b int references t,
    c int primary key
  );
/

select constraint_name name, constraint_type type, search_condition
    from user_constraints where table_name = 'T';
/


host exp userid=tkyte/tkyte owner=tkyte
 
drop table T;
   
host imp userid=tkyte/tkyte full=y ignore=y rows=n

select constraint_name name, constraint_type type, search_condition
    from user_constraints where table_name = 'T';
/