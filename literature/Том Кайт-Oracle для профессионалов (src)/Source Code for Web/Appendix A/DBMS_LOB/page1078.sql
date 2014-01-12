set echo on

drop table demo;
drop sequence blob_seq;

create table demo
( id           int primary key,
  theBlob      blob
)
/

create or replace directory my_files as 'c:\temp\';

create sequence blob_seq;

create or replace
procedure load_a_file( p_dir_name in varchar2,
                       p_file_name in varchar2 )
as
    l_blob    blob;
    l_bfile   bfile;
begin
    -- First we must create a LOB in the database. We
    -- need an empty CLOB, BLOB, or a LOB created via the
    -- CREATE TEMPORARY API call to load into.

    insert into demo values ( blob_seq.nextval, empty_blob() )
    returning theBlob into l_Blob;

    -- Next, we open the BFILE we will load
    -- from.

    l_bfile := bfilename( p_dir_name, p_file_name );
    dbms_lob.fileopen( l_bfile );


    -- Then, we call LOADFROMFILE, loading the CLOB we
    -- just created with the entire contents of the BFILE
    -- we just opened.
    dbms_lob.loadfromfile( l_blob, l_bfile,
                           dbms_lob.getlength( l_bfile ) );

    -- Close out the BFILE we opened to avoid running
    -- out of file handles eventually.

    dbms_lob.fileclose( l_bfile );
end;
/

exec load_a_file( 'MY_FILES', 'clean.sql' );

exec load_a_file( 'MY_FILES', 'expdat.dmp' );

create or replace
function clean( p_raw in blob,
                p_from_byte in number default 1,
                p_for_bytes in number default 4000 )
return varchar2
as
    l_tmp varchar2(8192) default
           utl_raw.cast_to_varchar2(
               dbms_lob.substr(p_raw,p_for_bytes,p_from_byte)
                                   );
    l_char   char(1);
    l_return varchar2(16384);
    l_whitespace varchar2(25) default
                 chr(13) || chr(10) || chr(9);
    l_ws_char    varchar2(50) default
                 'rnt';

begin
    for i in 1 .. length(l_tmp)
    loop
        l_char := substr( l_tmp, i, 1 );

        -- If the character is 'printable' (ASCII non-control)
        -- then just add it. If it happens to be a \, add another
        -- \ to it, since we will replace newlines and tabs with
        -- \n and \t and such, so need to be able to tell the
        -- difference between a file with \n in it and a newline.

        if ( ascii(l_char) between 32 and 127 )
        then
            l_return := l_return || l_char;
            if ( l_char = '\' ) then
                l_return := l_return || '\';
            end if;

        -- If the character is a 'whitespace', replace it
        -- with a special character like \r, \n, \t.

        elsif ( instr( l_whitespace, l_char ) > 0 )
        then
            l_return := l_return ||
                   '\' ||
                   substr( l_ws_char, instr(l_whitespace,l_char), 1 );

        -- Else for all other non-printable characters
        -- just put a '.'.

        else
            l_return := l_return || '.';
        end if;
    end loop;

    -- Now, just return the first 4000 bytes as
    -- this is all that the SQL will let us see. We
    -- might have more than 4000 characters since CHR(10) will
    -- become \n (double the bytes) and so, this is necessary.

    return substr(l_return,1,4000);
end;
/

select id,
       dbms_lob.getlength(theBlob) len,
       clean(theBlob,30,40) piece,
       dbms_lob.substr(theBlob,40,30) raw_data
  from demo
/

update demo
   set theBlob = 'Hello World'
 where id = 1
/

update demo
   set theBlob = utl_raw.cast_to_raw('Hello World')
 where id = 1
/

commit;

select id,
       dbms_lob.getlength(theBlob) len,
       clean(theBlob) piece,
       dbms_lob.substr(theBlob,40,1) raw_data
  from demo
 where id =1
/