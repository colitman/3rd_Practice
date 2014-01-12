drop table temp_table_session;

drop table temp_table_transaction;


create global temporary table temp_table_session
on commit preserve rows
as
select * from scott.emp where 1=0
/

create global temporary table temp_table_transaction
on commit delete rows
as
select * from scott.emp where 1=0
/

insert into temp_table_session select * from scott.emp;

insert into temp_table_transaction select * from scott.emp;


select session_cnt, transaction_cnt 
  from ( select count(*) session_cnt from temp_table_session ),
       ( select count(*) transaction_cnt from temp_table_transaction );

commit;

select session_cnt, transaction_cnt 
  from ( select count(*) session_cnt from temp_table_session ),
       ( select count(*) transaction_cnt from temp_table_transaction );

disconnect
connect tkyte/tkyte

select session_cnt, transaction_cnt 
  from ( select count(*) session_cnt from temp_table_session ),
       ( select count(*) transaction_cnt from temp_table_transaction );
