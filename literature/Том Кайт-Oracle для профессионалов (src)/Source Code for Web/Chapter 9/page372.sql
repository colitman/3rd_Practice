set echo on
drop table dept;


create table dept
( deptno  number(2) constraint emp_pk primary key,
  dname   varchar2(14),
  loc     varchar2(13)
)
/
