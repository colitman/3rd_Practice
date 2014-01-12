set echo on

alter system archive log current;

update dept set deptno = 11 
 where deptno = 40
/

update dept set dname = initcap(dname)
 where deptno = 10
/
update dept set loc = initcap(loc)
 where deptno = 20
/

update dept set dname = initcap(dname),
                  loc = initcap(loc)
 where deptno = 30
/

commit;

alter system archive log current;