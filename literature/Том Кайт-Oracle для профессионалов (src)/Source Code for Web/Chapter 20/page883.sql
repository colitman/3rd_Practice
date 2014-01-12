set echo on

create or replace type FileType
as object
(  g_file_name    varchar2(255),
   g_path         varchar2(255),
   g_file_hdl     number,
  
   static function open( p_path        in varchar2,
                         p_file_name   in varchar2,
                         p_mode        in varchar2 default 'r',
                         p_maxlinesize in number default 32765 )
   return FileType,
 
   member function isOpen return boolean,
   member procedure close,
   member function get_line return varchar2,
   member procedure put( p_text in varchar2 ),
   member procedure new_line( p_lines in number default 1 ),
   member procedure put_line( p_text in varchar2 ),
   member procedure putf( p_fmt  in varchar2,
                          p_arg1 in varchar2 default null,
                          p_arg2 in varchar2 default null,
                          p_arg3 in varchar2 default null,
                          p_arg4 in varchar2 default null,
                          p_arg5 in varchar2 default null ),
   member procedure flush,
 
   static procedure write_io( p_file      in  number,
                              p_operation in  varchar2,
                              p_parm1     in  varchar2 default null,
                              p_parm2     in  varchar2 default null,
                              p_parm3     in  varchar2 default null,
                              p_parm4     in  varchar2 default null,
                              p_parm5     in  varchar2 default null,
                              p_parm6     in  varchar2 default null )
)
/

create or replace package FileType_pkg
as
    type utl_fileArrayType is table of utl_file.file_type
          index by binary_integer;

    g_files utl_fileArrayType;

    g_invalid_path_msg constant varchar2(131) default
    'INVALID_PATH: File location or filename was invalid.';

    g_invalid_mode_msg constant varchar2(131) default
    'INVALID_MODE: The open_mode parameter %s in FOPEN was invalid.';

    g_invalid_filehandle_msg constant varchar2(131) default
    'INVALID_FILEHANDLE: The file handle was invalid.';

    g_invalid_operation_msg constant varchar2(131) default
    'INVALID_OPERATION: The file could not be opened or operated '||
    'on as requested.';

    g_read_error_msg constant varchar2(131) default
    'READ_ERROR: An operating system error occurred during '||
    'the read operation.';

    g_write_error_msg constant varchar2(131) default
    'WRITE_ERROR: An operating system error occurred during '||
    'the write operation.';

    g_internal_error_msg constant varchar2(131) default
    'INTERNAL_ERROR: An unspecified error in PL/SQL.';

    g_invalid_maxlinesize_msg constant varchar2(131) default
    'INVALID_MAXLINESIZE: Specified max linesize %d is too '||
    'large or too small';
end;
/


create or replace type body FileType
as

static function open( p_path        in varchar2,
                      p_file_name   in varchar2,
                      p_mode        in varchar2 default 'r',
                      p_maxlinesize in number default 32765 )
return FileType
is
    l_file_hdl number;
    l_utl_file_dir varchar2(1024);
begin
    -- begin by getting an array slot to hold our utl_file record
    l_file_hdl := nvl( fileType_pkg.g_files.last, 0 )+1;

    -- Now, open the file
    filetype_pkg.g_files(l_file_hdl) :=
         utl_file.fopen( p_path, p_file_name, p_mode, p_maxlinesize );

    -- and return a newly constructed type using
    -- the default constructor.
    return fileType( p_file_name, p_path, l_file_hdl );
