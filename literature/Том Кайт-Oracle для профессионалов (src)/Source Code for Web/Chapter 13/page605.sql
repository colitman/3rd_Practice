set echo on

drop table emp;
drop table dept;
drop materialized view emp_dept;

create table emp as select * from scott.emp;
create table dept as select * from scott.dept;

grant query rewrite to tkyte;

alter session set query_rewrite_enabled=true;

alter session set query_rewrite_integrity=enforced;

create materialized view emp_dept
build immediate
refresh on demand
enable query rewrite
as
select dept.deptno, dept.dname, count (*)
  from emp, dept
 where emp.deptno = dept.deptno
 group by dept.deptno, dept.dname
/

alter session set optimizer_goal=all_rows;

set autotrace on
select count(*) from emp;

alter table dept
add constraint dept_pk primary key(deptno);

alter table emp
add constraint emp_fk_dept
foreign key(deptno) references dept(deptno);

alter table emp modify deptno not null;

set autotrace on
select count(*) from emp;
set autotrace off

alter table emp drop constraint emp_fk_dept;
alter table dept drop constraint dept_pk;
alter table emp modify deptno null;

insert into emp (empno,deptno) values ( 1, 1 );

exec dbms_mview.refresh( 'EMP_DEPT' );
alter materialized view emp_dept consider fresh;

alter table dept
add constraint dept_pk primary key(deptno)
rely enable NOVALIDATE 
/

REM alter table dept
REM modify constraint dept_pk 
REM RELY
REM /

alter table emp
add constraint emp_fk_dept
foreign key(deptno) references dept(deptno)
rely enable NOVALIDATE
/

REM alter table emp
REM modify constraint emp_fk_dept 
REM RELY;

alter table emp modify deptno not null NOVALIDATE;

set autotrace on

alter session set query_rewrite_integrity=enforced;

select count(*) from emp;

alter session set query_rewrite_integrity=trusted;

select count(*) from emp; 