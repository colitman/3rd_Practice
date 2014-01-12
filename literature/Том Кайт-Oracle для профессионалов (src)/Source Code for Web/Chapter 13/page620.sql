set echo on
drop table time_rollup
/

create table time_rollup
( day      date,
  mon      number,
  year     number
)
/

insert into time_rollup
select dt, to_char(dt,'mm'), to_char(dt,'yyyy')
  from ( select trunc(sysdate,'year')+rownum-1 dt 
           from all_objects where rownum < 366 )
/

insert into time_rollup values
( add_months(sysdate,12),
  to_char(add_months(sysdate,12),'mm'),
  to_char(add_months(sysdate,12),'yyyy') );

analyze table time_rollup compute statistics;

select distinct mon, year
  from time_rollup
/

drop dimension time_rollup_dim
/

create dimension time_rollup_dim
  level day is time_rollup.day
   level mon is time_rollup.mon
   level year is time_rollup.year
hierarchy time_rollup
(
        day child of mon child of year
)
/

exec dbms_olap.validate_dimension( 'time_rollup_dim', user, false, false );

select * from mview$_exceptions;

select * from time_rollup
 where rowid in ( select bad_rowid from mview$_exceptions );

