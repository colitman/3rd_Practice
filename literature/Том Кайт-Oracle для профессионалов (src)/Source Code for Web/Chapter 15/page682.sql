drop table emp;
create table emp as select * from scott.emp;

create or replace package my_pkg
as

	procedure run;

end;
/

create or replace package body my_pkg
as


cursor global_cursor is select ename from emp;


procedure show_results
is
	pragma autonomous_transaction;
	l_ename	emp.ename%type;
begin
	if ( global_cursor%isopen )
	then
		dbms_output.put_line( 'NOT already opened cursor' );
	else
		dbms_output.put_line( 'Already opened' );
		open global_cursor;
	end if;

	loop
		fetch global_cursor into l_ename;
		exit when global_cursor%notfound;
		dbms_output.put_line( l_ename );
	end loop;
	close global_cursor;
end;


procedure run
is
begin
	update emp set ename = 'x';

	open global_cursor;
	show_results;

	show_results;

	rollback;
end;

end;
/

exec my_pkg.run
