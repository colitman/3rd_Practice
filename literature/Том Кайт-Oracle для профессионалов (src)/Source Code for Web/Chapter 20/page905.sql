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


declare
   l_emps  emp_tab_type;
begin
    select p.emps into l_emps
      from dept_or  p
     where deptno = 10;


    for i in 1 .. l_emps.count
    loop
        if ( l_emps(i).ename = 'miller' )
        then
            l_emps.delete(i);
        else
            l_emps(i).ename := initcap( l_emps(i).ename );
        end if;
    end loop;

    l_emps.extend;
    l_emps(l_emps.count) :=
       emp_type(1234, 'Tom', 'Boss',
                 null, sysdate, 1000, 500 );

    update dept_or
       set emps = l_emps
     where deptno = 10;
end;
/

update dept_or set dname = initcap(dname);


rollback;

