set echo on

begin
    dbms_alert.register( 'MyAlert' );
end;
/

set serveroutput on
declare
    l_status    number;
    l_msg       varchar2(1800);
begin
    dbms_alert.waitone( name    => 'MyAlert',
                        message => l_msg,
                        status  => l_status,
                        timeout => dbms_alert.maxwait );
  
    if ( l_status = 0 )
    then
        dbms_output.put_line( 'Msg from event is ' || l_msg );
    end if;
end;
/