drop table dept cascade;

create table dept
  (deptno number(2) primary key,
   dname     varchar2(14),
   loc       varchar2(13)
  );
/

drop table emp;
create table emp
  (empno       number(4) primary key,
   ename       varchar2(10),
   job         varchar2(9),
   mgr         number(4) references emp,
   hiredate    date,
   sal         number(7, 2),
   comm        number(7, 2),
   deptno      number(2) references dept
  );
/

create or replace type emp_type
  as object
  (empno       number(4),
   ename       varchar2(10),
   job         varchar2(9),
   mgr         number(4),
   hiredate    date,
   sal         number(7, 2),
   comm        number(7, 2)
  );
/

create or replace type emp_tab_type
  as table of emp_type
/



create table dept_and_emp
  (deptno number(2) primary key,
   dname     varchar2(14),
   loc       varchar2(13),
   emps      emp_tab_type
  )
  nested table emps store as emps_nt;


alter table emps_nt add constraint emps_empno_unique 
             unique(empno)
/



alter table emps_nt add constraint mgr_fk
 foreign key(mgr) references emps_nt(empno);


insert into dept_and_emp
  select dept.*,
     CAST( multiset( select empno, ename, job, mgr, hiredate, sal, comm
                       from scott.emp
                       where emp.deptno = dept.deptno ) AS emp_tab_type )
    from scott.dept
/


select deptno, dname, loc, d.emps AS employees
  from dept_and_emp d
  where deptno = 10
/



select d.deptno, d.dname, emp.*
  from dept_and_emp D, table(d.emps) emp
/


update
    table( select emps
             from dept_and_emp
                   where deptno = 10
             )
  set comm = 100
/


update
    table( select emps
             from dept_and_emp
               where deptno = 1
        )
  set comm = 100
/


update
    table( select emps
             from dept_and_emp
               where deptno > 1
        )
  set comm = 100
/

insert into table
  ( select emps from dept_and_emp where deptno = 10 )
  values
  ( 1234, 'NewEmp', 'CLERK', 7782, sysdate, 1200, null );

delete from table
 ( select emps from dept_and_emp where deptno = 20 )
   where ename = 'SCOTT';



select d.dname, e.empno, ename
  from dept_and_emp d, table(d.emps) e
  where d.deptno in ( 10, 20 );





SELECT /*+NESTED_TABLE_GET_REFS+*/
         NESTED_TABLE_ID,SYS_NC_ROWINFO$
  FROM "TKYTE"."EMPS_NT"
/



select name
    from sys.col$
   where obj# = ( select object_id
                   from user_objects
                   where object_name = 'DEPT_AND_EMP' )
/



select SYS_NC0000400005$ from dept_and_emp;




select /*+ nested_table_get_refs */ empno, ename
  from emps_nt where ename like '%A%';


update /*+ nested_table_get_refs */ emps_nt
  set ename = initcap(ename);


select /*+ nested_table_get_refs */ empno, ename
  from emps_nt where ename like '%a%';


select d.deptno, d.dname, emp.*
  from dept_and_emp D, table(d.emps) emp
/

