drop table t;

create table t 
( id int primary key, data varchar2(255) );

insert into t values
( 1, crypt_pkg.encryptString( 'This is row 1', 'MagicKeyIsLonger' ) );

insert into t values
( 2, crypt_pkg.encryptString( 'This is row 2', 'MagicKeyIsLonger' ) );

select utl_raw.cast_to_raw(data) encrypted_in_hex,
       crypt_pkg.decryptString(data,'MagicKeyIsLonger') decrypted
  from t
/