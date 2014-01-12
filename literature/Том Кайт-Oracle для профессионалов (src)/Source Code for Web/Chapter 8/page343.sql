set echo on
set serveroutput on


rename modified_a_column to modified_a_column_TEMP;


create or replace view modified_a_column
  as
  select 1 x, 1 y from modified_a_column_TEMP;


create or replace trigger modified_a_column_IOI
  instead of insert on modified_a_column
  begin
          insert into modified_a_column_TEMP
          ( x, y )
          values
          ( :new.x, to_date('01012001','ddmmyyyy')+:new.y );
  end;
/

rename dropped_a_column  to dropped_a_column_TEMP;


create or replace view dropped_a_column
  as
  select 1 x, 1 y from dropped_a_column_TEMP;
/

create or replace trigger dropped_a_column_IOI
  instead of insert on dropped_a_column
  begin
           insert into dropped_a_column_TEMP
           ( x )
           values
           ( :new.x );
   end;
 /



host imp userid=tkyte/tkyte full=y ignore=y

