drop table people;
drop type address_type;

create or replace type Address_Type
as object
(  street_addr1   varchar2(25),
   street_addr2   varchar2(25),
   city           varchar2(30),
   state          varchar2(2),
   zip_code       number
)
/

alter type Address_Type
REPLACE
as object
(  street_addr1   varchar2(25),
   street_addr2   varchar2(25),
   city           varchar2(30),
   state          varchar2(2),
   zip_code       number,
   member function toString return varchar2,
   map member function mapping_function return varchar2
)
/

create or replace type body Address_Type
as
    member function toString return varchar2
    is
    begin
        if ( street_addr2 is not NULL )
        then
            return street_addr1 || chr(10) ||
                   street_addr2 || chr(10) ||
                   city || ', ' || state || ' ' || zip_code;
        else
            return street_addr1 || chr(10) ||
                   city || ', ' || state || ' ' || zip_code;
        end if;
    end;
 
    map member function mapping_function return varchar2
    is
    begin
        return to_char( nvl(zip_code,0), 'fm00000' ) ||
               lpad( nvl(city,' '), 30 ) ||
               lpad( nvl(street_addr1,' '), 25 ) ||
               lpad( nvl(street_addr2,' '), 25 );
    end;
end;
/


create table people
( name           varchar2(10),
  home_address   address_type,
  work_address   address_type
)
/

declare
    l_home_address address_type;
    l_work_address address_type;
begin
    l_home_address := Address_Type( '123 Main Street', null,
                                    'Reston', 'CA', 45678 );
    l_work_address := Address_Type( '1 Oracle Way', null,
                                    'Redwood', 'VA', 23456 );
  
    insert into people
    ( name, home_address, work_address )
    values
    ( 'Tom Kyte', l_home_address, l_work_address );
end;
/
