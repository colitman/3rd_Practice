set echo on

alter session set query_rewrite_enabled=true;

alter session set query_rewrite_integrity=enforced;

drop table t1;
drop table t2;

create table t1 ( owner varchar2(30), flag char(1) );
create table t2 ( object_type varchar2(30), flag char(1) );

set autotrace traceonly explain
select a.owner, count(*), b.owner
  from my_all_objects a, t1 b
 where a.owner = b.owner
   and b.flag is not null
 group by a.owner, b.owner
/
select a.owner, count(*), b.object_type
  from my_all_objects a, t2 b
 where a.object_type = b.object_type
   and b.flag is not null
 group by a.owner, b.object_type
/
set autotrace off
