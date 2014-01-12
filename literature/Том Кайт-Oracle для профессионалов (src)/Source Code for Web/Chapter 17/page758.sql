set echo on


select id
  from my_html_docs
 where contains( html_text, 'Oracle' ) > 0
/


select id
  from my_html_docs
 where contains( html_text, 'Oracle within title' ) > 0
/


select id
  from my_html_docs
 where contains( html_text, 'title' ) > 0
/


drop index my_html_idx;


create index my_html_idx on my_html_docs( html_text )
indextype is ctxsys.context
parameters( 'section group ctxsys.html_section_group' )
/


select id
  from my_html_docs
 where contains( html_text, 'html') > 0
/