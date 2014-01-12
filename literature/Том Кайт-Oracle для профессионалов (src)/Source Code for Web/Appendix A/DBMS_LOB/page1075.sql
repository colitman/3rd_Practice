set echo on

drop table t;

create table t ( str varchar2(10), lob clob );

insert into t values ( 'hello', 'hello' );

select substr( str, 3, 2 ), 
       dbms_lob.substr( lob, 3, 2) lob
  from t
/