alter type Address_Type
REPLACE
as object
(  street_addr1   varchar2(25),
   street_addr2   varchar2(25),
   city           varchar2(30),
   state          varchar2(2),
   zip_code       number,
   member function toString return varchar2,
   order member function order_function( compare2 in Address_type )
   return number
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

    order member function order_function(compare2 in Address_type)
    return number
    is
    begin
        if (nvl(self.zip_code,-99999) <> nvl(compare2.zip_code,-99999))
        then
            return sign(nvl(self.zip_code,-99999)
                          - nvl(compare2.zip_code,-99999));
        end if;
        if (nvl(self.city,chr(0)) > nvl(compare2.city,chr(0)))
        then
            return 1;
        elsif (nvl(self.city,chr(0)) < nvl(compare2.city,chr(0)))
        then
            return -1;
        end if;
        if ( nvl(self.street_addr1,chr(0)) >
                     nvl(compare2.street_addr1,chr(0))  )
        then
            return 1;
        elsif ( nvl(self.street_addr1,chr(0)) <
                     nvl(compare2.street_addr1,chr(0)) )
        then
            return -1;
        end if;
        if ( nvl(self.street_addr2,chr(0)) >
                     nvl(compare2.street_addr2,chr(0))  )
        then
            return 1;
        elsif ( nvl(self.street_addr2,chr(0)) <
                     nvl(compare2.street_addr2,chr(0)) )
        then
            return -1;
        end if;
        return 0;
    end;
end;
/

