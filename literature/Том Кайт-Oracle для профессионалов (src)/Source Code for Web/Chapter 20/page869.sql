set echo on

drop table people;

create or replace type Address_Type
as object
(  street_addr1   varchar2(25),
   street_addr2   varchar2(25),
   city           varchar2(30),
   state          varchar2(2),
   zip_code       number
)
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
                                    'Reston', 'VA', 45678 );
    l_work_address := Address_Type( '1 Oracle Way', null,
                                    'Redwood', 'CA', 23456 );
  
    insert into people
    ( name, home_address, work_address )
    values
    ( 'Tom Kyte', l_home_address, l_work_address );
end;
/

column name format a10
column home_address format a20
column work_address format a20
select * from people;


select name, home_address.state, work_address.state
  from people
/

column "HOME_ADDRESS.STATE" format a20
column "WORK_ADDRESS.STATE" format a20
select name, P.home_address.state, P.work_address.state
  from people P
/
