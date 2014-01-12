set echo on

drop table java$options;

disconnect
connect tkyte/tkyte

create or replace and compile
java source named "bad_code"
as
import java.sql.SQLException;

public class bad_code extends Object
{
public static void wont_work() throws SQLException
{
   #sql {
        insert into non_existent_table values ( 1 )
   };
}
}
/

show errors java source "bad_code"

disconnect 
connect tkyte/tkyte

column value format a10
column what format a10

select * from java$options;

begin
	dbms_java.set_compiler_option
	( what       => 'bad_code', 
	  optionName => 'online', 
	  value      => 'false' );
end;
/

select * from java$options;

create or replace and compile
java source named "bad_code"
as
import java.sql.SQLException;

public class bad_code extends Object
{
public static void wont_work() throws SQLException
{
   #sql {
        insert into non_existent_table values ( 1 )
   };
}
}
/

show errors java source "bad_code"

set serveroutput on
begin
	dbms_output.put_line
	( dbms_java.get_compiler_option( what       => 'bad_code', 
	                                 optionName => 'online' ) );
end;
/

begin
	dbms_java.reset_compiler_option( what       =>  'bad_code', 
	                                 optionName => 'online' );
end;
/

begin
	dbms_output.put_line
	( dbms_java.get_compiler_option( what       => 'bad_code', 
	                                 optionName => 'online' ) );
end;
/

select * from java$options;