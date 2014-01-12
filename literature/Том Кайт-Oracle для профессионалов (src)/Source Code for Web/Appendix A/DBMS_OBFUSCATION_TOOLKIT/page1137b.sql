drop table demo;

create table demo ( id int, theClob clob );

create or replace directory my_files as 
                               '/d01/home/tkyte';

declare
    l_clob    clob;
    l_bfile    bfile;
begin
    insert into demo values ( 1, empty_clob() )
    returning theclob into l_clob;

    l_bfile := bfilename( 'MY_FILES', 'htp.sql' );
    dbms_lob.fileopen( l_bfile );

    dbms_lob.loadfromfile( l_clob, l_bfile,
                           dbms_lob.getlength( l_bfile ) );

    dbms_lob.fileclose( l_bfile );
end;
/

select dbms_lob.getlength(theclob) lob_len,
       utl_raw.cast_to_raw( crypt_pkg.md5lob(theclob) ) md5_checksum
from demo;

update demo
            set theClob = crypt_pkg.encryptLob( theClob, 
                                'MagicKeyIsLongerEvenMore' )
 where id = 1;

select dbms_lob.getlength(theclob) lob_len,
       utl_raw.cast_to_raw( crypt_pkg.md5lob(theclob) ) md5_checksum
  from demo;

select dbms_lob.substr(
                           crypt_pkg.decryptLob(theClob), 100, 1 ) data
   from demo
  where id = 1;