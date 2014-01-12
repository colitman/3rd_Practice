set echo one
set serveroutput on

drop table emp;

create table emp as select * from scott.emp;
/

alter table emp 
add constraint emp_pk
primary key(empno)
/
 
 create table upper_ename
  ( x$ename, x$rid,
    primary key (x$ename,x$rid)
  )
  organization index
  as
  select upper(ename), rowid from emp;
/
 
 
 
 create or replace trigger upper_ename
  after insert or update or delete on emp
  for each row
  begin
      if (updating and (:old.ename||'x' <> :new.ename||'x'))
      then
          delete from upper_ename
           where x$ename = upper(:old.ename)
             and x$rid = :old.rowid;

          insert into upper_ename
          (x$ename,x$rid) values
          ( upper(:new.ename), :new.rowid );
      elsif (inserting)
      then
          insert into upper_ename
          (x$ename,x$rid) values
          ( upper(:new.ename), :new.rowid );
      elsif (deleting)
      then
          delete from upper_ename
           where x$ename = upper(:old.ename)
             and x$rid = :old.rowid;
      end if;
  end;
/

update emp set ename = initcap(ename);


commit;


 update
  (
  select ename, sal
    from emp
   where emp.rowid in ( select upper_ename.x$rid
                          from upper_ename
                         where x$ename = 'KING' )
  )
  set sal = 1234
/ 


  select ename, empno, sal
    from emp, upper_ename
   where emp.rowid = upper_ename.x$rid
     and upper_ename.x$ename = 'KING'
/

delete from
  (
  select ename, empno
    from emp
   where emp.rowid in ( select upper_ename.x$rid
                          from upper_ename
                         where x$ename = 'KING' )
  )
/