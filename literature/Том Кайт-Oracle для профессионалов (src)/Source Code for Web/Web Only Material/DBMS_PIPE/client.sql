set echo on

create global temporary table host_tmp
( msg  varchar2(4000),
  pipe varchar2(255)
)
/

create or replace procedure host( cmd in varchar2 )
as
    status number;
    resp   long;
    answer_pipe varchar2(255)
                default replace(dbms_pipe.unique_session_name,'$','_');
begin
    -- Send to the 'server' a pipe to answer on and
    -- the command we would like to run.
    dbms_pipe.pack_message( answer_pipe );
    dbms_pipe.pack_message( cmd );
 
    -- Send that message to the server.
    status := dbms_pipe.send_message( 'HOST_PIPE' );
    if ( status <> 0 )
    then
      raise_application_error( -20001, 'Pipe error' );
    end if;
  
    -- Now, wait for the response back from the server.
    status := dbms_pipe.receive_message( answer_pipe );
    if ( status <> 0 )
    then
      raise_application_error( -20001, 'Pipe error' );
    end if;

    -- Our 'protocol' says that the only thing
    -- the server will write back to us is the head
    -- of the output of our command.
    dbms_pipe.unpack_message( resp );
  
    -- Here, we just 'print' the response out...
    dbms_output.put_line( substr( resp, 1, 80 ) );
end;
/