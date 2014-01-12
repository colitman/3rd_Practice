set echo on
set serveroutput on
set timing on


drop table t;
/

create table t
  ( x int check ( x > 5 )
  )
/



declare
      l_start number default dbms_utility.get_time;
  begin
      for i in 1 .. 1000
      loop
          insert into t values ( 10 );
      end loop;
      dbms_output.put_line
      ( round((dbms_utility.get_time-l_start)/100,2) || ' seconds' );
  end;
/


begin
      for i in 1 .. 100
      loop
          execute immediate
          'ALTER TABLE "TKYTE"."T" ADD CHECK ( x > 5 ) ENABLE ';
      end loop;
  end;
/
declare
      l_start number default dbms_utility.get_time;
  begin
      for i in 1 .. 1000
      loop
          insert into t values ( 10 );
      end loop;
     dbms_output.put_line
      ( round((dbms_utility.get_time-l_start)/100,2) || ' seconds' );
  end;
/
