set echo on

exec sys.dbms_tts.transport_set_check( 'tts_ex1', TRUE );

select * from sys.transport_set_violations;

exec sys.dbms_tts.transport_set_check( 'tts_ex2', TRUE );

select * from sys.transport_set_violations;

exec sys.dbms_tts.transport_set_check( 'tts_ex1, tts_ex2', TRUE );

select * from sys.transport_set_violations;
/
