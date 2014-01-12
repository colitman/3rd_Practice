set echo on

set serveroutput on

begin
   sys.dbms_logmnr_d.build( 'miner_dictionary.dat',
                            'c:\temp' );
end;
/