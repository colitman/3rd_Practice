set echo on


drop table image_load;

create table image_load(
  id number,
  name varchar2(255),
  image ordsys.ordimage
)
/

desc image_load


desc ordsys.ordimage

desc ordsys.ordsource
