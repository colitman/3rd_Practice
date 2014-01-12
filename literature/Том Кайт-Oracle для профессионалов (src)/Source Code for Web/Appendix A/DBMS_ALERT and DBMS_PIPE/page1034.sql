set echo on

exec dbms_alert.signal( 'MyAlert', 'Hello World' );
commit;