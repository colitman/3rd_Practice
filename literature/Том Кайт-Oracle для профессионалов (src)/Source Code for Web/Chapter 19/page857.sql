SET serveroutput on size 1000000
EXEC dbms_java.set_output( 1000000 )

DECLARE
   L_IN                          STRARRAY := STRARRAY ();
   L_OUT                         STRARRAY := STRARRAY ();
BEGIN
   FOR I IN 1 .. 5
   LOOP
      L_IN.EXTEND;
      L_IN (I) := 'Element ' || I;
   END LOOP;

   DEMO_PASSING_PKG.PASS (L_IN, L_OUT);

   FOR I IN 1 .. L_OUT.COUNT
   LOOP
      DBMS_OUTPUT.PUT_LINE ('l_out('|| I || ') = ' || L_OUT (I) );
   END LOOP;
END;
/
