set echo on

begin
     p( http_pkg.request( 'http://myserver/' ) );
end;
/


declare
     pieces    http_pkg.html_pieces;
begin
     pieces :=
         http_pkg.request_pieces( 'http://www.oracle.com',
                                   proxy=>'www-proxy1');

     for i in 1 .. pieces.count loop
         p( pieces(i) );
     end loop;
end;
/


select
http_pkg.urlencode( 'A>C%{hello}\fadfasdfads~`[abc]:=$+''"' )
from dual;


declare
     l_httpHeaders      correlatedArray;
     l_status     number;
     l_status_txt     varchar2(255);
     l_content      clob;
begin
     http_pkg.get_url( 'http://www.yahoo.com/',
                       'www-proxy1',
                        l_status,
                        l_status_txt,
                        l_httpHeaders,
                        l_content );

     p( 'The status was ' || l_status );
     p( 'The status text was ' || l_status_txt );
     print_headers( l_httpHeaders );
     print_clob( l_content );
end;
/
declare
     l_httpHeaders      correlatedArray;
     l_status     number;
     l_status_txt     varchar2(255);
begin
     http_pkg.head_url( 'http://www.wrox.com/',
                        'www-proxy1',
                         l_status,
                         l_status_txt,
                         l_httpHeaders );

     p( 'The status was ' || l_status );
     p( 'The status text was ' || l_status_txt );
     print_headers( l_httpHeaders );
end;
/


declare
     l_httpHeaders     correlatedArray;
     l_status     number;
     l_status_txt     varchar2(255);
     l_content     clob;
begin
     http_pkg.add_a_cookie( 'COUNT', 55, l_httpHeaders );
     http_pkg.get_url
     ( 'http://aria.us.oracle.com/wa/webdemo/owa/cookiejar',
        null,
        l_status,
        l_status_txt,
        l_httpHeaders,
        l_content );

     p( 'The status was ' || l_status );
     p( 'The status text was ' || l_status_txt );
     print_headers( l_httpHeaders );
     print_clob( l_content );
end;
/


declare
    l_httpHeaders   correlatedArray;
    l_status        number;
    l_status_txt    varchar2(255);
    l_content       clob;
begin
    http_pkg.set_basic_auth( 'web$tkyte', 'tiger', l_httpheaders );
    http_pkg.get_url
    ( 'http://myserver.acme.com:80/wa/intranets/owa/print_user',
       null,
       l_status,
       l_status_txt,
       l_httpHeaders,
       l_content );

    p( 'The status was ' || l_status );
    p( 'The status text was ' || l_status_txt );
    print_headers( l_httpHeaders );
    print_clob(l_content);
end;
/


declare
    l_httpHeaders   correlatedArray;
    l_status        number;
    l_status_txt    varchar2(255);
    l_content       clob;
    l_post          clob;
begin
    http_pkg.set_post_parameter( 'symbols','orcl ^IXID ^DJI ^SPC',
                                  l_post, TRUE );
    http_pkg.set_post_parameter( 'format', 'sl1d1t1c1ohgv',
                                  l_post, TRUE );
    http_pkg.set_post_parameter( 'ext', '.csv',
                                  l_post, TRUE );
    http_pkg.post_url( 'http://quote.yahoo.com/download/quotes.csv',
                        l_post,
                       'www-proxy1',
                        l_status,
                        l_status_txt,
                        l_httpHeaders,
                        l_content );

    p( 'The status was ' || l_status );
    p( 'The status text was ' || l_status_txt );
    print_headers( l_httpHeaders );
    print_clob( l_content );
end;
/

