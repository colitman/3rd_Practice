create or replace package crypt_pkg
as
    --
    -- Functions to encrypt and decrypt strings, RAWs, BLOBs, and CLOBs.
    -- The algorithm used (single DES, triple DES with 2 keys or 3 keys) will
    -- be decided based on the key length:
    --
    -- 8 byte key  = single DES (56 bit key)
    -- 16 byte key = triple DES with 2 keys (112 bit key)
    -- 24 byte key = triple DES with 3 keys (168 bit key)
    --
    -- The key may be passed in with each call OR it may
    -- optionally be set for the package by calling 'setKey'
    -- once. setKey will take either a RAW or VARCHAR2
    -- input. If you are en/decrypting RAW or BLOB data, you
    -- must use a RAW key. If you an en/decrypting string or CLOB
    -- data you must use a VARCHAR2 key.
    --
    -- In addition to providing a layer on top of encryption, this
    -- package provides access to the md5 routines, if installed.
    --
    -- Errors returned:
    -- In addition to the documented DBMS_OBFUSCATION_TOOLKIT errors
    -- which this package will simply propagate, the following 'new'
    -- errors may be visible:
    -- In 8.1.6, you may recieve any one of:
    -- PLS-00302: component 'MD5' must be declared
    -- PLS-00302: component 'DES3ENCRYPT' must be declared
    -- PLS-00302: component 'THREEKEYMODE' must be declared
    --
    -- You will get these errors if you attempt to use the 8.1.7
    -- functionality of DES3 encryption or MD5 hashing.
    --

    --
    -- You use the encryptString and decryptString routines to encrypt/decrypt
    -- any string, date, or number data upto 32 KB in size.
    --
    -- These functions may be used in SQL
    -- The KEY parameter is optional if you have set a key via the
    -- SETKEY procedure below.
    --
    -- Note how we AVOID function overloading for the encrypt/decrypt
    -- routines. We have an encryptString and an encryptRaw. This is to
    -- make the signatures of the functions unambigous so we can call them 
    -- from SQL. If we attempted to overload these functions based on INPUT
    -- TYPE only, the run-time SQL engine cannot tell if we intended to call
    -- the VARCHAR2 function or the RAW function.
    --

    function encryptString( p_data in varchar2,
                            p_key  in varchar2 default NULL ) 
    return varchar2;

    function decryptString( p_data in varchar2,
                            p_key  in varchar2 default NULL ) 
    return varchar2;

    --
    -- These functions behave identically to the String routines above
    -- but work on RAW data up to 32 KB in size.
    --
    function encryptRaw( p_data in raw,
                         p_key  in raw default NULL ) return raw;

    function decryptRaw( p_data in raw,
                         p_key  in raw default NULL ) return raw;


    --
    -- These functions will encrypt/decrypt LOBS. Since we are limited
    -- to 32 KB of data in the encryption routines, we use an algorithm
    -- that encrypts 32 KB chunks of the LOB so the resulting LOB is a
    -- series of encrypted strings.
    --
    -- The decrypt routines understand how the data was 'packed' by
    -- the encrypt routines, and will decrypt the 32 KB chunks.
    --
    function encryptLob( p_data in clob,
                         p_key  in varchar2 default NULL ) return clob;
    function encryptLob( p_data in blob,
                         p_key  in raw default NULL ) return blob;

    function decryptLob( p_data in clob,
                         p_key  in varchar2 default NULL ) return clob;
    function decryptLob( p_data in blob,
                         p_key  in raw default NULL ) return blob;

    --
    -- These subtypes make it easier to declare a return variable
    -- that can accept checksums. They are not needed. You can
    -- assign the checksums to varchar2s or raws as you see fit
    --
    subtype checksum_str is varchar2(16);
    subtype checksum_raw is raw(16);


    --
    -- A set of functions to take a string of up to 32 KB in size
    -- or a LOB of any size, and compute the md5 checksum of it.
    -- Notice we avoid overloading RAW and
    -- VARCHAR2 functions again for the same reason as encrypt
    -- and decrypt
    --
    function md5str( p_data in varchar2 ) return checksum_str;

    function md5raw( p_data in raw ) return checksum_raw;

    -- The MD5LOB functions take the first 32 KB of the BLOB or CLOB,
    -- and compute a checksum for them.
    function md5lob( p_data in clob ) return checksum_str;
    function md5lob( p_data in blob ) return checksum_raw;
    --  
    -- An optional procedure. You can set the key once and then
    -- not have to pass it in with each call.
    --
    procedure setKey( p_key in varchar2 );
end;
/


create or replace package body crypt_pkg
as

