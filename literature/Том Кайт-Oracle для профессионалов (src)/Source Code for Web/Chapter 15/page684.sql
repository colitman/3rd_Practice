drop table t;
create table t ( msg varchar2(4000) );

create or replace procedure auto_proc
as
        pragma autonomous_transaction;
begin
        insert into t values ( 'A row for you' );
        commit;
end;
/

create or replace 
procedure proc( read_committed in boolean )
as
begin
        if ( read_committed ) then
                set transaction isolation level read committed;
        else
                set transaction isolation level serializable;
        end if;

        auto_proc;

        dbms_output.put_line( '--------' );
        for x in ( select * from t ) loop
                dbms_output.put_line( x.msg );
        end loop;
        dbms_output.put_line( '--------' );
        commit;
end;
/

exec proc( TRUE )

delete from t;

commit;

exec proc( FALSE )
