SET define off

CREATE OR REPLACE AND COMPILE
JAVA SOURCE NAMED "demo_passing_pkg"
AS
import java.io.*;
import java.sql.*;
import java.math.*;
import oracle.sql.*;
import oracle.jdbc.driver.*;

public class demo_passing_pkg extends Object{

/*
 * this demonstrates the way to pass an OUT parameter
 * to Java -- we pass an "array" and the first element
 * in the array is the only thing we can touch -- if
 * we modify the value in the array, we will have modified
 * the OUT parameter.
 *
 * that is why all of these methods second parameter is an
 * array of the type.  p_out[0] is something we can set
 * and it will be sent "out" of the method.  Any changes
 * we make to p_in will not be returned
 */

public static void pass( java.math.BigDecimal p_in,
                         java.math.BigDecimal[] p_out ){
      
    /*
     * Notice the lack of need of an indicator!  Java
     * supports nullality in its object types as well.
     * It is not tri-valued logic like SQL -- don't get
     * confused and try to code something like that in
     * PLSQL -- it'll never work
     */
    
  if ( p_in != null ){
       
  /*
  * We can use the various methods associated with
  * the standard BigDecimal class to manipulate
  * the inputs/outputs.  Here I use toString to print
  * it and negate to assign the negative value to the
  * out parameter...
  */
        
     System.out.println
        
    ( "The first parameter is " + p_in.toString() );

    p_out[0] = p_in.negate();

    System.out.println
    ( "Set out parameter to " + p_out[0].toString() );
   }
}


public static void pass( java.sql.Timestamp p_in,
                         java.sql.Timestamp[] p_out ){
   
   /*
    * This is virtually identical to the above routine but
    * we use the methods of the Timestamp class to manipulate
    * the date
    *
    * our goal is to add one month to the date...
    */
   
       if ( p_in != null ){
        
	System.out.println
        ( "The first parameter is " + p_in.toString() );

        p_out[0] = p_in;

        if ( p_out[0].getMonth() < 11 )
             p_out[0].setMonth( p_out[0].getMonth()+1 );
        else{
             p_out[0].setMonth( 0 );
             p_out[0].setYear( p_out[0].getYear()+1 );
    }
        
	System.out.println
        ( "Set out parameter to " + p_out[0].toString() );
    }
}

public static void pass( java.lang.String p_in,
                         java.lang.String[] p_out ){

    /*
     * the simplest of datatypes -- the String.  If you remember
     * the C version with 6 formal parameters, null indicators,
     * strlen's, strcpy's and so on -- this is trivial in
     * comparision
     */

    if ( p_in != null ){
        
	System.out.println
        ( "The first parameter is " + p_in.toString() );

        p_out[0] = p_in.toUpperCase();

        System.out.println
        ( "Set out parameter to " + p_out[0].toString() );
    }
}


public static void pass( oracle.sql.CLOB p_in,
                         oracle.sql.CLOB[] p_out )
throws SQLException, IOException{

    /*
     * Here we have a little bit of work to do.  This is
     * implementing a "copy" routine to show how to pass
     * lobs back and forth.
     */

    if ( p_in != null && p_out[0] != null ){

        System.out.println
        ( "The first parameter is " + p_in.length() );
        System.out.println
        ( "The first parameter is '" +
           p_in.getSubString(1,80) + "'" );

        /*
         * to modify the contents of the Lob, we'll use standard
         * java input/output stream types
         * "is" is my input stream and "os" is the
         * output stream.
         */
       
	Reader is = p_in.getCharacterStream();
        Writer os = p_out[0].getCharacterOutputStream();

        /*
         * we'll do this 8k at a time.  just loop, read, write
         * exit when no more to read...
         */
        
	char buffer[] = new char[8192];
        int length;

        while( (length=is.read(buffer,0,8192)) != -1 )
            os.write(buffer,0,length);

        is.close();
        os.close();

        System.out.println
        ( "Set out parameter to " +
           p_out[0].getSubString(1,80) );
   }
}

/*
 * Internal (private) routine to show you what the array
 * holds..
 */

private static void show_array_info( oracle.sql.ARRAY p_in )
throws SQLException{

    System.out.println( "Array is of type      " +
                         p_in.getSQLTypeName() );
    System.out.println( "Array is of type code " +
                         p_in.getBaseType() );
    System.out.println( "Array is of length    " +
                         p_in.length() );
}

/*
 * Arrays are easy once you figure out how to get the data
 * OUT and then back in.
 *
 * getting the data out is easy -- the "getArray()" method will
 * return the base data array for us.
 *
 * putting the data back into an array is a little more complex.
 * we must create a descriptor (meta-data) about the array and then
 * create a new array object with that descriptor and the associated
 * values. The following shows both operations:
 */

public static void pass_num_array( oracle.sql.ARRAY p_in,
                                   oracle.sql.ARRAY[] p_out )
throws SQLException{

    show_array_info( p_in );
    java.math.BigDecimal[] values = (BigDecimal[])p_in.getArray();

    for( int i = 0; i < p_in.length(); i++ )
        System.out.println( "p_in["+i+"] = " + values[i].toString() );

    Connection conn = new OracleDriver().defaultConnection();
    ArrayDescriptor descriptor =
       ArrayDescriptor.createDescriptor( p_in.getSQLTypeName(), conn );

    p_out[0] = new ARRAY( descriptor, conn, values );
}

public static void
pass_date_array( oracle.sql.ARRAY p_in, oracle.sql.ARRAY[] p_out )
throws SQLException{

    show_array_info( p_in );
    java.sql.Timestamp[] values = (Timestamp[])p_in.getArray();

    for( int i = 0; i < p_in.length(); i++ )
        System.out.println( "p_in["+i+"] = " + values[i].toString() );

    Connection conn = new OracleDriver().defaultConnection();
    ArrayDescriptor descriptor =
       ArrayDescriptor.createDescriptor( p_in.getSQLTypeName(), conn );

    p_out[0] = new ARRAY( descriptor, conn, values );

}

public static void
pass_str_array( oracle.sql.ARRAY p_in, oracle.sql.ARRAY[] p_out )
throws java.sql.SQLException,IOException{

    show_array_info( p_in );
    String[] values = (String[])p_in.getArray();

    for( int i = 0; i < p_in.length(); i++ )
        System.out.println( "p_in["+i+"] = " + values[i] );

    Connection conn = new OracleDriver().defaultConnection();
    ArrayDescriptor descriptor =
       ArrayDescriptor.createDescriptor( p_in.getSQLTypeName(), conn );

    p_out[0] = new ARRAY( descriptor, conn, values );

}

/*
 * passing raw data is, much like the String type, trivial.
 */

public static void pass( byte[] p_in, byte[][] p_out ){

    if ( p_in != null )
        p_out[0] = p_in;
}

/*
 * Passing ints is PROBLEMATIC and I do not suggest it.
 * there is no way to pass NULL -- int's are "base datatypes"
 * in java, they are not objects -- they cannot be null.  Since
 * there is no concept of a null indicator here -- we would have
 * to actually pass our own if we wanted to support nulls and the PLSQL
 * layer would have to check a flag to see if the variable was
 * null or not.
 *
 * This is here for completeness but might not be a good idea,
 * especially for IN parameters -- the java routine cannot tell
 * that it should not be reading the value!
 */
public static void pass_int( int p_in, int[] p_out ){

    System.out.println
    ( "The in parameter was " + p_in );

    p_out[0] = p_in;

    System.out.println
    ( "The out parameter is " + p_out[0] );
}

/*
 * for completeness, this shows how to return each of the
 * basic types.  Again, this is much easier than in C
 */

public static String return_string(){
    return "Hello World";
}

public static java.sql.Timestamp return_date(){
    return new java.sql.Timestamp(0);
}

public static java.math.BigDecimal return_num(){
    return new java.math.BigDecimal( "44.3543" );
}

}
/



