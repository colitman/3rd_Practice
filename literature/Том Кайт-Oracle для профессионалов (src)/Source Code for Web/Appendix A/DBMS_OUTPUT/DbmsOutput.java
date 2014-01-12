import java.sql.*;

class DbmsOutput 
{
/*
 * Our instance variables. It is always best to 
 * use callable or prepared statements, and prepare (parse)
 * them once per program execution, rather then once per 
 * execution in the program. The cost of reparsing is 
 * very high. Also, make sure to use BIND VARIABLES!
 *
 * We use three statements in this class. One to enable
 * DBMS_OUTPUT, equivalent to SET SERVEROUTPUT on in SQL*PLUS,
 * another to disable it, like SET SERVEROUTPUT OFF.
 * The last is to 'dump' or display the results from DBMS_OUTPUT
 * using system.out.
 *
 */
private CallableStatement enable_stmt;
private CallableStatement disable_stmt;
private CallableStatement show_stmt;


/* 
 * Our constructor simply prepares the three
 * statements we plan on executing.
 *
 * The statement we prepare for SHOW is a block of 
 * code to return a string of DBMS_OUTPUT output. Normally,
 * you might bind to a PL/SQL table type, but the JDBC drivers
 * don't support PL/SQL table types. Hence, we get the output
 * and concatenate it into a string. We will retrieve at least
 * one line of output, so we may exceed your MAXBYTES parameter
 * below. If you set MAXBYTES to 10, and the first line is 100
 * bytes long, you will get the 100 bytes. MAXBYTES will stop us
 * from getting yet another line, but it will not chunk up a line.
 *
 */
public DbmsOutput( Connection conn ) throws SQLException
{
    enable_stmt  = conn.prepareCall( "begin dbms_output.enable(:1); end;" );
    disable_stmt = conn.prepareCall( "begin dbms_output.disable; end;" );

    show_stmt = conn.prepareCall( 
          "declare " +
          "    l_line varchar2(255); " +
          "    l_done number; " +
          "    l_buffer long; " +
          "begin " +
          "  loop " +
          "    exit when length(l_buffer)+255 > :maxbytes OR l_done = 1; " +
          "    dbms_output.get_line( l_line, l_done ); " +
          "    l_buffer := l_buffer || l_line || chr(10); " +
          "  end loop; " +
          " :done := l_done; " +
          " :buffer := l_buffer; " +
          "end;" );
}

/*
 * ENABLE simply sets your size and executes
 * the DBMS_OUTPUT.ENABLE call
 *
 */
public void enable( int size ) throws SQLException
{
    enable_stmt.setInt( 1, size );
    enable_stmt.executeUpdate();
}

/*
 * DISABLE only has to execute the DBMS_OUTPUT.DISABLE call
 */
public void disable() throws SQLException
{
    disable_stmt.executeUpdate();
}

/*
 * SHOW does most of the work. It loops over
 * all of the DBMS_OUTPUT data, fetching it, in this
 * case, 32,000 bytes at a time (give or take 255 bytes).
 * It will print this output on STDOUT by default (just
 * reset what System.out is to change or redirect this 
 * output).
 */

public void show() throws SQLException
{
int               done = 0;

    show_stmt.registerOutParameter( 2, java.sql.Types.INTEGER );
    show_stmt.registerOutParameter( 3, java.sql.Types.VARCHAR );

    for(;;)
    {    
        show_stmt.setInt( 1, 32000 );
        show_stmt.executeUpdate();
        System.out.print( show_stmt.getString(3) );
        if ( (done = show_stmt.getInt(2)) == 1 ) break;
    }
}

/* 
 * CLOSE closes the callable statements associated with
 * the DbmsOutput class. Call this if you allocate a DbmsOutput
 * statement on the stack and it is going to go out of scope, 
 * just as you would with any callable statement, resultset,
 * and so on.
 */
public void close() throws SQLException
{
    enable_stmt.close();
    disable_stmt.close();
    show_stmt.close();
}
}