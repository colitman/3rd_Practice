drop table emp;
drop table addresses;

create table emp 
as
select * from scott.emp
/
alter table emp 
add constraint emp_pk
primary key(empno)
/

create table addresses
( empno     number(4) references emp(empno) on delete cascade,
  addr_type varchar2(10),
  street    varchar2(20),
  city      varchar2(20),
  state		varchar2(2),
  zip		number,
  primary key (empno,addr_type)
)
ORGANIZATION INDEX
/

