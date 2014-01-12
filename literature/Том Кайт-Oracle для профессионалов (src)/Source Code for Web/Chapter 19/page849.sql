CREATE OR REPLACE TYPE NUMARRAY AS TABLE OF NUMBER
/
CREATE OR REPLACE TYPE DATEARRAY AS TABLE OF DATE
/
CREATE OR REPLACE TYPE STRARRAY AS TABLE OF VARCHAR2 (255)
/

CREATE OR REPLACE PACKAGE DEMO_PASSING_PKG
AS
   /*
    * a series of overloaded procedures to test passing parameters
    * with.  Each routine has an IN and an OUT parameter
    * the external procedure will fill it in
    */

   -- Oracle Numbers will be passed to Java BigDecimal
   -- types.  They could be passed to ints, strings
   -- and other types but could suffer from the loss
   -- of precision.  BigDecimal can hold an Oracle number
   -- safely.
   PROCEDURE PASS (
      P_IN IN NUMBER,
      P_OUT OUT NUMBER)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( java.math.BigDecimal,
                                      java.math.BigDecimal[] )';

   -- Oracle Dates are mapped to the Timestamp type
   PROCEDURE PASS (
      P_IN IN DATE,
      P_OUT OUT DATE)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( java.sql.Timestamp,
                                      java.sql.Timestamp[] )';

   -- Varchar2's are most easily mapped to the java String type
   PROCEDURE PASS (
      P_IN IN VARCHAR2,
      P_OUT OUT VARCHAR2)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( java.lang.String,
                                      java.lang.String[] )';

   -- Clobs will be passed to the oracle.sql.CLOB type to allow
   -- all of the operations supported on them
   PROCEDURE PASS (
      P_IN IN CLOB,
      P_OUT IN OUT CLOB)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( oracle.sql.CLOB,
                                 oracle.sql.CLOB[] )';

   -- Collection variables will be mapped to the oracle.sql.ARRAY
   -- type, regardless of the base type
   PROCEDURE PASS (
      P_IN IN NUMARRAY,
      P_OUT OUT NUMARRAY)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass_num_array( oracle.sql.ARRAY,
                                                oracle.sql.ARRAY[] )';

   PROCEDURE PASS (
      P_IN IN DATEARRAY,
      P_OUT OUT DATEARRAY)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass_date_array( oracle.sql.ARRAY,
                                                 oracle.sql.ARRAY[] )';

   PROCEDURE PASS (
      P_IN IN STRARRAY,
      P_OUT OUT STRARRAY)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass_str_array( oracle.sql.ARRAY,
                                                oracle.sql.ARRAY[] )';

   /*
    * We cannot use overloading on the RAW and INT procedures
    * since pass( raw, raw ) would get confused with
    * pass(varchar,varchar2) and pass(int,int) gets confused with
    * pass(number,number).  Therefore, we make an exception for these
    * two and create named routines for them...
    */
   PROCEDURE PASS_RAW (
      P_IN IN RAW,
      P_OUT OUT RAW)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( byte[], byte[][] )';

   PROCEDURE PASS_INT (
      P_IN IN NUMBER,
      P_OUT OUT NUMBER)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass_int( int, int[] )';

   /*
    * Now for our functions, one to return each type of interesting
    * scalar type...
    */
   FUNCTION RETURN_NUMBER
      RETURN NUMBER
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.return_num() return 
	       java.math.BigDecimal';

   FUNCTION RETURN_DATE
      RETURN DATE
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.return_date() return 
	       java.sql.Timestamp';

   FUNCTION RETURN_STRING
      RETURN VARCHAR2
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.return_string() return  
	       java.lang.String';
END DEMO_PASSING_PKG;
/



CREATE OR REPLACE PACKAGE DEMO_PASSING_PKG
AS
   PROCEDURE PASS (
      P_IN IN NUMBER,
      P_OUT OUT NUMBER)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( java.math.BigDecimal,
                                      java.math.BigDecimal[] )';

   PROCEDURE PASS (
      P_IN IN DATE,
      P_OUT OUT DATE)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( java.sql.Timestamp,
                                      java.sql.Timestamp[] )';

   PROCEDURE PASS (
      P_IN IN VARCHAR2,
      P_OUT OUT VARCHAR2)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( java.lang.String,
                                      java.lang.String[] )';
 
   PROCEDURE PASS (
      P_IN IN CLOB,
      P_OUT IN OUT CLOB)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( oracle.sql.CLOB,
                                      oracle.sql.CLOB[] )';

   PROCEDURE PASS (
      P_IN IN NUMARRAY,
      P_OUT OUT NUMARRAY)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass_num_array( oracle.sql.ARRAY,
                                                oracle.sql.ARRAY[] )';

   PROCEDURE PASS (
      P_IN IN DATEARRAY,
      P_OUT OUT DATEARRAY)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass_date_array( oracle.sql.ARRAY,
                                                 oracle.sql.ARRAY[] )';

   PROCEDURE PASS (
      P_IN IN STRARRAY,
      P_OUT OUT STRARRAY)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass_str_array( oracle.sql.ARRAY,
                                                oracle.sql.ARRAY[] )';

   PROCEDURE PASS_RAW (
      P_IN IN RAW,
      P_OUT OUT RAW)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass( byte[], byte[][] )';

   PROCEDURE PASS_INT (
      P_IN IN NUMBER,
      P_OUT OUT NUMBER)
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.pass_int( int, int[] )';

   FUNCTION RETURN_NUMBER
      RETURN NUMBER
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.return_num() return java.math.BigDecimal';

   FUNCTION RETURN_DATE
      RETURN DATE
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.return_date() return java.sql.Timestamp';

   FUNCTION RETURN_STRING
      RETURN VARCHAR2
   AS
      LANGUAGE JAVA
         NAME 'demo_passing_pkg.return_string() return java.lang.String';
END DEMO_PASSING_PKG;
/
