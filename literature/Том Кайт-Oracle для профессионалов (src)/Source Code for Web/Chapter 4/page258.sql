create table t ( x int, y date, z varchar2(25);



create table t of Some_Type;



create or replace type address_type
  as object
  ( city    varchar2(30),
    street  varchar2(30),
    state   varchar2(2),
    zip     number
  )
/



create or replace type person_type
  as object
  ( name             varchar2(30),
    dob              date,
    home_address     address_type,
    work_address     address_type
  )
/


create table people of person_type
/


desc people


insert into people values ( 'Tom', '15-mar-1965',
  address_type( 'Reston', '123 Main Street', 'Va', '45678' ),
  address_type( 'Redwood', '1 Oracle Way', 'Ca', '23456' ) );
/


select * from people;


select name, p.home_address.city from people p;



select name, segcollength
    from sys.col$
   where obj# = ( select object_id
                    from user_objects
                   where object_name = 'PEOPLE' )
/

select sys_nc_rowinfo$ from people;


CREATE TABLE "TKYTE"."PEOPLE"
  OF "PERSON_TYPE"
/

select name, type#, segcollength
    from sys.col$
    where obj# = ( select object_id
                  from user_objects
                  where object_name = 'PEOPLE' )
    and name like 'SYS\_NC\_%' escape '\'
/


insert into people(name)
 select rownum from all_objects;


analyze table people compute statistics;

select table_name, avg_row_len from user_object_tables;


CREATE TABLE "TKYTE"."PEOPLE"
  OF "PERSON_TYPE"
  ( constraint people_pk primary key(name) )
  object identifier is PRIMARY KEY
/

select name, type#, segcollength
    from sys.col$
   where obj# = ( select object_id
                    from user_objects
                   where object_name = 'PEOPLE' )
     and name like 'SYS\_NC\_%' escape '\'
/


insert into people (name)
 values ( 'Hello World!' );

select sys_nc_oid$ from people p;

select utl_raw.cast_to_raw( 'Hello World!' ) data
  from dual;

select utl_raw.cast_to_varchar2(sys_nc_oid$) data
  from people;

insert into people(name)
  select rownum from all_objects;

analyze table people compute statistics;

select table_name, avg_row_len from user_object_tables;

create table people_tab
  (  name        varchar2(30) primary key,
     dob         date,
     home_city   varchar2(30),
     home_street varchar2(30),
     home_state  varchar2(2),
     home_zip    number,
     work_city   varchar2(30),
     work_street varchar2(30),
     work_state  varchar2(2),
     work_zip    number
  )
/

create view people of person_type
  with object identifier (name)
  as
  select name, dob,
    address_type(home_city,home_street,home_state,home_zip) home_adress,
    address_type(work_city,work_street,work_state,work_zip) work_adress
    from people_tab
/

insert into people values ( 'Tom', '15-mar-1965',
  address_type( 'Reston', '123 Main Street', 'Va', '45678' ),
  address_type( 'Redwood', '1 Oracle Way', 'Ca', '23456' ) );