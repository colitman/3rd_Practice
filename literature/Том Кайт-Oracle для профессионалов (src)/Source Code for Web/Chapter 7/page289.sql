set echo on

drop table emp;

create table emp 
as 
select * from scott.emp;

set timing on
insert into emp
select -rownum EMPNO, 
       substr(object_name,1,10) ENAME,  
       substr(object_type,1,9) JOB, 
	   -rownum MGR,
	   created hiredate,
	   rownum SAL,
	   rownum COMM,
	   (mod(rownum,4)+1)*10 DEPTNO
 from all_objects
where rownum < 10000
/
set timing off
	    
commit;

update emp set ename = initcap(ename);

commit;

create index emp_upper_idx on emp(upper(ename));

analyze table emp compute statistics
for table
for all indexed columns
for all indexes;

alter session set QUERY_REWRITE_ENABLED=TRUE;
alter session set QUERY_REWRITE_INTEGRITY=TRUSTED;

set autotrace on explain
select ename, empno, sal from emp where upper(ename) = 'KING';
set autotrace off
