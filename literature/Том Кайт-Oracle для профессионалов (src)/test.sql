set echo on

REM for NT
define PATH=c:\temp\
define CMD=fc /b

REM for UNIX
REM define PATH=/tmp/
REM define CMD="diff -s"

drop table demo;
create table demo( theBlob blob, theClob clob );


/*
 * the following block tests all of the error conditions we 
 * can test for. It does not test for IO_ERROR (we'd need a full
 * disk or something for that) or CONNECT_ERROR (that should *never*
 * happen)
 */

declare
    l_blob    blob;
    l_bytes number;
begin

    /*
     * Try a NULL blob 
     */
    begin
        l_bytes := lob_io.write( '&PATH', 'test.dat', l_blob );
    exception
        when lob_io.INVALID_LOB then
            dbms_output.put_line( 'invalid arg caught as expected' );
            dbms_output.put_line( rpad('-',70,'-') );
    end;

    /*
     * Now, we'll try with a real blob and a NULL filename 
     */
    begin
        insert into demo (theBlob) values( empty_blob() ) 
        returning theBlob into l_blob;

        l_bytes := lob_io.write( NULL, NULL, l_blob );
    exception
        when lob_io.INVALID_FILENAME then
            dbms_output.put_line( 'invalid arg caught as expected again' );
            dbms_output.put_line( rpad('-',70,'-') );
    end;

    /*
     * Now, try with an OK block but a directory that does not exist
     */
    begin
        l_bytes := lob_io.write( '/nonexistent/directory', 'x.dat', l_blob );
    exception
        when lob_io.OPEN_FILE_ERROR then
            dbms_output.put_line( 'caught open file error expected' );
            dbms_output.put_line( sqlerrm );
            dbms_output.put_line( rpad('-',70,'-') );
    end;

    /*
     * Lets just try writing it out to see that work
     */
    l_bytes := lob_io.write( '&PATH', '1.dat', l_blob );
    dbms_output.put_line( 'Writing successful ' || l_bytes || ' bytes' );
    dbms_output.put_line( rpad('-',70,'-') );

    rollback;

    /*
     * Now we have a non-null blob BUT we rolled back so its an 
     * invalid lob locator.  Lets see what our extproc returns 
     * now...
     */
    begin
        l_bytes := lob_io.write( '&PATH', '1.dat', l_blob );
    exception
        when lob_io.LOB_READ_ERROR then
            dbms_output.put_line( 'caught lob read error expected' );
            dbms_output.put_line( sqlerrm );
            dbms_output.put_line( rpad('-',70,'-') );
    end;
end;
/
pause



create or replace directory my_files as '&PATH.';

declare
    l_blob    blob;
    l_clob    clob;
    l_bfile    bfile;
begin
    insert into demo 
    values ( empty_blob(), empty_clob() ) 
    returning theBlob, theClob into l_blob, l_clob;
    
    l_bfile := bfilename( 'MY_FILES', 'something.big' );

    dbms_lob.fileopen( l_bfile );

    dbms_lob.loadfromfile( l_blob, l_bfile, 
                           dbms_lob.getlength( l_bfile ) );

    dbms_lob.loadfromfile( l_clob, l_bfile, 
                           dbms_lob.getlength( l_bfile ) );

    dbms_lob.fileclose( l_bfile );
    commit;
end;
/
pause


declare
    l_bytes number;
    l_bfile    bfile;
begin
    for x in ( select theBlob from demo ) 
    loop
        l_bytes := lob_io.write( '&PATH','blob.dat', x.theBlob );
        dbms_output.put_line( 'Wrote ' || l_bytes || ' bytes of blob' );
    end loop;
    
    for x in ( select theClob from demo ) 
    loop
        l_bytes := lob_io.write( '&PATH','clob.dat', x.theclob );
        dbms_output.put_line( 'Wrote ' || l_bytes || ' bytes of clob' );
    end loop;

    l_bfile := bfilename( 'MY_FILES', 'something.big' );
    dbms_lob.fileopen( l_bfile );
    l_bytes := lob_io.write( '&PATH','bfile.dat', l_bfile );
    dbms_output.put_line( 'Wrote ' || l_bytes || ' bytes of bfile' );
    dbms_lob.fileclose( l_bfile );
end;
/
pause

declare
    l_tmpblob blob;
    l_blob    blob;
    l_bytes      number;
begin
    select theBlob into l_blob from demo;

    dbms_lob.createtemporary(l_tmpblob,TRUE);

    dbms_lob.copy(l_tmpblob,l_blob,dbms_lob.getlength(l_blob),1,1);

    l_bytes := lob_io.write( '&PATH','tempblob.dat', l_tmpblob );
    dbms_output.put_line( 'Wrote ' || l_bytes || ' bytes of temp_blob' );

    DBMS_LOB.FREETEMPORARY(l_tmpblob);
END;
/
pause


host &CMD &PATH.something.big &PATH.blob.dat
host &CMD &PATH.something.big &PATH.clob.dat
host &CMD &PATH.something.big &PATH.bfile.dat
host &CMD &PATH.something.big &PATH.tempblob.dat
