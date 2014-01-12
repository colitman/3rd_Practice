set echo on


drop table my_html_docs;


create table my_html_docs
( id number primary key,
  html_text varchar2(4000))
/


insert into my_html_docs( id, html_text )
values( 1,
'<html>
<title>Oracle Technology</title>
<body>This is about the wonderful marvels of 8i and 9i</body>
</html>' )
/


commit;


create index my_html_idx on my_html_docs( html_text )
indextype is ctxsys.context
/


select id from my_html_docs
 where contains( html_text, 'Oracle' ) > 0
/


select id from my_html_docs
 where contains( html_text, 'html' ) > 0
/


begin
ctx_ddl.create_section_group('my_section_group','BASIC_SECTION_GROUP');
ctx_ddl.add_field_section(
    group_name => 'my_section_group',
    section_name => 'Title',
    tag          => 'title',
    visible      => FALSE );
end;
/


drop index my_html_idx;


create index my_html_idx on my_html_docs( html_text )
indextype is ctxsys.context
parameters( 'section group my_section_group' )
/