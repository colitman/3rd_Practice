@connect tkyte/tkyte
drop user application cascade;

@connect scott/tiger

grant select on emp to public;

grant select on dept to public;

@connect tkyte/tkyte

drop table dept;
drop table emp;


create table dept as select * from scott.dept;

create table emp as select * from scott.emp;

insert into emp select * from emp;

create user application identified by pw 
         default tablespace users quota unlimited on users;

grant create session, create table, 
               create procedure to application;

@connect application/pw

create table emp as select * from scott.emp where 1=0;

create table dept as 
                 select * from scott.dept where 1=0;

