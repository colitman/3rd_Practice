set echo on

create table t1 ( x int primary key, y int );


create table t2 (col1 int references t1, col2 int check (col2>0));


create index t2_idx on t2(col2,col1);
/

create trigger t2_trigger before insert or update of col1, col2 on t2 for each row
  begin
      if ( :new.col1 < :new.col2 ) then
         raise_application_error(-20001,
                      'Invalid Operation Col1 cannot be less then Col2');
      end if;
  end;
/


create view v
  as
  select t1.y t1_y, t2.col2 t2_col2 from t1, t2 where t1.x = t2.col1
/
