import java.sql.*;
import oracle.jdbc.driver.*;

public class dr_java
{
public static void test() throws SQLException
{ 
Connection cnx = new OracleDriver().defaultConnection();

String sql = 
      "SELECT MSG, sys_context('userenv','session_user'), "+
                  "sys_context('userenv','current_user'), "+
                  "sys_context('userenv','current_schema') "+
        "FROM T";

Statement stmt = cnx.createStatement();
ResultSet rset = stmt.executeQuery(sql);

    if (rset.next()) 
       System.out.println( rset.getString(1) + 
                          " session_user=" + rset.getString(2)+ 
                          " current_user=" + rset.getString(3)+
                          " current_schema =" + rset.getString(4) );
    rset.close();
    stmt.close();
}
}

