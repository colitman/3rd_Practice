-- this is the code for the caveat section so it will show errors 

CREATE OR REPLACE FUNCTION RUN_CMD (
   P_CMD IN VARCHAR2)
   RETURN NUMBER
AS
   LANGUAGE JAVA
      NAME 'Util.RunThis(String[]) return integer';
/


 EXEC RC('c:\winnt\system32\cmd.exe /c dir')
