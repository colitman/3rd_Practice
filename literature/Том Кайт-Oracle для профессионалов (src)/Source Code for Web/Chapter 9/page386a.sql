drop table dept_working;

create table dept_working
as
select * from dept
 where 1=0
/

alter table dept_working 
add constraint dept_working_pk 
primary key(deptno)
/
