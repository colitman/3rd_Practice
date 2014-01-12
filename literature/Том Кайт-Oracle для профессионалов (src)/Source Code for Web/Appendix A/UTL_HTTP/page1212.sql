set echo on


declare
   l_output long;

   l_url varchar2(255) default
         'https://www.amazon.com/exec/obidos/flex-sign-in/';

   l_wallet_path varchar2(255) default
         'file:C:\Documents and Settings\Thomas Kyte\ORACLE\WALLETS';


begin
  l_output := utl_http.request
             ( url             => l_url,
               proxy           => 'www-proxy.us.oracle.com',
               wallet_path     => l_wallet_path,
               wallet_password => 'oracle'
             );
  dbms_output.put_line(trim(substr(l_output,1,255)));
end;
/
