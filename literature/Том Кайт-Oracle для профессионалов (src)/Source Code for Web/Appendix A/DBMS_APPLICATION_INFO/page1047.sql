desc v$session_longops

declare
    l_nohint number default dbms_application_info.set_session_longops_nohint;
    l_rindex number default l_nohint;
    l_slno   number;
begin
    for i in 1 .. 25
    loop
        dbms_lock.sleep(2);
        dbms_application_info.set_session_longops
        ( rindex =>  l_rindex,
          slno   =>  l_slno,
          op_name => 'my long running operation',
          target  =>  1234,
          target_desc => '1234 is my target',
          context     => 0,
          sofar       => i,
          totalwork   => 25,
          units       => 'loops'
        );
    end loop;
end;
/