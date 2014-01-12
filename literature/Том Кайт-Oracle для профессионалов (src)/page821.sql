set echo on



REM ************************************************************
REM *  IMPORTANT:
REM *    fix this path!!!
REM ************************************************************

create or replace library lobToFile_lib as
'C:\extproc\lobtofile\extproc.dll'
--'/export/home/tkyte/src/lobtofile/extproc.so'
/


create or replace package lob_io
as
    /*
     * These are our three overloaded functions to write 
     * a LOB to a file on our server.  They are calld in 
     * identical fashion and all return the number of bytes
     * written to disk.  The exceptions they might throw are 
     * listed below.
     */ 
    function write( p_path in varchar2, p_filename in varchar2, p_lob in blob )
    return binary_integer;

    function write( p_path in varchar2, p_filename in varchar2, p_lob in clob )
    return binary_integer;

    function write( p_path in varchar2, p_filename in varchar2, p_lob in bfile )
    return binary_integer;

    /*
     * Exceptions thrown by this package are listed below.
     * You can handle errors from this package in one of two 
     * methods:
     * 
     * 1) with a "when others" and then inspect the sqlcode..
     *  
     *    ....
     *      when others then
     *         if (sqlcode = -20001 ) then -- (it was an IO error)
     *            ....
     *         elsif( sqlcode = -20002 )  then -- (it was a connect error)
     *          .... and so on
     *
     * 2) with named exceptions:
     * 
     *    ...
     *      when lob_io.IO_ERROR then
     *            ....
     *      when lob_io.CONNECT_ERROR then
     *            ....
     */

    /*
     * IO_ERROR is thrown when we attempt to write some number
     * of bytes to disk and fail.  This is an OS error, we will
     * include the text of the os error in the error message itself
     */
    IO_ERROR exception;
    pragma exception_init( IO_ERROR, -20001 );

    /*
     * CONNECT_ERROR is thrown when the register connect pro*c call fails
     * this is an internal pro*c error and should never happen
     */
    CONNECT_ERROR exception;
    pragma exception_init( CONNECT_ERROR, -20002 );

    /*
     * INVALID_ARGUMENT is thrown whenever FILENAME or LOB is null
     */
    INVALID_LOB exception;
    pragma exception_init( INVALID_LOB, -20003 );
    INVALID_FILENAME exception;
    pragma exception_init( INVALID_FILENAME, -20004 );

    /* 
     * OPEN_FILE_ERROR will be thrown whenever the file you asked to write
     * to cannot be opened.  Reasons could be "insufficient privs", 
     * "non existent directory" and so on.  The text of the OS error
     * will be included in the error message 
     */

    OPEN_FILE_ERROR exception;
    pragma exception_init( OPEN_FILE_ERROR, -20005 );

    /*
     * LOB_READ_ERROR will be thrown when we recieve an error from the
     * server during a read call.  This should never happen in normal 
     * circumstances.
     */
    LOB_READ_ERROR exception;
    pragma exception_init( LOB_READ_ERROR, -20006 );

end;
/

create or replace package body lob_io
as

/*
 * Our package body is rather straight forward.  There is really not
 * much to it.  It is simply a mapping of the PLSQL datatypes to their
 * C equivalents.  I would urge you to ALWAYS pass the indicator variable
 * along to the C extproc to avoid using uninitialized parameter values!
 */

function write( p_path in varchar2, p_filename in varchar2, p_lob in blob ) 
return binary_integer
as
language C
name "lobToFile"
library lobtofile_lib
with context
parameters( CONTEXT, 
            p_path     STRING, 
            p_path     INDICATOR short, 
            p_filename STRING, 
            p_filename INDICATOR short, 
            p_lob      OCILOBLOCATOR, 
            p_lob      INDICATOR short, 
            RETURN INDICATOR short );


function write( p_path in varchar2, p_filename in varchar2, p_lob in clob ) 
return binary_integer
as
language C
name "lobToFile"
library lobtofile_lib
with context
parameters( CONTEXT, 
            p_path     STRING, 
            p_path     INDICATOR short, 
            p_filename STRING, 
            p_filename INDICATOR short, 
            p_lob      OCILOBLOCATOR, 
            p_lob      INDICATOR short, 
            RETURN INDICATOR short );


function write( p_path in varchar2, p_filename in varchar2, p_lob in bfile ) 
return binary_integer
as
language C
name "lobToFile"
library lobtofile_lib
with context
parameters( CONTEXT, 
            p_path     STRING, 
            p_path     INDICATOR short, 
            p_filename STRING, 
            p_filename INDICATOR short, 
            p_lob      OCILOBLOCATOR, 
            p_lob      INDICATOR short, 
            RETURN INDICATOR short );

end lob_io;
/