-- 
-- Package globals:
--
-- charkey - Stores the RAW or VARCHAR2 key for use by the 
--           routines. It is 48 bytes to support holding
--           a 24 byte RAW key (which will be doubled due
--           to the hexadecimal conversion).

g_charkey         varchar2(48);

-- Function - Contains either Null or 3. We will
--            dynamically add this to the routine
--            name at run-time so we either run
--            DESEncrypt or DES3Encrypt, depending
--            on the keysize.

g_stringFunction varchar2(1);
g_rawFunction    varchar2(1);


-- Which - Used with DES3En/Decrypt only. Adds the 4th
--         optional parameter to force Three Key Mode
--         when doing triple DES with 3 keys.
g_stringWhich    varchar2(75);
g_rawWhich       varchar2(75);


-- chunksize - Controls the size of the pieces of the LOB
--             we encrypt.  Also controls the amount of
--             data sent to MD5 when checksumming a LOB
g_chunkSize      CONSTANT number default 32000;
-- 
-- INTERNAL, PRIVATE functions
--
-- padstr - Since the encrypt/decrypt routines need data
--          that is in multiples of 8bytes in length, we pad
--          the data. We need to preserve the orginal length
--          of the data as well, so when we decrypt, we
--          return a string of the correct length. Therefore
--          we add 8 bytes onto the front of the string and that
--          is the original length.  We then RPAD the string
--          out to a length that is a multiple of 8 bytes.
-- 
function padstr( p_str in varchar2 ) return varchar2
as
    l_len number default length(p_str);
begin
    return to_char(l_len,'fm00000009') ||
             rpad(p_str, ( trunc(l_len/8)+sign(mod(l_len,8)) )*8, chr(0));
end;

-- 
-- padraw - Does to RAWs what padstr does to strings. Encodes
--          the original length into the data and ensures the
--          length is a multiple of 8 bytes.
-- 
function padraw( p_raw in raw ) return raw
as
    l_len number default utl_raw.length(p_raw);
begin
    return utl_raw.concat( utl_raw.cast_to_raw(to_char(l_len,'fm00000009')),
                           p_raw,
                           utl_raw.cast_to_raw( rpad(chr(0),
                          (8-mod(l_len,8))*sign(mod(l_len,8)),
                           chr(0))));
end;
--
-- unpadstr - Removes the leading 8 bytes and returns the remaining
--            original (but not padded) bytes of data.
--
function unpadstr( p_str in varchar2 ) return varchar2
is
begin
    return substr( p_str, 9, to_number(substr(p_str,1,8)) );
end;

--
-- unpadraw - Does to RAW what unpadstr does to strings
--
function unpadraw( p_raw in raw ) return raw
is
begin
    return utl_raw.substr( p_raw, 9, 
        to_number( utl_raw.cast_to_varchar2(utl_raw.substr(p_raw,1,8)) ) );
end;

--
-- wa - private internal routines, shorthand calls to
--      dbms_lob.writeappend.  
--
procedure wa( p_clob in out clob, p_buffer in varchar2 ) 
is 
begin
   dbms_lob.writeappend(p_clob,length(p_buffer),p_buffer); 
end;

procedure wa( p_blob in out blob, p_buffer in raw ) 
is 
begin
   dbms_lob.writeappend(p_blob,utl_raw.length(p_buffer),p_buffer); 
end;

