
select substr(object_name,1,2)
  from all_objects t1
 where rownum = 1
/

alter session set cursor_sharing = force;

select substr(object_name,1,2)
  from all_objects t2
 where rownum = 1
/
