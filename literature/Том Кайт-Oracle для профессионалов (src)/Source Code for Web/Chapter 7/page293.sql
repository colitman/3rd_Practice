set server output on
set echo on

drop index emp_soundex_idx;

create index emp_soundex_idx on emp( my_soundex(ename) );

create index emp_soundex_idx on
emp( substr(my_soundex(ename),1,6) )
/

truncate table emp;

REM reset counter
exec stats.cnt := 0


set timing on
insert into emp
select -rownum EMPNO,
       initcap( substr(object_name,1,10)) ENAME,
       substr(object_type,1,9) JOB,
       -rownum MGR,
       created hiredate,
       rownum SAL,
       rownum COMM,
       (mod(rownum,4)+1)*10 DEPTNO
 from all_objects
where rownum < 10000
union all
select empno, initcap(ename), job, mgr, hiredate,
       sal, comm, deptno
  from scott.emp
/
set timing off

exec dbms_output.put_line( stats.cnt );



analyze table emp compute statistics
for table
for all indexed columns
for all indexes;

REM reset our counter
exec stats.cnt := 0

alter session set QUERY_REWRITE_ENABLED=TRUE;
alter session set QUERY_REWRITE_INTEGRITY=TRUSTED;
set timing on
select ename, hiredate
  from emp
 where substr(my_soundex(ename),1,6) = my_soundex('Kings')
/
set autotrace on explain
set autotrace off
set timing off

exec dbms_output.put_line( stats.cnt );
