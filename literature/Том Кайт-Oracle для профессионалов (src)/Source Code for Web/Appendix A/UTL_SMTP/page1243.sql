set echo on


drop table demo;
create table demo ( theBlob blob );

create or replace directory my_files as 'c:\temp\';

declare
    l_blob  blob;
    l_bfile bfile;
begin
    insert into demo values ( empty_blob() )
    returning theBlob into l_blob;

    l_bfile := bfilename( 'MY_FILES', 'activation8i.zip' );
    dbms_lob.fileopen( l_bfile );

    dbms_lob.loadfromfile( l_blob, l_bfile,
                           dbms_lob.getlength( l_bfile ) );

    dbms_lob.fileclose( l_bfile );
end;
/
commit;


set serveroutput on size 1000000
exec dbms_java.set_output( 1000000 )

declare
  ret_code number;
begin
  for i in (select theBlob from demo )
  loop
    ret_code := send(
                  p_from => 'me@acme.com',
                  p_to => 'you@you.com',
                  p_cc => NULL,
                  p_bcc => NULL,
                  p_subject => 'Use the attached Zip file',
                  p_body => 'to send email with attachments....',
                  p_smtp_host => 'aria.us.oracle.com',
                  p_attachment_data => i.theBlob,
                  p_attachment_type => 'application/winzip',
                  p_attachment_file_name => 'mail8i.zip');
    if ret_code = 1 then
      dbms_output.put_line ('Successfully sent message...');
    else
      dbms_output.put_line ('Failed to send message...');
    end if;
  end loop;
end;
/

