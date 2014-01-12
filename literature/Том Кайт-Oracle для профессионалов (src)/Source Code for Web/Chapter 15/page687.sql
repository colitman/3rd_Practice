create or replace procedure child
as
        pragma autonomous_transaction;
        l_ename emp.ename%type;
begin
	
	update emp set ename = 'y' where ename = 'BLAKE';
	rollback to Parent_Savepoint;
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
	rollback;
end;
/

exec parent
