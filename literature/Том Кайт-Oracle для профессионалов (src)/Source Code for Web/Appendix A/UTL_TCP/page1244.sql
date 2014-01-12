set echo on
set serveroutput on

DECLARE
   c utl_tcp.connection; -- TCP/IP connection to the web server
   n number;
   buffer varchar2(255);
BEGIN
   c := utl_tcp.open_connection('proxy-server', 80);
   n := utl_tcp.write_line(c, 'GET http://www.wrox.com/ HTTP/1.0');
   n := utl_tcp.write_line(c);
   BEGIN
     LOOP
         n:=utl_tcp.read_text( c, buffer, 255 );
         dbms_output.put_line( buffer );
     END LOOP;
   EXCEPTION
     WHEN utl_tcp.end_of_input THEN
      NULL; -- end of input
   end;
   utl_tcp.close_connection(c);
END;
/

create or replace type SocketType
as object
(
    -- 'Private data', rather than you
    -- passing a context to each procedure, like you
    -- do with UTL_FILE.
    g_sock        number,

    -- A function to return a CRLF. Just a convenience.
    static function crlf return varchar2,

    -- Procedures to send data over a socket.
    member procedure send( p_data in varchar2 ),
    member procedure send( p_data in clob ),

    member procedure send_raw( p_data in raw ),
    member procedure send_raw( p_data in blob ),

    -- Functions to receive data from a socket. These return
    -- Null on eof. They will block waiting for data. If
    -- this is not desirable, use PEEK below to see if there
    -- is any data to read.
    member function recv return varchar2,
    member function recv_raw return raw,

    -- Convienence function. Reads data until a CRLF is found.
    -- Can strip the CRLF if you like (or not, by default).
    member function getline( p_remove_crlf in boolean default FALSE )
           return varchar2,

    -- Procedures to connect to a host and disconnect from a host.
    -- It is important to disconnect, else you will leak resources
    -- and eventually will not be able to connect.
    member procedure initiate_connection( p_hostname in varchar2,
                                             p_portno   in number ),
    member procedure close_connection,

    -- Function to tell you how many bytes (at least) might be
    -- ready to be read.
    member function peek return number
);
/

CREATE OR REPLACE PACKAGE simple_tcp_client
as
    -- A function to connect to a host. Returns a 'socket',
    -- which is really just a number.
    function connect_to( p_hostname in  varchar2,
                         p_portno   in  number ) return number;

    -- Send data. We only know how to send RAW data here. Callers
    -- must cast VARCHAR2 data to RAW. At the lowest level, all
    -- data on a socket is really just 'bytes'.

    procedure send( p_sock     in  number,
                    p_data     in  raw );

    -- recv will receive data.
    -- if maxlength is -1, we try for 4k of data. If maxlength
    -- is set to anything OTHER than -1, we attempt to
    -- read up to the length of p_data bytes. In other words,
    -- I restrict the receives to 4k unless otherwise told not to.
    procedure recv( p_sock      in   number,
                    p_data      out  raw,
                    p_maxlength in   number default -1 );

    -- Gets a line of data from the input socket. That is, data
    -- up to a \n.
    procedure getline( p_sock          in number,
                       p_data        out raw );


    -- Disconnects from a server you have connected to.
    procedure disconnect( p_sock     in number );

    -- Gets the server time in GMT in the format yyyyMMdd HHmmss z
    procedure get_gmt( p_gmt out varchar2 );

    -- Gets the server's timezone. Useful for some Internet protocols.
    procedure get_timezone( p_timezone   out varchar2 );

    -- Gets the hostname of the server you are running on. Again,
    -- useful for some Internet protocols.
    procedure get_hostname( p_hostname   out varchar2 );

    -- Returns the number of bytes available to be read.
    function peek( p_sock in number ) return number;

    -- base64 encodes a RAW. Useful for sending e-mail
    -- attachments, or doing HTTP which needs the user/password
    -- to be obscured using base64 encoding.
    procedure b64encode( p_data in raw, p_result out varchar2 );
end;
/

set define off
 
CREATE or replace and compile JAVA SOURCE
NAMED "jsock"
AS
import java.net.*;
import java.io.*;
import java.util.*;
import java.text.*;
import sun.misc.*;

