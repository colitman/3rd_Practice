set echo on
set serveroutput on

create or replace
  procedure get_dir_list( p_directory in varchar2 )
  as language java
  name 'DirList.getList( java.lang.String )';  /*