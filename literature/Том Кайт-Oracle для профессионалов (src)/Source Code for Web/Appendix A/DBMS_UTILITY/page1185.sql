set echo on

show parameter utl_file_dir

select * from v$parameter where name = 'utl_file_dir'
/

declare
    intval number;
    strval varchar2(512);
begin
    if ( dbms_utility.get_parameter_value( 'utl_file_dir',
                                            intval,
                                            strval ) = 0 )
    then
        dbms_output.put_line( 'Value = ' || intval );
    else
        dbms_output.put_line( 'Value = ' || strval );
    end if;
end;
/

declare
    intval number;
    strval varchar2(512);
begin
    if ( dbms_utility.get_parameter_value( 'hash_join_enabled',
                                            intval,
                                            strval ) = 0 )
    then
        dbms_output.put_line( 'Value = ' || intval );
    else
        dbms_output.put_line( 'Value = ' || strval );
    end if;
end;
/

declare
    intval number;
    strval varchar2(512);
begin
    if ( dbms_utility.get_parameter_value( 'barf',
                                            intval,
                                            strval ) = 0 )
    then
        dbms_output.put_line( 'Value = ' || intval );
    else
        dbms_output.put_line( 'Value = ' || strval );
    end if;
end;
/