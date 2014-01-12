create outline outline_1
for category CAT_1
on select * from dual
/


create outline outline_2
for category CAT_2
on select * from dual
/


create outline outline_3
for category CAT_2
on select * from dual A
/

select category, name, sql_text
  from user_outlines
 order by category, name
/

exec outln_pkg.update_by_cat( 'CAT_2', 'CAT_1' );

select category, name, sql_text
  from user_outlines
 order by category, name
/

drop outline outline_1;
exec outln_pkg.update_by_cat( 'CAT_2', 'CAT_1' );

select category, name, sql_text
  from user_outlines
 order by category, name
/

