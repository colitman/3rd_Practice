create or replace
procedure show_space
( p_segname in varchar2,
  p_owner   in varchar2 default user,
  p_type    in varchar2 default 'TABLE',
  p_partition in varchar2 default NULL )
as
    l_free_blks                 number;

    l_total_blocks              number;
    l_total_bytes               number;
    l_unused_blocks             number;
    l_unused_bytes              number;
    l_LastUsedExtFileId         number;
    l_LastUsedExtBlockId        number;
    l_last_used_block           number;
    procedure p( p_label in varchar2, p_num in number )
    is
    begin
        dbms_output.put_line( rpad(p_label,40,'.') ||
                              p_num );
    end;
begin
    dbms_space.free_blocks
    ( segment_owner     => p_owner,
      segment_name      => p_segname,
      segment_type      => p_type,
	  partition_name    => p_partition,
      freelist_group_id => 0,
      free_blks         => l_free_blks );

    dbms_space.unused_space
    ( segment_owner     => p_owner,
      segment_name      => p_segname,
      segment_type      => p_type,
	  partition_name    => p_partition,
      total_blocks      => l_total_blocks,
      total_bytes       => l_total_bytes,
      unused_blocks     => l_unused_blocks,
      unused_bytes      => l_unused_bytes,
      last_used_extent_file_id => l_LastUsedExtFileId,
      last_used_extent_block_id => l_LastUsedExtBlockId,
      last_used_block => l_last_used_block );

    p( 'Free Blocks', l_free_blks );
    p( 'Total Blocks', l_total_blocks );
    p( 'Total Bytes', l_total_bytes );
    p( 'Unused Blocks', l_unused_blocks );
    p( 'Unused Bytes', l_unused_bytes );
    p( 'Last Used Ext FileId', l_LastUsedExtFileId );
    p( 'Last Used Ext BlockId', l_LastUsedExtBlockId );
    p( 'Last Used Block', l_last_used_block );
end;
/
