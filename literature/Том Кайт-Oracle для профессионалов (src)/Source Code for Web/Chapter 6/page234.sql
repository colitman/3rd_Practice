create cluster hash_cluster
( hash_key number )
hashkeys 50000
size 45
/

create cluster single_table_hash_cluster
( hash_key INT )
hashkeys 50000
size 45
single table 
/

create table emp
cluster hash_cluster(empno)
as
select rownum empno, ename, job, mgr, hiredate, sal, comm, deptno
  from scott.emp
 where 1=0
/


create table single_table_emp
( empno INT , 
  ename varchar2(10),
  job   varchar2(9),
  mgr   number,
  hiredate date,
  sal   number,
  comm  number,
  deptno number(2)
)
cluster single_table_hash_cluster(empno)
/

declare
        l_cnt   number;
        l_empno number default 1;
begin
        select count(*) into l_cnt from scott.emp;
  
        for x in ( select * from scott.emp )
        loop
           for i in 1 .. trunc(50000/l_cnt)+1
           loop
                  insert into emp values
                  ( l_empno, x.ename, x.job, x.mgr, x.hiredate, x.sal,
                    x.comm, x.deptno );
                  l_empno := l_empno+1;
           end loop;
        end loop;
        commit;
end;
/

insert into single_table_emp
select * from emp;

create table emp_reg
as
select * from emp;

alter table emp_reg add constraint emp_pk primary key(empno);

create table random ( x int );

begin
        for i in 1 .. 100000
        loop
                insert into random values 
                ( mod(abs(dbms_random.random),50000)+1 );
        end loop;
end;
/

alter session set sql_trace=true;

select count(ename)
  from emp, random
 where emp.empno = random.x;

select count(ename)
  from emp_reg, random
 where emp_reg.empno = random.x;


select count(ename)
  from single_table_emp, random
 where single_table_emp.empno = random.x;



