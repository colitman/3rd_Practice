create or replace package global_variables
as
	x number;
end;
/

begin
	global_variables.x := 5;
end;
/

declare
	pragma autonomous_transaction;
begin
	global_variables.x := 10;
	commit;
end;
/

set serveroutput on
exec dbms_output.put_line( global_variables.x );
