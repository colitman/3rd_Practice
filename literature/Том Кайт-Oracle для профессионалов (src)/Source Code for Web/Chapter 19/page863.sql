CREATE OR REPLACE JAVA SOURCE
NAMED "MyTimestamp"
AS
import java.lang.String;
import java.sql.Timestamp;

public class MyTimestamp{

  public static String getTimestamp(){
    return (new Timestamp
           (System.currentTimeMillis())).toString();
  }
};
/

CREATE OR REPLACE FUNCTION MY_TIMESTAMP
   RETURN VARCHAR2
AS
   LANGUAGE JAVA
      NAME 'MyTimestamp.getTimestamp() return java.lang.String';
/

SELECT MY_TIMESTAMP, TO_CHAR (SYSDATE, 'yyyy-mm-dd hh24:mi:ss')
  FROM DUAL
/
