@connect tkyte/tkyte
drop table dba_users;

create or replace
procedure show_user_info( p_username in varchar2 )
AUTHID CURRENT_USER
as
    l_rec   dba_users%rowtype;
begin
    select *
      into l_rec
      from dba_users
     where username = upper(p_username);

    dbms_output.put_line( 'create user ' || p_username  );
    if ( l_rec.password = 'EXTERNAL' ) then
        dbms_output.put_line( ' identified externally' );
    else
        dbms_output.put_line
        ( ' identified by values ''' || l_rec.password || '''' );
    end if;
    dbms_output.put_line
    ( ' temporary tablespace ' || l_rec.temporary_tablespace ||
      ' default tablespace ' || l_rec.default_tablespace ||
      ' profile ' || l_rec.profile );
exception
    when no_data_found then
        dbms_output.put_line( '*** No such user ' || p_username );
end;
/

show errs

create table dba_users
as
select * from SYS.dba_users where 1=0;

alter procedure show_user_info compile;

exec show_user_info( USER );

@connect system/manager

exec tkyte.show_user_info( 'TKYTE' )

@connect tkyte/tkyte
drop table dba_users;

drop table dba_users_template;

create table dba_users_TEMPLATE
as
select * from SYS.dba_users where 1=0;

create or replace
procedure show_user_info( p_username in varchar2 )
AUTHID CURRENT_USER
as
    type rc is ref cursor;

    l_rec    dba_users_TEMPLATE%rowtype;
    l_cursor rc;
begin
    open l_cursor for
     'select *
        from dba_users
       where username = :x'
    USING upper(p_username);

    fetch l_cursor into l_rec;
    if ( l_cursor%found ) then

        dbms_output.put_line( 'create user ' || p_username  );
        if ( l_rec.password = 'EXTERNAL' ) then
            dbms_output.put_line( ' identified externally' );
        else
            dbms_output.put_line
            ( ' identified by values ''' || l_rec.password || '''' );
        end if;
        dbms_output.put_line
        ( ' temporary tablespace ' || l_rec.temporary_tablespace ||
          ' default tablespace ' || l_rec.default_tablespace ||
          ' profile ' || l_rec.profile );
    else
        dbms_output.put_line( '*** No such user ' || p_username );
    end if;
    close l_cursor;
end;
/

exec show_user_info( USER );