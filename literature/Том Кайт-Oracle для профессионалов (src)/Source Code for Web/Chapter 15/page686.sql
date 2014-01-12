create or replace procedure child
as
        pragma autonomous_transaction;
        l_ename emp.ename%type;
begin
        select ename into l_ename 
		  from emp 
		 where ename = 'KING'
		   FOR UPDATE;
end;
/

exec child
