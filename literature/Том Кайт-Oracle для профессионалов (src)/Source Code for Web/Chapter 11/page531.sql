create or replace outline my_outline
for category my_category
on select * from dual
/


create or replace outline my_other_outline
for category "My_Category"
on select * from dual
/


select name, category, sql_text from user_outlines;

exec outln_pkg.drop_by_cat( 'my_category' );


select name, category, sql_text from user_outlines;


exec outln_pkg.drop_by_cat( 'MY_CATEGORY' );


select name, category, sql_text from user_outlines;

exec outln_pkg.drop_by_cat( 'My_Category' );


select name, category, sql_text from user_outlines;

