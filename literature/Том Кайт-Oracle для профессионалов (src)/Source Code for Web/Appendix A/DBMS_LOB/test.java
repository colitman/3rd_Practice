import java.sql.*;
import java.io.*;
import oracle.jdbc.driver.*;
import oracle.sql.*;

// You need a table:
// create table demo ( id int primary key, theBlob blob );
// in order for this application to execute.

class Test {

public static void main (String args [])
   throws SQLException , FileNotFoundException, IOException
{
    DriverManager.registerDriver
      (new oracle.jdbc.driver.OracleDriver());

    Connection conn = DriverManager.getConnection
         ("jdbc:oracle:thin:@aria:1521:ora8i",
          "scott", "tiger");

    // If this program is to work, uncomment this next line!
    // conn.setAutoCommit(false);

    Statement stmt = conn.createStatement();

    // Insert an empty BLOB into the table
    // create it new for the very first time.
    stmt.execute
    ( "insert into demo (id,theBlob) " +
      "values (1,empty_blob())" );

    // Now, we will read it back out so we can
    // load it.
    ResultSet rset = stmt.executeQuery
                     ("SELECT theBlob " +
                        "FROM demo "+
                       "where id = 1 ");

    if(rset.next())
    {
        // Get the BLOB to load into.
        BLOB l_mapBLOB = ((OracleResultSet)rset).getBLOB(1);

        // Here is the data we will load into it.
        File binaryFile = new File("/tmp/binary.dat");
        FileInputStream instream =
              new FileInputStream(binaryFile);

        // We will load about 32 KB at a time. That's
        // the most dbms_lob can handle (PL/SQL limit).
        int chunk = 32000;
        byte[] l_buffer = new byte[chunk];

        int l_nread = 0;

        // We'll use the easy writeappend routine to add
        // our chunk of file to the end of the BLOB.
        OracleCallableStatement cstmt =
            (OracleCallableStatement)conn.prepareCall
            ( "begin dbms_lob.writeappend( :1, :2, :3 ); end;" );

        // Read and write, read and write, until done.
        cstmt.registerOutParameter( 1, OracleTypes.BLOB );
        while ((l_nread= instream.read(l_buffer)) != -1)
        {
            cstmt.setBLOB(  1, l_mapBLOB );
            cstmt.setInt(   2, l_nread );
            cstmt.setBytes( 3, l_buffer );

            cstmt.executeUpdate();

            l_mapBLOB = cstmt.getBLOB(1);
        }
        // Close up the input file and callable statement.
        instream.close();
        cstmt.close();
    }
    // Close out the statements.
    rset.close();
    stmt.close();
    conn.close ();
}

}