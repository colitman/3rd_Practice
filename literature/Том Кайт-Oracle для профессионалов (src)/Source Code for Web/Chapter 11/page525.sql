create or replace outline my_outline
for category my_category
on select * from all_objects
/

select name, category, sql_text from user_outlines
/


select count(*) from user_outline_hints where name = 'MY_OUTLINE';

alter outline my_outline rename to plan_for_all_objects
/
select name, category, sql_text from user_outlines
/

alter outline plan_for_all_objects change category to dictionary_plans
/
select name, category, sql_text from user_outlines
/


set echo off
set verify off
@su sys
set echo on

alter session set optimizer_goal = choose
/
set autotrace traceonly explain
select * from all_objects;
set autotrace off

alter session set optimizer_goal = all_rows
/

set autotrace traceonly explain
select * from all_objects;
set autotrace off

set echo off
set verify off
@su tkyte
set echo on


alter session set optimizer_goal = all_rows
/
alter outline plan_for_all_objects rebuild
/

select count(*) from user_outline_hints where name = 'PLAN_FOR_ALL_OBJECTS'
/

