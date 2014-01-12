set echo on
set serveroutput on


drop table t;
/

create table t ( c varchar2(1) );
Table created.

insert into t values ( chr(235) );
1 row created.

select dump(c) from t;

commit;


host exp userid=tkyte/tkyte tables=t

host imp userid=tkyte/tkyte full=y ignore=y

select dump(c) from t;
/
