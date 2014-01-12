set echo on

alter session set use_stored_outlines=testing;
select used, count(*) from user_outlines group by used;

set echo off
@examp16a

set echo on
select used, count(*) from user_outlines group by used;

set echo off
@examp16a
@examp16a

