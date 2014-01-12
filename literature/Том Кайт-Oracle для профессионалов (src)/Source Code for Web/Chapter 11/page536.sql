set echo on
set serveroutput on
begin
   for i in 1 .. 100 loop
         begin
              execute immediate 'drop table t'||i;
         exception
              when others then null;
         end;
         execute immediate 'create table t'||i||' ( dummy char(1) )';
         execute immediate 'insert into t'||i||' values ( ''x'' )';
   end loop;
end;
/
set echo off
set serveroutput off
@examp09
set serveroutput on


set echo on
prompt once to parse
@examp16a
set echo off
prompt after the parse
@examp16a
prompt again after the parse
@examp16a
alter session set create_stored_outlines = testing;
prompt now with outlines created
@examp16a
prompt and again
@examp16a
prompt and again
@examp16a
prompt and again
@examp16a
prompt and again
@examp16a
alter session set create_stored_outlines = false;
