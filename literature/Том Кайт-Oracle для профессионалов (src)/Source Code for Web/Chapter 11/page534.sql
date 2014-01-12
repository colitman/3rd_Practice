set echo on


alter session set cursor_sharing = force;


create or replace outline my_outline
for category my_category
on select * from dual where dummy = 'X';


alter session set create_stored_outlines = true;


select * from dual where dummy = 'X';

alter session set create_stored_outlines = false;


select name, category, sql_text from user_outlines;

