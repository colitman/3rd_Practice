set serveroutput on size 1000000
exec dbms_java.set_output( 1000000 )

declare
  ret_code number;
begin
    ret_code := send(
                  p_from => 'me@here.com',
                  p_to => 'me@here.com',
                  p_cc => NULL,
                  p_bcc => NULL,
                  p_subject => 'Use the attached Zip file',
                  p_body => 'to send email with attachments....',
                  p_smtp_host => 'aria.us.oracle.com',
                  p_attachment_data => null,
                  p_attachment_type => null,
                  p_attachment_file_name => null );
    if ret_code = 1 then
      dbms_output.put_line ('Successful sent message...');
    else
      dbms_output.put_line ('Failed to send message...');
    end if;
end;
/