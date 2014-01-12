set linesize 500
set trimspool on
set feedback off
set heading off
set embedded on
spool logmnr.opt
select
    'colmap = ' || user || ' ' || table_name || ' (' ||
   max( decode( column_id, 1,       column_id  , null ) ) ||
   max( decode( column_id, 1, ', '||column_name, null ) ) ||
   max( decode( column_id, 2, ', '||column_id  , null ) ) ||
   max( decode( column_id, 2, ', '||column_name, null ) ) ||
   max( decode( column_id, 3, ', '||column_id  , null ) ) ||
   max( decode( column_id, 3, ', '||column_name, null ) ) ||
   max( decode( column_id, 4, ', '||column_id  , null ) ) ||
   max( decode( column_id, 4, ', '||column_name, null ) ) ||
   max( decode( column_id, 5, ', '||column_id  , null ) ) ||
   max( decode( column_id, 5, ', '||column_name, null ) ) || ');' colmap
 from user_tab_columns
group by user, table_name
/
spool off

