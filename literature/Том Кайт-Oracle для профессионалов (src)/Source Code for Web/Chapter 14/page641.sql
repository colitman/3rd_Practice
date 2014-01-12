
drop table range_example;
drop table test;


CREATE TABLE range_example
( range_key_column date, 
  x                int,
  data             varchar2(20)
)
PARTITION BY RANGE (range_key_column)
( PARTITION part_1 VALUES LESS THAN
       (to_date('01-jan-1995','dd-mon-yyyy')),
  PARTITION part_2 VALUES LESS THAN
       (to_date('01-jan-1996','dd-mon-yyyy'))
)
/
alter table range_example 
add constraint range_example_pk
primary key (range_key_column,x)
using index local
/
insert into range_example values ( to_date( '01-jan-1994' ), 1, 'xxx' );
insert into range_example values ( to_date( '01-jan-1995' ), 2, 'xxx' );

create table test ( pk , range_key_column , x, 
                    constraint test_pk primary key(pk) )
as
select rownum, range_key_column, x from range_example
/

set autotrace on explain

select * from test, range_example
  where test.pk = 1
  and test.range_key_column = range_example.range_key_column
  and test.x = range_example.x
/

alter table range_example
drop constraint range_example_pk
/

alter table range_example 
add constraint range_example_pk
primary key (x,range_key_column)
using index local
/
select * from test, range_example
  where test.pk = 1
  and test.range_key_column = range_example.range_key_column
  and test.x = range_example.x
/
set autotrace off
