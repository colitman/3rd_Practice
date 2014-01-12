create table fy_1999 ( timestamp date, id int );

create index fy_1999_idx on fy_1999(id)
/

create table fy_2001 ( timestamp date, id int );

insert /*+ APPEND */ into fy_2001
select to_date('31-dec-2001')-mod(rownum,360), object_id
from all_objects
/

commit;

create index fy_2001_idx on fy_2001(id) nologging
/

alter table partitioned
exchange partition fy_1999
with table fy_1999
including indexes
without validation
/

alter table partitioned
drop partition fy_1999
/

alter table partitioned
split partition the_rest
at ( to_date('01-jan-2002','dd-mon-yyyy') )
into ( partition fy_2001, partition the_rest )
/

alter table partitioned
exchange partition fy_2001
with table fy_2001
including indexes
without validation
/

select index_name, status from user_indexes;

select count(*)
from partitioned
where timestamp between sysdate-50 and sysdate;

