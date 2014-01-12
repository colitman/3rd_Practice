set echo on

delete from plan_table;
commit;

analyze table sales_mv DELETE statistics;

declare
    num_rows number;
    num_bytes number;
begin
    dbms_olap.estimate_summary_size
    ( 'SALES_MV_ESTIMATE',
       'select customer_hierarchy.zip_code,
               time_hierarchy.mmyyyy,
               sum(sales.sales_amount) sales_amount
          from sales, time_hierarchy, customer_hierarchy
         where sales.trans_date = time_hierarchy.day
           and sales.cust_id = customer_hierarchy.cust_id
         group by customer_hierarchy.zip_code, time_hierarchy.mmyyyy',
      num_rows,
      num_bytes );

    dbms_output.put_line( num_rows || ' rows' );
    dbms_output.put_line( num_bytes || ' bytes' );
end;
/

analyze table sales_mv COMPUTE statistics;

select count(*) from sales_mv;

select blocks * 8 * 1024
  from user_tables
 where table_name = 'SALES_MV'
/