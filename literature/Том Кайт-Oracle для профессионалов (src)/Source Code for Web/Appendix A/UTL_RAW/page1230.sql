set echo on

drop table t;

create table t ( r raw(10) );

insert into t values ( utl_raw.cast_to_raw('helloWorld' ) );

select dump(r) r1, dump(utl_raw.cast_to_varchar2(r)) r1
            from t;

select utl_raw.length(r), length(r)/2 from t;

select utl_raw.substr(r,2,3) r1,
       hextoraw(substr(r,3,6)) r2
  from t
