drop table emp;

create table emp as select * from scott.emp;


create or replace procedure child
as
        pragma autonomous_transaction;
        l_ename emp.ename%type;
begin

	update emp set ename = 'y' where ename = 'BLAKE';
    savepoint child_savepoint;
	update emp set ename = 'z' where ename = 'SMITH';
	rollback to child_savepoint;
	commit;
end;
/

create or replace procedure parent
as
        l_ename emp.ename%type;
begin
	savepoint Parent_Savepoint;
	update emp set ename = 'x' where ename = 'KING';

   	child;
	commit;
end;
/
select ename 
  from emp 
 where ename in ( 'x', 'y', 'z', 'BLAKE', 'SMITH', 'KING' );

exec parent

select ename 
  from emp 
 where ename in ( 'x', 'y', 'z', 'BLAKE', 'SMITH', 'KING' );
