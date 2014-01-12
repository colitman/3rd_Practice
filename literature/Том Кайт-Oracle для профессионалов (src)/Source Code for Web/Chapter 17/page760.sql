set echo on


drop table my_xml_docs;


create table my_xml_docs
( id     number primary key,
  xmldoc varchar2(4000)
)
/


insert into my_xml_docs( id, xmldoc )
values( 1,
'<appointment type="personal">
    <title>Team Meeting</title>
    <start_date>31-MAR-2001</start_date>
    <start_time>1100</start_time>
    <notes>Review projects for Q1</notes>
    <attendees>
        <attendee>Joel</attendee>
        <attendee>Tom</attendee>
    </attendees>
</appointment>' )
/


commit;


create index my_xml_idx on my_xml_docs( xmldoc )
indextype is ctxsys.context
parameters('section group ctxsys.auto_section_group')
/


select id
  from my_xml_docs
 where contains( xmldoc, 'projects within notes' ) > 0
/


select id
  from my_xml_docs
 where contains( xmldoc, 'projects within appointment' ) > 0
/


select id
  from my_xml_docs
 where contains( xmldoc, 'Joel within attendees' ) > 0
/


select id
  from my_xml_docs
 where contains( xmldoc, 'personal within appointment@type' ) > 0
/