public class jsock
{
static int           socketUsed[] = { 0,0,0,0,0,0,0,0,0,0 };
static Socket        sockets[] = new Socket[socketUsed.length];
static DateFormat    tzDateFormat = new SimpleDateFormat( "z" );
static DateFormat    gmtDateFormat =
                        new SimpleDateFormat( "yyyyMMdd HHmmss z" );
static BASE64Encoder encoder = new BASE64Encoder();

static public int java_connect_to( String p_hostname, int p_portno )
throws java.io.IOException
{
int    i;

    for( i = 0; i < socketUsed.length && socketUsed[i] == 1; i++ );
    if ( i < socketUsed.length )
    {
        sockets[i] = new Socket( p_hostname, p_portno );
        socketUsed[i] = 1;
    }
    return i<socketUsed.length?i:-1;
}


static public void java_send_data( int p_sock, byte[] p_data )
throws java.io.IOException
{
    (sockets[p_sock].getOutputStream()).write( p_data );
}

static public void java_recv_data( int p_sock,
                                   byte[][] p_data, int[] p_length)
throws java.io.IOException
{
    p_data[0] = new byte[p_length[0] == -1 ? 4096:p_length[0] ];
    p_length[0] = (sockets[p_sock].getInputStream()).read( p_data[0] );
}

static public void java_getline( int p_sock, String[] p_data )
throws java.io.IOException
{
    DataInputStream d =
        new DataInputStream((sockets[p_sock].getInputStream()));
    p_data[0] = d.readLine();
    if ( p_data[0] != null ) p_data[0] += "\n";
}

static public void java_disconnect( int p_sock )
throws java.io.IOException
{
    socketUsed[p_sock] = 0;
    (sockets[p_sock]).close();
}

static public int java_peek_sock( int p_sock )
throws java.io.IOException
{
    return (sockets[p_sock].getInputStream()).available();
}

static public void java_get_timezone( String[] p_timezone )
{
    tzDateFormat.setTimeZone( TimeZone.getDefault() );
    p_timezone[0] = tzDateFormat.format(new Date());
}


static public void java_get_gmt( String[] p_gmt )
{
    gmtDateFormat.setTimeZone( TimeZone.getTimeZone("GMT") );
    p_gmt[0] = gmtDateFormat.format(new Date());
}

static public void b64encode( byte[] p_data, String[] p_b64data )
{
    p_b64data[0] = encoder.encode( p_data );
}

static public void java_get_hostname( String[] p_hostname )
throws java.net.UnknownHostException
{
    p_hostname[0] = (InetAddress.getLocalHost()).getHostName();
}

}
/ 

CREATE OR REPLACE PACKAGE BODY simple_tcp_client
as

    function connect_to( p_hostname in  varchar2,
                         p_portno   in  number ) return number
    as language java
    name 'jsock.java_connect_to( java.lang.String, int ) return int';


    procedure send( p_sock in number, p_data in raw )
    as language java
    name 'jsock.java_send_data( int, byte[] )';

    procedure recv_i ( p_sock      in number,
                      p_data      out raw,
                      p_maxlength in out number )
    as language java
    name 'jsock.java_recv_data( int, byte[][], int[] )';

    procedure recv( p_sock      in   number,
                    p_data      out  raw,
                    p_maxlength in   number default -1 )
    is
        l_maxlength    number default p_maxlength;
    begin
        recv_i( p_sock, p_data, l_maxlength );
        if ( l_maxlength <> -1 )
        then
            p_data := utl_raw.substr( p_data, 1, l_maxlength );
        else
            p_data := NULL;
        end if;
    end;

    procedure getline_i( p_sock      in number,
                         p_data      out varchar2 )
    as language java
    name 'jsock.java_getline( int, java.lang.String[] )';

    procedure getline( p_sock      in number,
                       p_data        out raw )
    as
        l_data    long;
    begin
        getline_i( p_sock, l_data );
        p_data := utl_raw.cast_to_raw( l_data );
    end getline;

    procedure disconnect( p_sock     in number )
    as language java
    name 'jsock.java_disconnect( int )';

    procedure get_gmt( p_gmt   out varchar2 )
    as language java
    name 'jsock.java_get_gmt( java.lang.String[] )';

    procedure get_timezone( p_timezone   out varchar2 )
    as language java
    name 'jsock.java_get_timezone( java.lang.String[] )';

    procedure get_hostname( p_hostname   out varchar2 )
    as language java
    name 'jsock.java_get_hostname( java.lang.String[] )';

    function peek( p_sock   in  number ) return number
    as language java
    name 'jsock.java_peek_sock( int ) return int';

    procedure b64encode( p_data in raw, p_result out varchar2 )
    as language java
    name 'jsock.b64encode( byte[], java.lang.String[] )';
