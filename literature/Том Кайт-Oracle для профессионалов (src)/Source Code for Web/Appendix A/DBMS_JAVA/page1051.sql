@connect sys/manager

column long_nm format a30 word_wrapped
column short_nm format a30 

select dbms_java.longname(object_name) long_nm,
       dbms_java.shortname(dbms_java.longname(object_name)) short_nm
  from user_objects where object_type = 'JAVA CLASS'
   and rownum < 11
/