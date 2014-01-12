create or replace
PROCEDURE send_mail (p_sender       IN VARCHAR2,
                     p_recipient IN VARCHAR2,
                     p_message   IN VARCHAR2)
as
   l_mailhost VARCHAR2(255) := 'mailserver.host';
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

begin
	send_mail( 'you2@acme.com',
	           'you@acme.com',
			   'Hello Tom' );
end;
/


	     
