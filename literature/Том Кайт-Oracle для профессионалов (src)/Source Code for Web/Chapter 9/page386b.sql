set autotrace on explain

update ( select /*+ ORDERED USE_NL(dept) */
           dept.dname        dept_dname, 
           dept.loc          dept_loc,
           dept.last_updated dept_last_updated,
           w.dname           w_dname, 
           w.loc             w_loc,
           w.last_updated    w_last_updated
          from dept_working W, dept
         where dept.deptno = w.deptno )
  set dept_dname = w_dname,
      dept_loc   = w_loc,
      dept_last_updated = w_last_updated
/

set autotrace off