--
-- SetKey will put the key value into the private package global variable.
-- It will also, if the key is different from the last time it was called, 
-- perform some computations to validate the key length.
-- Then it will figure out whether to use single DES or triple DES with 
-- 2 or 3 key encryption. It uses DECODE to perform this operation.
--
procedure setKey( p_key in varchar2 )
as
begin
    -- 
    -- If we already have this key, just short circut, and return.
    -- Do not do the extra work.
    --
    if ( g_charkey = p_key OR p_key is NULL ) then
        return;
    end if;

    g_charkey := p_key;

    -- 
    -- If the key cannot work since it is not 8, 16 or 24 bytes,
    -- error out right away. This does not guarantee the key will work.
    -- For example, you could send a 4 byte RAW key which will appear
    -- as 8 bytes to us. You will get a run-time error from 
    -- dbms_obfuscation_toolkit at this point.
    --
    if ( length(g_charkey) not in ( 8, 16, 24, 16, 32, 48 ) )
    then
        raise_application_error( -20001, 
                            'Key must be 8, 16, or 24 bytes' );
    end if;

    --
    -- Based on the length of the key pick single DES or triple DES with 
    -- 2 or 3 keys. We look at the length to decide whether we should use
    -- '3' in the API call (use desencrypt or des3encrypt), and whether we
    -- need to pass the fourth parameter 'which' to DES3 to get three key
    -- encryption going.
    --
	if ( length( g_charkey ) = 8 )
	then
		g_stringFunction := '';
	else
		g_stringFunction := '3';
	end if;

	if ( length( g_charkey ) in ( 8, 16 ) )
	then
		g_stringWhich := '';
	elsif ( length( g_charkey ) = 24 ) 
	then
		g_stringWhich := ' which=>dbms_obfuscation_toolkit.ThreeKeyMode';
	end if;

	if ( length( g_charkey ) = 16 ) 
	then
		g_rawFunction := '';
	else
		g_rawFunction := '3';
	end if;

	if ( length( g_charkey ) in ( 16, 32 ) )
	then
		g_rawWhich := '';
	elsif ( length( g_charkey ) = 48 ) 
	then
		g_rawWhich := ' which=>dbms_obfuscation_toolkit.ThreeKeyMode';
	end if;

    select decode(length(g_charkey),8,'','3'), 
           decode(length(g_charkey),8,'',16,'',
               24,', which=>dbms_obfuscation_toolkit.ThreeKeyMode'),
           decode(length(g_charkey),16,'','3'),
           decode(length(g_charkey),16,'',32,'',
               48,', which=>dbms_obfuscation_toolkit.ThreeKeyMode')
      into g_stringFunction, g_stringWhich, g_rawFunction, g_rawWhich
      from dual;
end;
--
-- The encryptString and encryptRaw functions work pretty much the same.
-- They both DYNAMICALLY call either DESEncrypt or DES3Encrypt. This 
-- dynamic call not only reduces the amount of code we have, but it also makes 
-- it so this package can be installed in 8.1.6 or 8.1.7. Since we do
-- not statically reference DBMS_OBFUSCATION_TOOLKIT, we can compile 
-- against either version.
--
-- These functions work simply by creating a dynamic string using the 
-- 'function' and 'which' we set in the setKey routine. We will either 
-- add the number '3' to the procedure name, or not. We will add
-- the optional fourth parameter to DES3Encrypt when we want three key mode.
-- Then we execute the string and send the data and key to be encrypted, and 
-- receive the encrypted data as output.
--
function encryptString( p_data in varchar2,
                   p_key  in varchar2 default NULL ) return varchar2
as
    l_encrypted long;
