set echo on

set timing off

analyze table colocated 
compute statistics 
for table
for all indexes
for all indexed columns
/
analyze table disorganized 
compute statistics 
for table
for all indexes
for all indexed columns
/

select a.index_name, 
       b.num_rows, 
	   b.blocks,
	   a.clustering_factor 
  from user_indexes a, user_tables b
where index_name in ('COLOCATED_PK', 'DISORGANIZED_PK' )
  and a.table_name = b.table_name
/

set timing on
set autotrace traceonly
select * from COLOCATED where x between 20000 and 30000;
select * from DISORGANIZED where x between 20000 and 30000;
set autotrace off
set timing off
