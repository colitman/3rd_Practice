SET echo on


CREATE OR REPLACE AND COMPILE
JAVA SOURCE NAMED "demo"
AS
import java.sql.SQLException;

public class demo extends Object
{

static int counter = 0;

public static int IncrementCounter() throws SQLException
{
    System.out.println( "Enter IncrementCounter, counter = "+counter);
    if ( ++counter >= 3 )
    {
        System.out.println( "Error! counter="+counter);
        #sql {
        begin raise_application_error( -20001, 'Too many calls' ); end;
        };
    }
    System.out.println( "Exit IncrementCounter, counter = "+counter);
    return counter;
}
}
/


CREATE OR REPLACE AND COMPILE
JAVA SOURCE NAMED "demo2"
AS

public class demo2 extends Object
{

public static int my_routine() 
{
    System.out.println( "Enter my_routine" );

    return counter;
}
}
/
SHOW errors java source "demo2"

CREATE OR REPLACE FUNCTION JAVA_COUNTER
   RETURN NUMBER
AS
   LANGUAGE JAVA
      NAME 'demo.IncrementCounter() return integer';
/

SET serveroutput on

EXEC dbms_output.put_line( java_counter );

EXEC dbms_output.put_line( java_counter );

EXEC dbms_output.put_line( java_counter );