begin
    setkey(p_key);
    execute immediate 
    'begin 
       dbms_obfuscation_toolkit.des' || g_StringFunction || 'encrypt
       ( input_string => :1, key_string => :2, encrypted_string => :3' ||
       g_stringWhich || ' );
     end;' 
     using IN padstr(p_data), IN g_charkey, IN OUT l_encrypted;

    return l_encrypted;
end;

function encryptRaw( p_data in raw,
                     p_key  in raw default NULL ) return raw
as
    l_encrypted long raw;
begin
    setkey(p_key);
    execute immediate 
    'begin 
       dbms_obfuscation_toolkit.des' || g_RawFunction || 'encrypt
       ( input => :1, key => :2, encrypted_data => :3' ||
       g_rawWhich || ' );
     end;' 
     using IN padraw( p_data ), IN hextoraw(g_charkey), IN OUT l_encrypted;

    return l_encrypted;
end;
--
-- decryptString and decryptRaw work in an identical fashion
-- to the encrypt routine above, functionally. The only difference
-- is they call decrypt instead of encrypt.
--
function decryptString( p_data in varchar2,
                        p_key  in varchar2 default NULL ) return varchar2
as
    l_string long;
begin
    setkey(p_key);
    execute immediate 
    'begin 
       dbms_obfuscation_toolkit.des' || g_StringFunction || 'decrypt
       ( input_string => :1, key_string => :2, decrypted_string => :3' ||
       g_stringWhich || ' );
     end;' 
     using IN p_data, IN g_charkey, IN OUT l_string;
    
    return unpadstr( l_string );
end;

function decryptRaw( p_data in raw,
                     p_key  in raw default NULL ) return raw
as
    l_string long raw;
begin
    setkey(p_key);
    execute immediate 
    'begin 
       dbms_obfuscation_toolkit.des' || g_RawFunction || 'decrypt
       ( input => :1, key => :2, decrypted_data => :3 ' ||
       g_rawWhich || ' );
     end;' 
     using IN p_data, IN hextoraw(g_charkey), IN OUT l_string;

    return unpadraw( l_string );
end;

--
-- encryptLob - Overloaded procedures for BLOBs and CLOBs. These work
--              by creating a TEMPORARY CLOB/BLOB to write encrypted 
--              data into. Since we change the length of a STRING/RAW
--              when encrypted to preserve the length, doing this 'in
--              place' would be very hard. Also, it would make it 
--              not possible to call these funtions from SQL, since the 
--              LOB locator would have to be IN/OUT, and IN/OUT parameters
--              would preclude this from being called from SQL.
--
--              The original LOB is taken G_CHUNKSIZE bytes at a time.
--              Each chunk is encrypted and put into the temporary LOB.
--              The result is a LOB that is a series of encrypted pieces
--              of the original LOB.
--
function encryptLob( p_data in clob,
                     p_key  in varchar2 ) return clob
as
    l_clob      clob;
    l_offset    number default 1;
    l_len       number default dbms_lob.getlength(p_data);
begin
    setkey(p_key);
    dbms_lob.createtemporary( l_clob, TRUE );
    while ( l_offset <= l_len ) 
	loop
        wa( l_clob, encryptString( 
            dbms_lob.substr( p_data, g_chunkSize, l_offset ) ) );
        l_offset := l_offset + g_chunksize;
    end loop;
    return l_clob;
end;


function encryptLob( p_data in blob,
                     p_key  in raw ) return blob
as
    l_blob      blob;
    l_offset    number default 1;
    l_len       number default dbms_lob.getlength(p_data);
begin
    setkey(p_key);
    dbms_lob.createtemporary( l_blob, TRUE );
    while ( l_offset <= l_len ) 
	loop
        wa( l_blob, encryptRaw( 
            dbms_lob.substr( p_data, g_chunkSize, l_offset ) ) );
        l_offset := l_offset + g_chunksize;
    end loop;
    return l_blob;
end;


--
-- The decrypt routines work much the same way .
function decryptLob( p_data in clob, 
                     p_key  in varchar2 default NULL ) return clob
as
    l_clob      clob;
    l_offset    number default 1;
    l_len       number default dbms_lob.getlength(p_data);
begin
    setkey(p_key);
    dbms_lob.createtemporary( l_clob, TRUE );
    while ( l_offset <= l_len ) 
	loop
        wa( l_clob, decryptString( 
                    dbms_lob.substr( p_data, g_chunksize+8, l_offset ) ) );
        l_offset := l_offset + 8 + g_chunksize;
    end loop;
    return l_clob;
end;

function decryptLob( p_data in blob,
                     p_key  in raw default NULL ) return blob
as
    l_blob        blob;
    l_offset    number default 1;
    l_len       number default dbms_lob.getlength(p_data);
begin
    setkey(p_key);
    dbms_lob.createtemporary( l_blob, TRUE );
    while ( l_offset <= l_len ) 
	loop
        wa( l_blob, decryptRaw( 
                    dbms_lob.substr( p_data, g_chunksize+8, l_offset ) ) );
        l_offset := l_offset + 8 + g_chunksize;
    end loop;
    return l_blob;
end;


-- 
-- The md5 routines act as a passthrough pretty much to the
-- native DBMS_OBFUSCATION_TOOLKIT routines. The one thing
-- they do differently is they are not overloaded, allowing them
-- to be called from SQL.
-- 
-- the MD5lob routines only compute the checksum based on the 
-- first G_CHUNKSIZE bytes of data.
--
function md5str( p_data in varchar2 ) return checksum_str
is
    l_checksum_str  checksum_str;
begin
    execute immediate
    'begin :x := dbms_obfuscation_toolkit.md5( input_string => :y ); end;' 
    using OUT l_checksum_str, IN p_data;

    return l_checksum_str;
end;


function md5raw( p_data in raw ) return checksum_raw
is
    l_checksum_raw    checksum_raw;
begin
    execute immediate
    'begin :x := dbms_obfuscation_toolkit.md5( input => :y ); end;' 
    using OUT l_checksum_raw, IN p_data;

    return l_checksum_raw;
end;

function md5lob( p_data in clob ) return checksum_str
is
    l_checksum_str  checksum_str;
begin
    execute immediate
    'begin :x := dbms_obfuscation_toolkit.md5( input_string => :y ); end;' 
    using OUT l_checksum_str, IN dbms_lob.substr(p_data,g_chunksize,1);

    return l_checksum_str;
end;

function md5lob( p_data in blob ) return checksum_raw
is
    l_checksum_raw  checksum_raw;
begin
    execute immediate
    'begin :x := dbms_obfuscation_toolkit.md5( input => :y ); end;' 
    using OUT l_checksum_raw, IN dbms_lob.substr(p_data,g_chunksize,1);

    return l_checksum_raw;
end;

end;
/

