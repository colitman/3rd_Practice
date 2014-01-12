create or replace package image_get
as
    -- You might have a procedure named
    -- after each type of document you want
    -- to get, for example:
    -- procedure pdf
    -- procedure doc
    -- procedure txt
    -- and so on. Some browsers (MS IE for example)
    -- seem to prefer file extensions over
    -- mime types when deciding how to handle
    -- documents.
    procedure gif( p_id in demo.id%type );
end;
/

create or replace package body image_get
as

procedure gif( p_id in demo.id%type )
is
    l_lob   blob;
    l_amt   number default 32000;
    l_off   number default 1;
    l_raw   raw(32000);
begin
  
    -- Get the LOB locator for
    -- our document.
    select theBlob into l_lob
      from demo
     where id = p_id;

    -- Print out the mime header for this
    -- type of document.
    owa_util.mime_header( 'image/gif' );

    begin
       loop
            dbms_lob.read( l_lob, l_amt, l_off, l_raw );

            -- It is vital to use htp.PRN to avoid
            -- spurious line feeds getting added to your
            -- document.
            htp.prn( utl_raw.cast_to_varchar2( l_raw ) );
            l_off := l_off+l_amt;
            l_amt := 32000;
        end loop;
    exception
        when no_data_found then
            NULL;
    end;
end;

end;
/