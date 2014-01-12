set echo on


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

set echo off
set heading off
set feedback off
spool examp03.java
select text from user_source where name = 'bad_code';
spool off

set heading on
set feedback on
set echo on

drop java source "bad_code";
select text from user_source where name = 'bad_code';

host loadjava -user tkyte/tkyte examp03.java

select text from user_source where name = 'bad_code';
