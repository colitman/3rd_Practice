declare
    l_str_data    varchar2(25) := 'hello world';
    l_str_enc     varchar2(50);
    l_str_decoded varchar2(25);

    l_raw_data    raw(25) := utl_raw.cast_to_raw('Goodbye');
    l_raw_enc     raw(50);
    l_raw_decoded raw(25);

begin
    crypt_pkg.setkey( 'MagicKey' );

    l_str_enc     := crypt_pkg.encryptString( l_str_data );
    l_str_decoded := crypt_pkg.decryptString( l_str_enc );

    dbms_output.put_line( 'Encoded In hex = ' ||
                          utl_raw.cast_to_raw(l_str_enc)  );
    dbms_output.put_line( 'Decoded = '  || l_str_decoded );

    crypt_pkg.setkey( utl_raw.cast_to_raw('MagicKey') );

    l_raw_enc     := crypt_pkg.encryptRaw( l_raw_data );
    l_raw_decoded := crypt_pkg.decryptRaw( l_raw_enc );

    dbms_output.put_line( 'Encoded = ' || l_raw_enc );
    dbms_output.put_line( 'Decoded = '  ||
                           utl_raw.cast_to_varchar2(l_raw_decoded) );
end;
/