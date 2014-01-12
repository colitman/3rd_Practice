set echo on

drop table t;

create table t ( x int primary key, y date )
organization index
OVERFLOW TABLESPACE  TOOLS
/

execute dbms_utility.analyze_schema('SCOTT','COMPUTE')

select table_name, num_rows, last_analyzed
  from user_tables
 where table_name = 'T';

drop table t;

create table t ( x int primary key, y date )
organization index
/

execute dbms_utility.analyze_schema('SCOTT','COMPUTE')

select table_name, num_rows, last_analyzed
  from user_tables
 where table_name = 'T';