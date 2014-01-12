set echo on
set serveroutput on

begin
     dbms_stats.set_table_stats( ownname => USER,
                                 tabname => 'T',
                                 numrows => 500,
                                 numblks => 7,
                                 avgrlen => 100 );
  end;
/



select table_name, num_rows, blocks, avg_row_len 
               from user_tables
              where table_name = 'T';



create global temporary table temp_all_objects
  as
  select * from all_objects where 1=0
/


create index temp_all_objects_idx on temp_all_objects(object_id)
/


insert into temp_all_objects
  select * from all_objects where rownum < 51
/


set autotrace on explain

select /*+ ALL_ROWS */ object_type, count(*)
   FROM temp_all_objects
   where object_id < 50000
    group by object_type
/



set autotrace off


drop table temp_all_objects;

create table temp_all_objects
  as
  select * from all_objects where 1=0
/


create index temp_all_objects_idx on temp_all_objects(object_id)
/




insert into temp_all_objects
  select * from all_objects where rownum < 51;



analyze table temp_all_objects compute statistics;


analyze table temp_all_objects compute statistics for all indexes;



begin
      dbms_stats.create_stat_table( ownname => USER,
                                    stattab => 'STATS' );

      dbms_stats.export_table_stats( ownname => USER,
                                     tabname => 'TEMP_ALL_OBJECTS',
                                     stattab => 'STATS' );
      dbms_stats.export_index_stats( ownname => USER,
                                     indname => 'TEMP_ALL_OBJECTS_IDX',
                                     stattab => 'STATS' );
end;
/


drop table temp_all_objects;


create global temporary table temp_all_objects
  as
  select * from all_objects where 1=0
/


create index temp_all_objects_idx on temp_all_objects(object_id)
/


begin
      dbms_stats.import_table_stats( ownname => USER,
                                     tabname => 'TEMP_ALL_OBJECTS',
                                     stattab => 'STATS' );
      dbms_stats.import_index_stats( ownname => USER,
                                     indname => 'TEMP_ALL_OBJECTS_IDX',
                                     stattab => 'STATS' );
end;
/

insert into temp_all_objects
  select * from all_objects where rownum < 51
/

set autotrace on

select /*+ ALL_ROWS */ object_type, count(*)
   FROM temp_all_objects
   where object_id < 50000
   group by object_type
/


