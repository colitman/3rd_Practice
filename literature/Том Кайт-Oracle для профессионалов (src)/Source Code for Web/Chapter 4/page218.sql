create or replace
procedure show_iot_space
( p_segname in varchar2 )
as
    l_segname                   varchar2(30);
    l_total_blocks              number;
    l_total_bytes               number;
    l_unused_blocks             number;
    l_unused_bytes              number;
    l_LastUsedExtFileId         number;
    l_LastUsedExtBlockId        number;
    l_LAST_USED_BLOCK           number;
begin
    select 'SYS_IOT_TOP_' || object_id
      into l_segname
      from user_objects
     where object_name = upper(p_segname);

    dbms_space.unused_space
    ( segment_owner     => user,
      segment_name      => l_segname,
      segment_type      => 'INDEX',
      total_blocks      => l_total_blocks,
      total_bytes       => l_total_bytes,
      unused_blocks     => l_unused_blocks,
      unused_bytes      => l_unused_bytes,
      LAST_USED_EXTENT_FILE_ID => l_LastUsedExtFileId,
      LAST_USED_EXTENT_BLOCK_ID => l_LastUsedExtBlockId,
      LAST_USED_BLOCK => l_LAST_USED_BLOCK );

    dbms_output.put_line
    ( 'IOT used ' || to_char(l_total_blocks-l_unused_blocks) );
end;
/

drop table iot;


create table iot
( owner, object_type, object_name,
  primary key(owner,object_type,object_name)
)
organization index
NOCOMPRESS
as
select owner, object_type, object_name from all_objects
order by owner, object_type, object_name
/

set serveroutput on
exec show_iot_space( 'iot' );


drop table iot;

create table iot
( owner, object_type, object_name,
  primary key(owner,object_type,object_name)
)
organization index
compress 1
as
select owner, object_type, object_name from all_objects
order by owner, object_type, object_name
/

exec show_iot_space( 'iot' );


drop table iot;

create table iot
( owner, object_type, object_name,
  primary key(owner,object_type,object_name)
)
organization index
compress 2
as
select owner, object_type, object_name from all_objects
order by owner, object_type, object_name
/

exec show_iot_space( 'iot' );


