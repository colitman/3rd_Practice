@connect tkyte/tkyte

set echo on

drop table t;
drop table t2;
drop public synonym t;

create table t ( x int );

create table t2 ( x int );

create public synonym T for T;

create or replace procedure dr_proc
as
    l_cnt number;
begin
    select count(*) into l_cnt from t DEMO_DR;
end;
/

create or replace procedure ir_proc1
authid current_user
as
    l_cnt number;
begin
    select count(*) into l_cnt from t DEMO_IR_1;
end;
/

create or replace procedure ir_proc2
authid current_user
as
    l_cnt number;
begin
    select count(*) into l_cnt from tkyte.t DEMO_IR_2;
end;
/

create or replace procedure ir_proc3
authid current_user
as
    l_cnt number;
begin
    select count(*) into l_cnt from t2 DEMO_IR_3;
end;
/

grant select on t to public;

grant execute on dr_proc to public;

grant execute on ir_proc1 to public;

grant execute on ir_proc2 to public;

grant execute on ir_proc3 to public;


begin
    for i in 1 .. 10 loop
        begin
            execute immediate 'drop user u' || i || ' cascade';
        exception
            when others then null;
        end;
		execute immediate 'create user u'||i || ' identified by pw';
        execute immediate 'grant create session, create table to u'||i;
        execute immediate 'alter user u' || i || ' default tablespace
                       data quota unlimited on data';
    end loop;
end;
/

@examp10a 1
@examp10a 2
@examp10a 3
@examp10a 4
@examp10a 5
@examp10a 6
@examp10a 7
@examp10a 8
@examp10a 9
@examp10a 10

@connect tkyte/tkyte

set serveroutput on size 1000000
begin
  print_table ('select sql_text, sharable_mem, version_count,
                       loaded_versions, parse_calls, optimizer_mode
                  from v$sqlarea
                 where sql_text like ''% DEMO\__R%'' escape ''\''
                   and lower(sql_text) not like ''%v$sqlarea%'' ');
end;
/

