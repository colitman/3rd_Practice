connect tkyte/tkyte 

alter system flush shared_pool;



select * from t where x = 5;


alter session set optimizer_goal=first_rows;


select * from t where x = 5;


connect scott/tiger

select * from t where x = 5;


connect tkyte/tkyte

select sql_text, version_count
    from v$sqlarea
   where sql_text like 'select * from t where x = 5%'
/

