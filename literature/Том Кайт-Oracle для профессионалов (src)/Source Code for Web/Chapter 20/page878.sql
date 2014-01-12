set echo on

alter table people drop column previous_addresses
/

create or replace type Address_Array_Type
as varray(50) of Address_Type
/

alter table people add previous_addresses Address_Array_Type
/

select object_type, object_name,
                decode(status,'INVALID','*','') status,
                tablespace_name
from user_objects a, user_segments b
where a.object_name = b.segment_name (+)
order by object_type, object_name
/

select name, length
  from sys.col$
 where obj# = ( select object_id
                  from user_objects
                 where object_name = 'PEOPLE' )
/

update people
   set previous_addresses = Address_Array_Type(
                       Address_Type( '312 Johnston Dr', null,
                                     'Bethlehem', 'PA', 18017 ),
                       Address_Type( '513 Zulema St', 'Apartment #3',
                                     'Pittsburg', 'PA', 18123 ),
                       Address_Type( '840 South Frederick St', null,
                                     'Alexandria', 'VA', 20654 ) );
/


select name, prev.city, prev.state, prev.zip_code
  from people p, table( p.previous_addresses ) prev
 where prev.state = 'PA';
/