end;
/

declare
  l_hostname varchar2(255);
  l_gmt      varchar2(255);
  l_tz       varchar2(255);
begin
  simple_tcp_client.get_hostname( l_hostname );
  simple_tcp_client.get_gmt( l_gmt );
  simple_tcp_client.get_timezone( l_tz );

  dbms_output.put_line( 'hostname ' || l_hostname );
  dbms_output.put_line( 'gmt time ' || l_gmt );
  dbms_output.put_line( 'timezone ' || l_tz );
end;
/

begin
dbms_java.grant_permission(
grantee => 'TKYTE',
permission_type => 'java.net.SocketPermission',
permission_name => '*',
permission_action => 'connect,resolve' );
end;
/

create or replace type body SocketType
as

static function crlf return varchar2
is
begin
    return chr(13)||chr(10);
end;

member function peek return number
is
begin
    return simple_tcp_client.peek( g_sock );
end;


member procedure send( p_data in varchar2 )
is
begin
    simple_tcp_client.send( g_sock, utl_raw.cast_to_raw(p_data) );
end;

member procedure send_raw( p_data in raw )
is
begin
    simple_tcp_client.send( g_sock, p_data );
end;

member procedure send( p_data in clob )
is
    l_offset number default 1;
    l_length number default dbms_lob.getlength(p_data);
    l_amt    number default 4096;
begin
    loop
        exit when l_offset > l_length;
        simple_tcp_client.send( g_sock,
                utl_raw.cast_to_raw(
                    dbms_lob.substr(p_data,l_amt,l_offset) ) );
        l_offset := l_offset + l_amt;
    end loop;
end;

member procedure send_raw( p_data in blob )
is
    l_offset number default 1;
    l_length number default dbms_lob.getlength(p_data);
    l_amt    number default 4096;
begin
    loop
        exit when l_offset > l_length;
        simple_tcp_client.send( g_sock,
                   dbms_lob.substr(p_data,l_amt,l_offset) );
        l_offset := l_offset + l_amt;
    end loop;
end;

member function recv return varchar2
is
    l_raw_data    raw(4096);
begin
    simple_tcp_client.recv( g_sock, l_raw_data );
    return utl_raw.cast_to_varchar2(l_raw_data);
end;


member function recv_raw return raw
is
    l_raw_data    raw(4096);
begin
    simple_tcp_client.recv( g_sock, l_raw_data );
    return l_raw_data;
end;

member function getline( p_remove_crlf in boolean default FALSE )
return varchar2
is
    l_raw_data    raw(4096);
begin
    simple_tcp_client.getline( g_sock, l_raw_data );

    if ( p_remove_crlf ) then
        return rtrim(
            utl_raw.cast_to_varchar2(l_raw_data), SocketType.crlf );
    else
        return utl_raw.cast_to_varchar2(l_raw_data);
    end if;
end;

member procedure initiate_connection( p_hostname in varchar2,
                               p_portno   in number )
is
    l_data    varchar2(4069);
begin
    -- we try to connect 10 times and if the tenth time
    -- fails, we reraise the exception to the caller
    for i in 1 .. 10 loop
    begin
        g_sock := simple_tcp_client.connect_to( p_hostname, p_portno );
        exit;
    exception
        when others then
            if ( i = 10 ) then raise; end if;
    end;
    end loop;
end;

member procedure close_connection
is
begin
    simple_tcp_client.disconnect( g_sock );
    g_sock := NULL;
end;

end;
/

declare
    s      SocketType := SocketType(null);
    buffer varchar2(4096);
BEGIN
    s.initiate_connection( 'wrox3', 80 );
    s.send( 'GET http://www.oracle.com/ HTTP/1.0'||SocketType.CRLF);
    s.send( SocketType.CRLF);

    loop
        buffer := s.recv;
        exit when buffer is null;
        dbms_output.put_line( substr( buffer,1,255 ) );
    end loop;
    s.close_connection;
END;
/