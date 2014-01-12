create or replace 
procedure file_dump( p_directory in varchar2,
                     p_filename  in varchar2 )
as
    type array is table of varchar2(5) index by binary_integer;

    l_chars  array;
    l_bfile  bfile;
    l_buffsize number default 15;
    l_data   varchar2(30);
    l_len    number;
    l_offset number default 1;
    l_char   char(1);
begin
    -- special cases, print out "escapes" for readability
    l_chars(0)  := '\0';
    l_chars(13) := '\r';
    l_chars(10) := '\n';
    l_chars(9)  := '\t';

    l_bfile := bfilename( p_directory, p_filename );
    dbms_lob.fileopen( l_bfile );

    l_len := dbms_lob.getlength( l_bfile );
    while( l_offset < l_len )
    loop
        -- first show the BYTE offsets into the file
        dbms_output.put( to_char(l_offset,'fm000000') || '-'||
                         to_char(l_offset+l_buffsize-1,'fm000000') );
       
        -- now get BUFFSIZE bytes from the file to dump
        l_data := utl_raw.cast_to_varchar2
                  (dbms_lob.substr( l_bfile, l_buffsize, l_offset ));

        -- for each character
        for i in 1 .. length(l_data) 
        loop
            l_char := substr(l_data,i,1);

            -- if the character is printable, just print it
            if ascii( l_char ) between 32 and 126 
            then
                dbms_output.put( lpad(l_char,3) );
            -- if it is one of the SPECIAL characters above, print 
            -- it in using the text provided
            elsif ( l_chars.exists( ascii(l_char) ) )
            then
                dbms_output.put( lpad( l_chars(ascii(l_char)), 3 ) );
            -- else it is just binary data, display it in HEX
            else
                dbms_output.put( to_char(ascii(l_char),'0X') );
            end if;
        end loop;
        dbms_output.new_line;

        l_offset := l_offset + l_buffsize;
    end loop;
    dbms_lob.close( l_bfile );
end;
/


exec file_dump( 'MY_FILES', 'demo17.dat' );
