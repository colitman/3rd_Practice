create or replace trigger DEPT_OR_IO_UPDATE
instead of update on dept_or
begin
    if ( :new.deptno = :old.deptno )
    then
        if updating('DNAME') or updating('LOC')
        then
           update dept
              set dname = :new.dname, loc = :new.loc
            where deptno = :new.deptno;
        end if;

        if ( updating('EMPS') )
        then
           delete from emp
            where empno in
            ( select empno
                from TABLE(cast(:old.emps as emp_tab_type))
               MINUS
                select empno
                  from TABLE(cast(:new.emps as emp_tab_type))
            );
           dbms_output.put_line( 'deleted ' || sql%rowcount );

           update emp E
              set ( deptno, ename, job, mgr,
                    hiredate, sal, comm ) =
                  ( select :new.deptno, ename, job, mgr,
                           hiredate, sal, comm
                      from TABLE(cast(:new.emps as emp_tab_type)) T
                     where T.empno = E.empno
                  )
            where empno in
              ( select empno
                  from (select *
                          from TABLE(cast(:new.emps as emp_tab_type))
                          MINUS
                         select *
                           from TABLE(cast(:old.emps as emp_tab_type))
                        )
              );
           dbms_output.put_line( 'updated ' || sql%rowcount );

           insert into emp
           ( deptno, empno, ename, job, mgr, hiredate, sal, comm )
           select :new.deptno,empno,ename,job,mgr,hiredate,sal,comm
             from ( select *
                      from TABLE(cast(:new.emps as emp_tab_type))
                     where empno in
                        ( select empno
                            from TABLE(cast(:new.emps as emp_tab_type))
                            MINUS
                          select empno
                            from TABLE(cast(:old.emps as emp_tab_type))
                        )
                  );
           dbms_output.put_line( 'inserted ' || sql%rowcount );
        else
           dbms_output.put_line( 'Skipped processing nested table' );
        end if;
    else
        raise_application_error(-20001,'deptno cannot be udpated' );
    end if;
end;
/

