set echo on

drop table perm;
drop table temp;

create table perm
( x char(2000) default 'x',
  y char(2000) default 'y',
  z char(2000) default 'z' )
/

create global temporary table temp
( x char(2000) default 'x',
  y char(2000) default 'y',
  z char(2000) default 'z' )
on commit preserve rows
/

create or replace procedure do_sql( p_sql in varchar2 )
as
    l_start_redo    number;
    l_redo            number;
begin
    select value into l_start_redo from redo_size;

    execute immediate p_sql;
    commit;

    select value-l_start_redo into l_redo from redo_size;

    dbms_output.put_line
    ( to_char(l_redo,'9,999,999') ||' bytes of redo generated for "' ||
      substr( replace( p_sql, chr(10), ' '), 1, 25 ) || '"...' );
end;
/

set serveroutput on format wrapped

begin
    do_sql( 'insert into perm (x,y,z)
             select 1,1,1
               from all_objects
              where rownum <= 500' );

    do_sql( 'insert into temp (x,y,z)
             select 1,1,1
               from all_objects
              where rownum <= 500' );

    do_sql( 'update perm set x = 2' );
    do_sql( 'update temp set x = 2' );

    do_sql( 'delete from perm' );
    do_sql( 'delete from temp' );
end;
/