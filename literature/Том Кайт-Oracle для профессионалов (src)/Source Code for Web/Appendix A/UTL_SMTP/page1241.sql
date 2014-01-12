set echo on

create or replace function send(
    p_from                  in varchar2,
    p_to                    in varchar2,
    p_cc                    in varchar2,
    p_bcc                   in varchar2,
    p_subject               in varchar2,
    p_body                  in varchar2,
    p_smtp_host             in varchar2,
    p_attachment_data       in blob,
    p_attachment_type       in varchar2,
    p_attachment_file_name  in varchar2) return number
as
language java name 'mail.send( java.lang.String,
                               java.lang.String,
                               java.lang.String,
                               java.lang.String,
                               java.lang.String,
                               java.lang.String,
                               java.lang.String,
                               oracle.sql.BLOB,
                               java.lang.String,
                               java.lang.String
                             ) return oracle.sql.NUMBER';
/

begin
  dbms_java.grant_permission(
     grantee => 'USERNAME',
     permission_type => 'java.util.PropertyPermission',
     permission_name => '*',
     permission_action => 'read,write'
  );
  dbms_java.grant_permission(
     grantee => 'USERNAME',
     permission_type => 'java.net.SocketPermission',
     permission_name => '*',
     permission_action => 'connect,resolve'
  );
end;
/

