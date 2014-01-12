drop table report_parm_table;


create table report_parm_table
( session_id   number,
  arg1         number,
  arg2         date
)
/


create or replace
procedure set_up_report( p_arg1 in number, p_arg2 in date )
as
begin
    delete from report_parm_table
    where session_id = sys_context('userenv','sessionid');

    insert into report_parm_table
    ( session_id, arg1, arg2 )
    values
    ( sys_context('userenv','sessionid'), p_arg1, p_arg2 );
end;
/

create or replace
function set_up_report_F( p_arg1 in number, p_arg2 in date )
return number
as
    pragma autonomous_transaction;
begin
    set_up_report( p_arg1, p_arg2 );
    commit;
    return 1;
exception
    when others then
        rollback;
        return 0;
end;
/


select set_up_report_F( 1, sysdate ) from dual
/

select * from report_parm_table

create or replace
function set_up_report_F( p_arg1 in number, p_arg2 in date )
return number
as
begin
    set_up_report( p_arg1, p_arg2 );
    return 1;
exception
    when others then
        rollback;
        return 0;
end;
/


select set_up_report_F( 1, sysdate ) from dual
/

select * from report_parm_table

