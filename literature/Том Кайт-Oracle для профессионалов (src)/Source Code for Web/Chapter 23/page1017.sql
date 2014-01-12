@connect tkyte/tkyte
drop table t;

create table t ( msg varchar2(25), c1 int, c2 int );

insert into t values ( 'c1=1, c2=2', 1, 2 );

create or replace procedure P
authid current_user
as
begin
    for x in ( select * from t ) loop
                dbms_output.put_line( 'msg= ' || x.msg );
                dbms_output.put_line( 'C1 = ' || x.c1 );
                dbms_output.put_line( 'C2 = ' || x.c2 );
    end loop;
end;
/

exec p
grant execute on P to u1;

@connect u1/pw

drop table t;
create table t ( msg varchar2(25), c2 int, c1 int );

insert into t values ( 'c1=2, c2=1', 1, 2 );

exec tkyte.p

