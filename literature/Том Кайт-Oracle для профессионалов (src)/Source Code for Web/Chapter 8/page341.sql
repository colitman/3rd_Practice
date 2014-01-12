set echo on
set serveroutput on

create table added_a_column ( x int );

create table dropped_a_column ( x int, y int );

create table modified_a_column( x int, y int );

insert into added_a_column values ( 1 );

insert into dropped_a_column values ( 1, 1 );

insert into modified_a_column values ( 1, 1 );

commit;

host exp userid=tkyte/tkyte tables=(added_a_column,dropped_a_column,modified_a_column)