CREATE OR REPLACE AND COMPILE
JAVA SOURCE NAMED "demo_passing_pkg"
AS
import java.io.*;
import java.sql.*;
import java.math.*;
import oracle.sql.*;
import oracle.jdbc.driver.*;

public class demo_passing_pkg extends Object
{
public static void pass( java.math.BigDecimal p_in,
                         java.math.BigDecimal[] p_out )
{
    if ( p_in != null )
    {
        System.out.println
        ( "The first parameter is " + p_in.toString() );

        p_out[0] = p_in.negate();

        System.out.println
        ( "Set out parameter to " + p_out[0].toString() );
    }
}

public static void pass( java.sql.Timestamp p_in,
                         java.sql.Timestamp[] p_out )
{
    if ( p_in != null )
    {
        System.out.println
        ( "The first parameter is " + p_in.toString() );

        p_out[0] = p_in;

        if ( p_out[0].getMonth() < 11 )
            p_out[0].setMonth( p_out[0].getMonth()+1 );
        else
        {
            p_out[0].setMonth( 0 );
            p_out[0].setYear( p_out[0].getYear()+1 );
        }
        System.out.println
        ( "Set out parameter to " + p_out[0].toString() );
    }
}

public static void pass( java.lang.String p_in,
                         java.lang.String[] p_out )
{
    if ( p_in != null )
    {
        System.out.println
        ( "The first parameter is " + p_in.toString() );

        p_out[0] = p_in.toUpperCase();

        System.out.println
        ( "Set out parameter to " + p_out[0].toString() );
    }
}

public static void pass( oracle.sql.CLOB p_in,
                         oracle.sql.CLOB[] p_out )
throws SQLException, IOException
{
    if ( p_in != null && p_out[0] != null )
    {
        System.out.println
        ( "The first parameter is " + p_in.length() );
        System.out.println
        ( "The first parameter is '" +
           p_in.getSubString(1,80) + "'" );

        Reader is = p_in.getCharacterStream();
        Writer os = p_out[0].getCharacterOutputStream();

        char buffer[] = new char[8192];
        int length;

        while( (length=is.read(buffer,0,8192)) != -1 )
            os.write(buffer,0,length);

        is.close();
        os.close();

        System.out.println
        ( "Set out parameter to " +
           p_out[0].getSubString(1,80) );
    }
}

private static void show_array_info( oracle.sql.ARRAY p_in )
throws SQLException
{
    System.out.println( "Array is of type      " +
                         p_in.getSQLTypeName() );
    System.out.println( "Array is of type code " +
                         p_in.getBaseType() );
    System.out.println( "Array is of length    " +
                         p_in.length() );
}

public static void pass_num_array( oracle.sql.ARRAY p_in,
                                   oracle.sql.ARRAY[] p_out )
throws SQLException
{
    show_array_info( p_in );
    java.math.BigDecimal[] values = (BigDecimal[])p_in.getArray();

    for( int i = 0; i < p_in.length(); i++ )
        System.out.println( "p_in["+i+"] = " + values[i].toString() );

    Connection conn = new OracleDriver().defaultConnection();
    ArrayDescriptor descriptor =
       ArrayDescriptor.createDescriptor( p_in.getSQLTypeName(), conn );

    p_out[0] = new ARRAY( descriptor, conn, values );

}

public static void
pass_date_array( oracle.sql.ARRAY p_in, oracle.sql.ARRAY[] p_out )
throws SQLException
{
    show_array_info( p_in );
    java.sql.Timestamp[] values = (Timestamp[])p_in.getArray();

    for( int i = 0; i < p_in.length(); i++ )
        System.out.println( "p_in["+i+"] = " + values[i].toString() );

    Connection conn = new OracleDriver().defaultConnection();
    ArrayDescriptor descriptor =
       ArrayDescriptor.createDescriptor( p_in.getSQLTypeName(), conn );

    p_out[0] = new ARRAY( descriptor, conn, values );

}

public static void
pass_str_array( oracle.sql.ARRAY p_in, oracle.sql.ARRAY[] p_out )
throws java.sql.SQLException,IOException
{
    show_array_info( p_in );
    String[] values = (String[])p_in.getArray();

    for( int i = 0; i < p_in.length(); i++ )
        System.out.println( "p_in["+i+"] = " + values[i] );

    Connection conn = new OracleDriver().defaultConnection();
    ArrayDescriptor descriptor =
       ArrayDescriptor.createDescriptor( p_in.getSQLTypeName(), conn );

    p_out[0] = new ARRAY( descriptor, conn, values );

}

public static void pass( byte[] p_in, byte[][] p_out )
{
    if ( p_in != null )
        p_out[0] = p_in;
}

public static void pass_int( int p_in, int[] p_out )
{
    System.out.println
    ( "The in parameter was " + p_in );

    p_out[0] = p_in;

    System.out.println
    ( "The out parameter is " + p_out[0] );
}

public static String return_string()
{
    return "Hello World";
}

public static java.sql.Timestamp return_date()
{
    return new java.sql.Timestamp(0);
}

public static java.math.BigDecimal return_num()
{
    return new java.math.BigDecimal( "44.3543" );
}

}
/
SET define on
