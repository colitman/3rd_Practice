set echo on

set define off

/*
        // Create the first part which is the message itself.
        // Create the second part. If the caller didn't
        // indicate what type of attachment this
        // is, then default it to a generic binary stream.
        // If we didn't get a file name then
        // default that as well.
        // Create a container then add the two parts.
        // Next, add the container to the message.
*/

create or replace and compile
java source named "mail"
as
import java.io.*;
import java.sql.*;
import java.util.Properties;
import java.util.Date;
import javax.activation.*;
import javax.mail.*;
import javax.mail.internet.*;
import oracle.jdbc.driver.*;
import oracle.sql.*;

public class mail
{
  static String dftMime = "application/octet-stream";
  static String dftName = "filename.dat";

  public static oracle.sql.NUMBER 
                       send(String from,
                            String to,
                            String cc,
                            String bcc,
                            String subject,
                            String body,
                            String SMTPHost,
                            oracle.sql.BLOB attachmentData,
                            String attachmentType,
                            String attachmentFileName)
  {
    int rc = 0;

    try
    {
      Properties props = System.getProperties();
      props.put("mail.smtp.host", SMTPHost);
      Message msg =
        new MimeMessage(Session.getDefaultInstance(props, null));

      msg.setFrom(new InternetAddress(from));

      if (to != null && to.length() > 0)
        msg.setRecipients(Message.RecipientType.TO,
                          InternetAddress.parse(to, false));

      if (cc != null && cc.length() > 0)
        msg.setRecipients(Message.RecipientType.CC,
                          InternetAddress.parse(cc, false));

      if (bcc != null && bcc.length() > 0)
        msg.setRecipients(Message.RecipientType.BCC,
                          InternetAddress.parse(bcc, false));

	  if ( subject != null && subject.length() > 0 )
      	   msg.setSubject(subject);
	  else msg.setSubject("(no subject)");

      msg.setSentDate(new Date());

      if (attachmentData != null)
      {
        MimeBodyPart mbp1 = new MimeBodyPart();
        mbp1.setText((body != null ? body : ""));
        mbp1.setDisposition(Part.INLINE);

        MimeBodyPart mbp2 = new MimeBodyPart();
        String type =
            (attachmentType != null ? attachmentType : dftMime);

        String fileName = (attachmentFileName != null ?
                           attachmentFileName : dftName);

        mbp2.setDisposition(Part.ATTACHMENT);
        mbp2.setFileName(fileName);

        mbp2.setDataHandler(new
           DataHandler(new BLOBDataSource(attachmentData, type))
        );

        MimeMultipart mp = new MimeMultipart();
        mp.addBodyPart(mbp1);
        mp.addBodyPart(mbp2);
        msg.setContent(mp);
      }
      else
      {
        msg.setText((body != null ? body : ""));
      }
      Transport.send(msg);
      rc = 1;
    } catch (Exception e)
    {
      e.printStackTrace();
      rc = 0;
    } finally
    {
      return new oracle.sql.NUMBER(rc);
    }
  }

  // Nested class that implements a DataSource.
  static class BLOBDataSource implements DataSource
  {
    private BLOB   data;
    private String type;

    BLOBDataSource(BLOB data, String type)
    {
        this.type = type;
        this.data = data;
    }

    public InputStream getInputStream() throws IOException
    {
      try
      {
        if(data == null)
          throw new IOException("No data.");

        return data.getBinaryStream();
      } catch(SQLException e)
      {
        throw new
        IOException("Cannot get binary input stream from BLOB.");
      }
    }

    public OutputStream getOutputStream() throws IOException
    {
      throw new IOException("Cannot do this.");
    }

    public String getContentType()
    {
      return type;
    }

    public String getName()
    {
      return "BLOBDataSource";
    }
  }
}
/

