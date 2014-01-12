
set echo on

set serveroutput on


drop table emp

create table emp
     (EMPNO             NUMBER(4) NOT NULL,
      ENAME             VARCHAR2(10),
      JOB               VARCHAR2(9),
      MGR               NUMBER(4),
      HIREDATE          DATE,
      SAL               NUMBER(7,2),
      COMM              NUMBER(7,2),
      DEPTNO            NUMBER(2) NOT NULL,
      LOC               VARCHAR2(13) NOT NULL
     )
     partition by range(loc)
     (
     partition p1 values less than('C') tablespace p1,
     partition p2 values less than('D') tablespace p2,
     partition p3 values less than('N') tablespace p3,
     partition p4 values less than('Z') tablespace p4
     );
    

alter table emp add constraint emp_pk
    primary key(empno);
    

drop index emp_job_idx

create index emp_job_idx on emp(job)
    GLOBAL;

create index emp_dept_idx on emp(deptno)
    GLOBAL;
    
insert into emp
    select e.*, d.loc
      from scott.emp e, scott.dept d
     where e.deptno = d.deptno
    /	



select empno,job,loc from emp partition(p1);

select empno,job,loc from emp partition(p2);

select empno,job,loc from emp partition(p3);

select empno,job,loc from emp partition(p4);


 select empno,job,loc from emp where empno = 7782;

 