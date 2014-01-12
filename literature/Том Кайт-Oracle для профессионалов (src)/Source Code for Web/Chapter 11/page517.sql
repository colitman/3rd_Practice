column name format a14
column category format a14
column used format a4
column version format a9
column sql_text format a21 word_wrapped

select * from user_outlines;

column stage format 9999
column node format 999
column name format a9
column join_pos format 9999999
column hint format a20
break on stage skip 1

select stage, name, node, join_pos, hint
  from user_outline_hints
 where name = 'MYOUTLINE'
 order by stage
/
