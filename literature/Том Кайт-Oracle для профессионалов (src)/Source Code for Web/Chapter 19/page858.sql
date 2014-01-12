CREATE GLOBAL TEMPORARY TABLE DIR_LIST
( FILENAME VARCHAR2(255) )
ON COMMIT DELETE ROWS
/

CREATE OR REPLACE
   AND COMPILE java  source named "DirList"
AS

import java.io.*;
import java.sql.*;

public class DirList{

  public static void getList(String directory) throws SQLException{
    
    File path = new File( directory );
    String[] list = path.list();
    String element;

    for(int i = 0; i < list.length; i++){

      element = list[i];
      #sql {
        INSERT INTO DIR_LIST (FILENAME)
        VALUES (:element) };
    }
  }
}
/

CREATE OR REPLACE PROCEDURE GET_DIR_LIST (
   P_DIRECTORY IN VARCHAR2)
AS
   LANGUAGE JAVA
      NAME 'DirList.getList( java.lang.String )';
/

EXEC get_dir_list( 'c:\temp' );

BEGIN
   DBMS_JAVA.GRANT_PERMISSION (
      USER,
      'java.io.FilePermission',
      'c:\temp',
      'read');
END;
/

EXEC get_dir_list( 'c:\temp' );

SELECT *
  FROM DIR_LIST
 WHERE ROWNUM < 5;
