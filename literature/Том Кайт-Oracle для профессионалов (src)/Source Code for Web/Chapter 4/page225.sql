drop table emp;
drop table dept;

drop cluster emp_dept_cluster;


create cluster emp_dept_cluster
( deptno number(2) )
size 1024
/

create index emp_dept_cluster_idx
on cluster emp_dept_cluster
/

create table dept 
( deptno number(2) primary key,
  dname  varchar2(14),
  loc    varchar2(13)
)
cluster emp_dept_cluster(deptno)
/

create table emp
( empno number primary key, 
  ename varchar2(10),
  job   varchar2(9),
  mgr   number,
  hiredate date,
  sal   number,
  comm  number,
  deptno number(2) references dept(deptno)
)
cluster emp_dept_cluster(deptno)
/

begin
	for x in ( select * from scott.dept )
	loop
		insert into dept 
		values ( x.deptno, x.dname, x.loc );
		insert into emp 
		select * 
		  from scott.emp 
		 where deptno = x.deptno;
	end loop;
end;
/
