drop table t;

set echo on

create table t ( msg varchar2(50) );

create or replace function func return number
as
begin
        insert into t values
        ( 'I was inserted by FUNC' );
        return 0;
end;
/

declare
        x  number default func;
        pragma autonomous_transaction;
begin
        insert into t values
        ( 'I was inserted by anon block' );
        commit;
end;
/

select * from t;

rollback;

select * from t;

