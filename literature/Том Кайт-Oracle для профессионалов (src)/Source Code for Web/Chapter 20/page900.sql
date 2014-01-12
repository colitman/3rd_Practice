

update TABLE ( select p.emps
                 from dept_or p
                where deptno = 20 )
   set ename = lower(ename)
/


update dept_or
   set dname = 'Research'
 where deptno = 20
/


select dname, d.emps
  from dept_or d
/


select deptno, dname, loc, count(*)
  from dept_or d, table ( d.emps )
  group by deptno, dname, loc
/

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
