set echo on

alter table sales drop constraint t_fk_time;
alter table sales drop constraint t_fk_cust;

alter table sales add constraint t_fk_time
foreign key( trans_date) references time_hierarchy( day )
rely enable novalidate
/

alter table sales add constraint t_fk_cust
foreign key( cust_id) references customer_hierarchy
rely enable novalidate
/

exec dbms_olap.recommend_mv( 'SALES', 10000000000, '' );

set echo OFF
@C:\oracle\RDBMS\demo\sadvdemo
set echo ON
exec demo_sumadv.prettyprint_recommendations