exception
    -- exception block to catch and reraise all UTL_FILE
    -- exceptions in a better way.  Instead of recieving the
    -- SQLERRM of "user defined exception" in the invoking routine,
    -- you'll receive something meaningful like "the open mode
    -- parameter was invalid".

    when utl_file.invalid_path then
        -- this exception is raised if the file could not be
        -- opened due to an invalid PATH or FILENAME.  If the
        -- OWNER of this type has been granted SELECT on
        -- SYS.V_$PARAMETER, we will retrieve the entire
        -- utl_file_dir init.ora parameter and verify the path
        -- we are attempting to use is in fact set up to be used.
        -- If not, return an even MORE meaningful error
        -- message, else return the default message.
        --
        -- if the owner of this type does not have access
        -- to V$PARAMETER directly
        -- the original error message is returned anyway.
        begin
            execute immediate 'select value
                                 from v$parameter
                                where name = ''utl_file_dir'''
            into l_utl_file_dir;
        exception
            when others then
                l_utl_file_dir := p_path;
        end;
        if ( instr( l_utl_file_dir||',', p_path ||',' ) = 0 )
        then
            raise_application_error
            ( -20001,'The path ' || p_path ||
              ' is not in the utl_file_dir path "' ||
                   l_utl_file_dir || '"' );
        else
            raise_application_error
            (-20001,fileType_pkg.g_invalid_path_msg);
        end if;
    when utl_file.invalid_mode then
        raise_application_error
        (-20002,replace(fileType_pkg.g_invalid_mode_msg,'%s',p_mode) );
    when utl_file.invalid_operation then
        raise_application_error
        (-20003,fileType_pkg.g_invalid_operation_msg);
    when utl_file.internal_error then
        raise_application_error
        (-20006,fileType_pkg.g_internal_error_msg);
    when utl_file.invalid_maxlinesize then
        raise_application_error
        (-20007, replace(fileType_pkg.g_invalid_maxlinesize_msg,
                         '%d',p_maxlinesize));
end;

member function isOpen return boolean
is
begin
    return utl_file.is_open( filetype_pkg.g_files(g_file_hdl) );
end;

member function get_line return varchar2
is
    -- the longest line we can retrieve is 32k, the LONG dataype in
    -- PLSQL is upto 32k in size.
    l_buffer varchar(32765);
begin
    utl_file.get_line( filetype_pkg.g_files(g_file_hdl), l_buffer );
    return l_buffer;
exception
    -- handle all of the exceptions raised by GET_LINE and remap them
    when utl_file.invalid_filehandle then
        raise_application_error
        (-20002,fileType_pkg.g_invalid_filehandle_msg);
    when utl_file.invalid_operation then
        raise_application_error
        (-20003,fileType_pkg.g_invalid_operation_msg);
    when utl_file.read_error then
        raise_application_error
        (-20004,fileType_pkg.g_read_error_msg);
    when utl_file.internal_error then
        raise_application_error
        (-20006,fileType_pkg.g_internal_error_msg);
end;


-- the only purpose of write_io is to avoid having to
-- type the same exception handler in 6 times for each of
-- the WRITE oriented routines, they all throw the same exceptions.

static procedure write_io( p_file      in number,
                           p_operation in varchar2,
                           p_parm1     in varchar2 default null,
                           p_parm2     in varchar2 default null,
                           p_parm3     in varchar2 default null,
                           p_parm4     in varchar2 default null,
                           p_parm5     in varchar2 default null,
                           p_parm6     in varchar2 default null )
is
    l_file utl_file.file_type default  filetype_pkg.g_files(p_file);
begin
    if    (p_operation='close')    then
        utl_file.fclose(l_file);
    elsif (p_operation='put')      then
        utl_file.put(l_file,p_parm1);
    elsif (p_operation='new_line') then
        utl_file.new_line( l_file,p_parm1 );
    elsif (p_operation='put_line') then
        utl_file.put_line( l_file, p_parm1 );
    elsif (p_operation='flush')    then
        utl_file.fflush( l_file );
    elsif (p_operation='putf' )    then
        utl_file.putf(l_file,p_parm1,p_parm2,
                      p_parm3,p_parm4,p_parm5,
                      p_parm6);
    else raise program_error;
    end if;
exception
    when utl_file.invalid_filehandle then
        raise_application_error
        (-20002,fileType_pkg.g_invalid_filehandle_msg);
    when utl_file.invalid_operation then
        raise_application_error
        (-20003,fileType_pkg.g_invalid_operation_msg);
    when utl_file.write_error then
        raise_application_error
        (-20005,fileType_pkg.g_write_error_msg);
    when utl_file.internal_error then
        raise_application_error
        (-20006,fileType_pkg.g_internal_error_msg);
end;

member procedure close
is
begin
    fileType.write_io(g_file_hdl, 'close' );
    filetype_pkg.g_files.delete(g_file_hdl);
end;

member procedure put( p_text in varchar2 )
is
begin
    fileType.write_io(g_file_hdl, 'put',p_text );
end;

member procedure new_line( p_lines in number default 1 )
is
begin
    fileType.write_io(g_file_hdl, 'new_line',p_lines );
end;

member procedure put_line( p_text in varchar2 )
is
begin
    fileType.write_io(g_file_hdl, 'put_line',p_text );
end;

member procedure putf
( p_fmt  in varchar2, p_arg1 in varchar2 default null,
  p_arg2 in varchar2 default null, p_arg3 in varchar2 default null,
  p_arg4 in varchar2 default null, p_arg5 in varchar2 default null )
is
begin
    fileType.write_io
    (g_file_hdl, 'putf', p_fmt, p_arg1,
      p_arg2, p_arg3, p_arg4, p_arg5);
end;

member procedure flush
is
begin
    fileType.write_io(g_file_hdl, 'flush' );
end;

end;
/



member procedure flush
is
begin
    fileType.write_io(g_file_hdl, 'flush' );
end;

end;
/

declare
    f utl_file.file_type := utl_file.fopen( 'c:\temp\bogus',
                                            'foo.txt', 'w' );
begin
    utl_file.fclose( f );
end;
/


declare
    f fileType := fileType.open( 'c:\temp\bogus', '
                                 foo.txt', 'w' );
begin
    f.close;
end;
/

