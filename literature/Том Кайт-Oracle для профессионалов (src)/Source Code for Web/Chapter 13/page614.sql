set echo on

alter session set query_rewrite_enabled=true;
alter session set query_rewrite_integrity=trusted;

drop table customer_hierarchy cascade constraints
/

create table customer_hierarchy
( cust_id primary key, zip_code, region )
organization index
as
select cust_id,
	  mod( rownum, 6 ) || to_char(mod( rownum, 1000 ), 'fm0000') zip_code,
	  mod( rownum, 6 ) region
  from ( select distinct cust_id from sales)
/

analyze table customer_hierarchy compute statistics;

drop materialized view sales_mv;

create materialized view sales_mv
build immediate
refresh on demand
enable query rewrite
as
select customer_hierarchy.zip_code, 
       time_hierarchy.mmyyyy,
       sum(sales.sales_amount) sales_amount
  from sales, time_hierarchy, customer_hierarchy
 where sales.trans_date = time_hierarchy.day
   and sales.cust_id = customer_hierarchy.cust_id
 group by customer_hierarchy.zip_code, time_hierarchy.mmyyyy
/

set autotrace traceonly
select customer_hierarchy.zip_code, 
       time_hierarchy.mmyyyy,
       sum(sales.sales_amount) sales_amount
  from sales, time_hierarchy, customer_hierarchy
 where sales.trans_date = time_hierarchy.day
   and sales.cust_id = customer_hierarchy.cust_id
 group by customer_hierarchy.zip_code, time_hierarchy.mmyyyy
/

select customer_hierarchy.region, 
       time_hierarchy.yyyy,
       sum(sales.sales_amount) sales_amount
  from sales, time_hierarchy, customer_hierarchy
 where sales.trans_date = time_hierarchy.day
   and sales.cust_id = customer_hierarchy.cust_id
 group by customer_hierarchy.region, time_hierarchy.yyyy
/
set autotrace off

drop dimension time_hierarchy_dim
/

create dimension sales_dimension
	level cust_id	is customer_hierarchy.cust_id
	level zip_code	is customer_hierarchy.zip_code
	level region	is customer_hierarchy.region
	level day       is time_hierarchy.day
	level mmyyyy    is time_hierarchy.mmyyyy
	level qtr_yyyy  is time_hierarchy.qtr_yyyy
	level yyyy      is time_hierarchy.yyyy
hierarchy cust_rollup
(
	cust_id child of
	zip_code child of
	region
)
hierarchy time_rollup
(
day child of
mmyyyy child of
 qtr_yyyy child of
 yyyy
)
attribute mmyyyy
determines mon_yyyy;

set autotrace on

select customer_hierarchy.region, 
       time_hierarchy.yyyy,
       sum(sales.sales_amount) sales_amount
  from sales, time_hierarchy, customer_hierarchy
 where sales.trans_date = time_hierarchy.day
   and sales.cust_id = customer_hierarchy.cust_id
 group by customer_hierarchy.region, time_hierarchy.yyyy
/

set autotrace off