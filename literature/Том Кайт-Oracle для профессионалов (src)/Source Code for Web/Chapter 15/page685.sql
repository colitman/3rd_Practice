create or replace procedure child
as
        pragma autonomous_transaction;
        l_ename emp.ename%type;
begin
        select ename into l_ename 
		  from emp 
		 where ename = 'KING'
		   FOR UPDATE;
        commit;
end;
/

create or replace procedure parent
as
        l_ename emp.ename%type;
begin
        select ename into l_ename 
		  from emp 
		 where ename = 'KING'
		   FOR UPDATE;
        child;
        commit;
end;
/

exec parent
