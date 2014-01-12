set echo on
set linesize 73

create or replace type Address_Array_Type
as varray(25) of Address_Type
/

alter table people add previous_addresses Address_Array_Type
/

set describe depth all
desc people

select name, length
  from sys.col$
 where obj# = ( select object_id
                  from user_objects
                 where object_name = 'PEOPLE' )
/

