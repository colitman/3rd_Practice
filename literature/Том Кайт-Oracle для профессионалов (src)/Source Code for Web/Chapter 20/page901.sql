create or replace trigger EMPS_IO_UPDATE
instead of UPDATE on nested table emps of dept_or
begin
    if ( :new.empno = :old.empno )
    then
        update emp
           set ename = :new.ename, job = :new.job, mgr = :new.mgr,
            hiredate = :new.hiredate, sal = :new.sal, comm = :new.comm
         where empno = :old.empno;
    else
        raise_application_error(-20001,'Empno cannot be updated' );
    end if;
end;
/

update TABLE ( select p.emps
                 from dept_or p
                where deptno = 20 )
   set ename = lower(ename)
/

select ename from emp where deptno = 20;

select ename
  from TABLE( select p.emps
                from dept_or p
               where deptno = 20 );

declare
   l_emps  emp_tab_type;
begin
    select p.emps into l_emps
      from dept_or  p
     where deptno = 10;

    for i in 1 .. l_emps.count
    loop
        l_emps(i).ename := lower(l_emps(i).ename);
    end loop;
 
    update dept_or
       set emps = l_emps
     where deptno = 10;
end;
/


