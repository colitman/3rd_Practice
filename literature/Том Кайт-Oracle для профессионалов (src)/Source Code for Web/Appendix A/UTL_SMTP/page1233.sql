
create or replace package mail_pkg
as
    type array is table of varchar2(255);

    procedure send( p_sender_email in varchar2,
                    p_from         in varchar2,
                    p_to           in array default array(),
                    p_cc           in array default array(),
                    p_bcc          in array default array(),
                    p_subject      in varchar2,
                    p_body         in long );
end;
/



create or replace package body mail_pkg
as

g_crlf        char(2) default chr(13)||chr(10);
g_mail_conn   utl_smtp.connection;
g_mailhost    varchar2(255) := 'yourmailserver.host';

function address_email( p_string in varchar2,
                        p_recipients in array ) return varchar2
is
    l_recipients long;
begin
   for i in 1 .. p_recipients.count
   loop
      utl_smtp.rcpt(g_mail_conn, p_recipients(i) );
      if ( l_recipients is null ) 
      then
          l_recipients := p_string || p_recipients(i) ;
      else
          l_recipients := l_recipients || ', ' || p_recipients(i);
      end if;
   end loop;
   return l_recipients;
end;


procedure send( p_sender_email in varchar2,
                p_from         in varchar2 default NULL,
                p_to           in array default array(),
                p_cc           in array default array(),
                p_bcc          in array default array(),
                p_subject      in varchar2 default NULL,
                p_body         in long  default NULL )
is
    l_to_list   long;
    l_cc_list   long;
    l_bcc_list  long;
    l_date      varchar2(255) default
                to_char( SYSDATE, 'dd Mon yy hh24:mi:ss' );

    procedure writeData( p_text in varchar2 )
    as
    begin
        if ( p_text is not null ) 
        then
            utl_smtp.write_data( g_mail_conn, p_text || g_crlf );
        end if;
    end;
begin
    g_mail_conn := utl_smtp.open_connection(g_mailhost, 25);

    utl_smtp.helo(g_mail_conn, g_mailhost);
    utl_smtp.mail(g_mail_conn, p_sender_email);

    l_to_list  := address_email( 'To: ', p_to );
    l_cc_list  := address_email( 'Cc: ', p_cc );
    l_bcc_list := address_email( 'Bcc: ', p_bcc );

    utl_smtp.open_data(g_mail_conn );

    writeData( 'Date: ' || l_date );
    writeData( 'From: ' || nvl( p_from, p_sender_email ) );
    writeData( 'Subject: ' || nvl( p_subject, '(no subject)' ) );

    writeData( l_to_list );
    writeData( l_cc_list );

    utl_smtp.write_data( g_mail_conn, '' || g_crlf ); 
    utl_smtp.write_data(g_mail_conn, p_body );
    utl_smtp.close_data(g_mail_conn );
    utl_smtp.quit(g_mail_conn);
end;


end;
/


begin
    mail_pkg.send
    ( p_sender_email => 'me@acme.com',
      p_from => 'Oracle Database Account <me@acme.com>',
      p_to => mail_pkg.array( 'coyote@acme.com', 'roadrunner@acme.com' ),
      p_cc => mail_pkg.array( 'kermit@acme.com' ),
      p_bcc => mail_pkg.array( 'noone@dev.null' ),
      p_subject => 'This is a subject',
      p_body => 'Hello Tom, this is the mail you need' );
end;
/
