set echo on
REM this is for UNIX


create sequence sm_seq
/



create or replace procedure sm( p_to in varchar2,
                                p_from in varchar2,
                                p_subject in varchar2,
                                p_body in varchar2 )
  is
      l_output        utl_file.file_type;
      l_filename      varchar2(255);
      l_request       varchar2(2000);
  begin
      select 'm' || sm_seq.nextval || '.EMAIL.' || p_to
      into l_filename
      from dual;
  
      l_output := utl_file.fopen
                  ( '/tmp', l_filename, 'w', 32000 );
  
      utl_file.put_line( l_output, 'From: ' || p_from );
      utl_file.put_line( l_output, 'Subject: ' || p_subject );
      utl_file.new_line( l_output );
      utl_file.put_line( l_output, p_body );
      utl_file.new_line( l_output );
      utl_file.put_line( l_output, '.' );
  
      utl_file.fclose( l_output );
  
      l_request := utl_http.request
                   ( 'http://127.0.0.1/cgi-bin/smail?' || l_filename );
  
      dbms_output.put_line( l_request );
  end sm;
/
