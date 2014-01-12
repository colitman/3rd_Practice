@connect blake/blake

declare
    l_AppCtx     dbms_session.AppCtxTabTyp;
    l_size        number;
begin
    dbms_session.list_context( l_AppCtx, l_size );
    for i in 1 .. l_size loop
        dbms_output.put( l_AppCtx(i).namespace || '.' );
        dbms_output.put( l_AppCtx(i).attribute || ' = ' );
        dbms_output.put_line( l_AppCtx(i).value );
    end loop;
end;
/

