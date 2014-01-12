set echo on

drop table long_table;
drop table long_raw_table;
drop table clob_table;

create table long_table
( id         int primary key,
  data       long
)
/

create table long_raw_table
( id        int primary key,
  data      long raw
)
/

declare
    l_tmp    long := 'Hello World';
    l_raw   long raw;
begin
    while( length(l_tmp) < 32000 )
    loop
        l_tmp := l_tmp || ' Hello World';
    end loop;

    insert into long_table
    ( id, data ) values
    ( 1, l_tmp );

    l_raw := utl_raw.cast_to_raw( l_tmp );

    insert into long_raw_table
    ( id, data ) values
    ( 1, l_raw );

    dbms_output.put_line( 'created long with length = ' ||
                           length(l_tmp) );
end;
/

create table clob_table
as
select id, to_lob(data) data
  from long_table;

insert into clob_table
select id, to_lob(data)
  from long_table;

begin
    insert into clob_table
    select id, to_lob(data)
      from long_table;
end;
/