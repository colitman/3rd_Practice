set echo on

set linesize 20
set serveroutput on format wrapped
exec dbms_output.put_line( '     Hello     World     !!!!!' );
set serveroutput on format word_wrapped
exec dbms_output.put_line( '     Hello     World     !!!!!' );
set serveroutput on format truncated
exec dbms_output.put_line( '     Hello     World     !!!!!' );