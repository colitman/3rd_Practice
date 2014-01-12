alter type Address_Type
REPLACE
as object
(  street_addr1   varchar2(25),
   street_addr2   varchar2(25),
   city           varchar2(30),
   state          varchar2(2),
   zip_code       number,
   member function toString return varchar2
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
end;
/

select name, p.home_address.toString()
  from people P
/

