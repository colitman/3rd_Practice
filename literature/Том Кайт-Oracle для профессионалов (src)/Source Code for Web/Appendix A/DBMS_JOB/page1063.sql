set echo on

create or replace
PROCEDURE send_mail (p_sender       IN VARCHAR2,
                     p_recipient IN VARCHAR2,
                     p_message   IN VARCHAR2)
as
   -- Note that you have to use a host
   -- that supports SMTP and that you have access to.
   -- You do not have access to this host and must change it
   l_mailhost VARCHAR2(255) := 'aria.us.oracle.com';
   l_mail_conn utl_smtp.connection;
BEGIN
   l_mail_conn := utl_smtp.open_connection(l_mailhost, 25);
   utl_smtp.helo(l_mail_conn, l_mailhost);
   utl_smtp.mail(l_mail_conn, p_sender);
   utl_smtp.rcpt(l_mail_conn, p_recipient);
   utl_smtp.open_data(l_mail_conn );
   utl_smtp.write_data(l_mail_conn, p_message);
   utl_smtp.close_data(l_mail_conn );
   utl_smtp.quit(l_mail_conn);
end;
/

set serveroutput on
declare
        l_start number := dbms_utility.get_time;
begin
        send_mail( 'someone@there.com',
                   'someone@there.com', 'hey there' );
        dbms_output.put_line
        ( round( (dbms_utility.get_time-l_start)/100, 2 ) ||
          ' seconds' );
end;
/
/