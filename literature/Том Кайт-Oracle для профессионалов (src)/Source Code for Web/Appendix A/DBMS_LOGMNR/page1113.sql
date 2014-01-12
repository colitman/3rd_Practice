set echo on

create or replace type myScalarType
as object
( x int, y date, z varchar2(25) );
/

create or replace type myArrayType
as varray(25) of myScalarType
/

create or replace type myTableType
as table of myScalarType
/

drop table t;

create table t ( a int, b myArrayType, c myTableType )
nested table c store as c_tbl
/

begin
   sys.dbms_logmnr_d.build( 'miner_dictionary.dat',
                            'c:\temp' );
end;
/

alter system switch logfile;

insert into t values ( 1,
                myArrayType( myScalarType( 2, sysdate, 'hello' ) ),
                myTableType( myScalarType( 3, sysdate+1, 'GoodBye' ) )
                                 );

alter system switch logfile;

begin
   sys.dbms_logmnr.add_logfile( 'C:\oracle\rdbms\ARC00028.001',
                                 sys.dbms_logmnr.NEW );
end;
/

begin
   sys.dbms_logmnr.start_logmnr
   ( dictFileName => 'c:\temp\miner_dictionary.dat' );
end;
/

select scn, sql_redo, sql_undo
  from v$logmnr_contents
/