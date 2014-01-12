set echo on

column u new_val uname
select user u from dual;

drop table compile_schema_tmp
/

create global temporary table compile_schema_tmp
( object_name varchar2(30),
  object_type varchar2(30),
  constraint compile_schema_tmp_pk
  primary key(object_name,object_type)
)
on commit preserve rows
/

grant all on compile_schema_tmp to public
/

create or replace
procedure get_next_object_to_compile( p_username in varchar2,
                                      p_cmd out varchar2,
                                      p_obj out varchar2,
                                      p_typ out varchar2 )
as
begin
    select 'alter ' || object_type || ' '
           || p_username || '.' || object_name ||
          decode( object_type, 'PACKAGE BODY', ' compile body',
                  ' compile' ), object_name, object_type
      into p_cmd, p_obj, p_typ
      from dba_objects a
     where owner = upper(p_username)
       and status = 'INVALID'
       and object_type <> 'UNDEFINED'
       and not exists ( select null
                          from compile_schema_tmp b
                         where a.object_name = b.object_name
                           and a.object_type = b.object_type
                      )
       and rownum = 1;

    insert into compile_schema_tmp
    ( object_name, object_type )
    values
    ( p_obj, p_typ );
end;
/

create or replace procedure compile_schema( p_username in varchar2 )
authid current_user
as
    l_cmd  varchar2(512);
    l_obj  dba_objects.object_name%type;
    l_typ  dba_objects.object_type%type;
begin
    delete from &uname..compile_schema_tmp;

    loop
        get_next_object_to_compile( p_username, l_cmd, l_obj, l_typ );

        dbms_output.put_line( l_cmd );
        begin
            execute immediate l_cmd;
            dbms_output.put_line( 'Successful' );
        exception
            when others then
                dbms_output.put_line( sqlerrm );
        end;
        dbms_output.put_line( chr(9) );
    end loop;

exception 
    when no_data_found then NULL;
end;
/

grant execute on compile_schema to public
/