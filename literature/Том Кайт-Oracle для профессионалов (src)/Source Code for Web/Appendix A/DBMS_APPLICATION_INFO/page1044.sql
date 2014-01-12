declare
    l_owner varchar2(30) default 'SYS';
    l_cnt   number default 0;
begin
    dbms_application_info.set_client_info( 'owner='||l_owner );

    for x in ( select * from all_objects where owner = l_owner )
    loop
        l_cnt := l_cnt+1;
        dbms_application_info.set_action( 'processing row ' || l_cnt );
    end loop;
end;
/