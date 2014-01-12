set echo on
set serveroutput on

connect system/manager

drop user dirlist cascade;


grant create session, create table, create procedure
to dirlist identified by dirlist;

connect dirlist/dirlist;

 begin
        dbms_java.grant_permission
        ('DIRLIST',
         'java.io.FilePermission',
             '\tmp',
             'read' );
    end;
/

connect dirlist/dirlist@tom

 create global temporary table DIR_LIST
   ( filename varchar2(255) )
   on commit delete rows;