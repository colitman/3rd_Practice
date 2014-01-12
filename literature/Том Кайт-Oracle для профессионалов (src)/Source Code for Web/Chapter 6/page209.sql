set echo on

drop table t;


create table t
( a int,
  b varchar2(4000) default rpad('*',4000,'*'),
  c varchar2(3000) default rpad('*',3000,'*' )
)
/

insert into t (a) values ( 1);
insert into t (a) values ( 2);
insert into t (a) values ( 3);
delete from t where a = 2 ;
insert into t (a) values ( 4);
select a from t;


REM bonus example showing the above sort of effect without
REM a delete


insert into t(a) select rownum from all_users;
commit;
update t set b = null, c = null;
set serveroutput on
commit;
exec show_space( 'T' )
insert into t(a) select rownum+1000 from all_users;
select dbms_rowid.rowid_block_number(rowid), a from t;
