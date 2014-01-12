CREATE OR REPLACE AND COMPILE
JAVA SOURCE NAMED "Util"
AS
import java.io.*;
import java.lang.*;

public class Util extends Object
{

  public static int RunThis(String[] args)
  {
  Runtime rt = Runtime.getRuntime();
  int        rc = -1;

  try
  {
     Process p = rt.exec(args[0]);

     int bufSize = 4096;
     BufferedInputStream bis =
      new BufferedInputStream(p.getInputStream(), bufSize);
     int len;
     byte buffer[] = new byte[bufSize];

     // Echo back what the program spit out
     while ((len = bis.read(buffer, 0, bufSize)) != -1)
        System.out.write(buffer, 0, len);

     rc = p.waitFor();
  }
  catch (Exception e)
  {
     e.printStackTrace();
     rc = -1;
  }
  finally
  {
     return rc;
  }
  }
}
/

  BEGIN
    DBMS_JAVA.GRANT_PERMISSION
    ( USER,
     'java.io.FilePermission',
     -- '/usr/bin/ps',  -- for UNIX
     'C:\WINNT\system32\cmd.EXE',  -- for WINDOWS
     'execute');

   DBMS_JAVA.GRANT_PERMISSION (
      USER,
     'java.lang.RuntimePermission',
     '*',
     'writeFileDescriptor' );
END;
/

CREATE OR REPLACE FUNCTION RUN_CMD (
   P_CMD IN VARCHAR2)
   RETURN NUMBER
AS
   LANGUAGE JAVA
      NAME 'Util.RunThis(java.lang.String[]) return integer';
/

CREATE OR REPLACE PROCEDURE RC (
   P_CMD IN VARCHAR2)
AS
   X                             NUMBER;
BEGIN
   X := RUN_CMD (P_CMD);

   IF (X <> 0)
   THEN
      RAISE PROGRAM_ERROR;
   END IF;
END;
/

SET serveroutput on size 1000000
EXEC dbms_java.set_output(1000000)

EXEC rc('C:\WINNT\system32\cmd.exe /c dir')
