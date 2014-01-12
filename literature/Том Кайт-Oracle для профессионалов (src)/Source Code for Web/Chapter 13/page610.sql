set echo  on

drop table sales;

create table sales 
(trans_date date, cust_id int, sales_amount number );

insert /*+ APPEND */ into sales
select trunc(sysdate,'year')+mod(rownum,366) TRANS_DATE,
        mod(rownum,100) CUST_ID,
        abs(dbms_random.random)/100 SALES_AMOUNT
  from all_objects
/
commit;

begin
    for i in 1 .. 4
    loop
        insert /*+ APPEND */ into sales
        select trans_date, cust_id, abs(dbms_random.random)/100 SALES_AMOUNT
          from sales;
        commit;
   end loop;
end;
/

select count(*) from sales;

drop table time_hierarchy cascade constraints;

create table time_hierarchy
(day primary key, mmyyyy, mon_yyyy, qtr_yyyy, yyyy) 
organization index
as
select distinct
   trans_date    DAY,
   cast (to_char(trans_date,'mmyyyy') as number) MMYYYY,
   to_char(trans_date,'mon-yyyy') MON_YYYY,
   'Q' || ceil( to_char(trans_date,'mm')/3) || ' FY'
       || to_char(trans_date,'yyyy') QTR_YYYY,
   cast( to_char( trans_date, 'yyyy' ) as number ) YYYY
  from sales
/

analyze table sales compute statistics;

analyze table time_hierarchy compute statistics;

drop materialized view sales_mv;
drop dimension time_hierarchy_dim;

create materialized view sales_mv
build immediate
refresh on demand
enable query rewrite
as
select sales.cust_id, sum(sales.sales_amount) sales_amount, 
       time_hierarchy.mmyyyy
  from sales, time_hierarchy
 where sales.trans_date = time_hierarchy.day
 group by sales.cust_id, time_hierarchy.mmyyyy
/

alter session set query_rewrite_enabled=true;
alter session set query_rewrite_integrity=trusted;

set autotrace on

select time_hierarchy.mmyyyy, sum(sales_amount)
  from sales, time_hierarchy
 where sales.trans_date = time_hierarchy.day
 group by time_hierarchy.mmyyyy
/
set autotrace off

set timing on
set autotrace on
select time_hierarchy.qtr_yyyy, sum(sales_amount)
 from sales, time_hierarchy
where sales.trans_date = time_hierarchy.day
group by time_hierarchy.qtr_yyyy
/
set autotrace off

create dimension time_hierarchy_dim
	level day      is time_hierarchy.day
	level mmyyyy   is time_hierarchy.mmyyyy
	level qtr_yyyy is time_hierarchy.qtr_yyyy
	level yyyy     is time_hierarchy.yyyy
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
select time_hierarchy.qtr_yyyy, sum(sales_amount)
 from sales, time_hierarchy 
where sales.trans_date = time_hierarchy.day
group by time_hierarchy.qtr_yyyy
/

set autotrace off