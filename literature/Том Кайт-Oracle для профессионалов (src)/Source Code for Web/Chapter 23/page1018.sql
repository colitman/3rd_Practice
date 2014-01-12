@connect tkyte/tkyte

drop table t;

create table t ( c1 int );

insert into t values ( 1 );

create or replace procedure P
authid current_user
as
        c2  number default 5;
begin
        update t set c1 = c2;
end;
/

exec p

select * from t;

grant execute on P to u1;

@connect u1/pw

drop table t;

create table t ( c1 int, c2 int );

insert into t values ( 1, 2 );

exec tkyte.p

select * from t;