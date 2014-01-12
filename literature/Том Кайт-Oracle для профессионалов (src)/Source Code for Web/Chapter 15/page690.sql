drop table t;

create table t ( msg varchar2(25) );

create or replace procedure auto_proc
as
    pragma AUTONOMOUS_TRANSACTION;
    x number;
begin
    insert into t values ('AutoProc');
    x := 'a'; -- This will fail 
    commit;
end;
/

create or replace procedure Regular_Proc
as
    x number;
begin
    insert into t values ('RegularProc');
    x := 'a'; -- This will fail
    commit;
end;
/

set serveroutput on

begin
    insert into t values ('Anonymous');
    auto_proc;
exception
    when others then
		dbms_output.put_line( 'Caught Error:' );
		dbms_output.put_line( sqlerrm );
        commit;
end;
/

select * from t;

delete from t;

commit;

begin
    insert into t values ('Anonymous');
    regular_proc;
exception
    when others then
		dbms_output.put_line( 'Caught Error:' );
		dbms_output.put_line( sqlerrm );
        commit;
end;
/

select * from t;
