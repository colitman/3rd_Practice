set echo on
set serveroutput on


create tablespace tts_ex1
  datafile 'c:\oracle\oradata\tkyte\tts_ex1.dbf' size 1m
  extent management local uniform size 64k;


create tablespace tts_ex2
  datafile 'c:\oracle\oradata\tkyte\tts_ex2.dbf' size 1m
  extent management local uniform size 64k


create user tts_user identified by tts_user
  default tablespace tts_ex1
  temporary tablespace temp;

grant dba to tts_user;


connect tts_user/tts_user;


create table emp as select * from scott.emp;


create table dept as select * from scott.dept;

create index emp_idx on emp(empno) tablespace tts_ex2;


create index dept_idx on dept(deptno) tablespace tts_ex2;


select object_type, object_name,
                decode(status,'INVALID','*','') status,
                tablespace_name
from user_objects a, user_segments b
where a.object_name = b.segment_name (+)
order by object_type, object_name;
/
